//
//  ZHAssetManager.m
//  Phototography
//
//  Created by Zakk Hoyt on 10/2/15.
//  Copyright © 2015 Zakk Hoyt. All rights reserved.
//

#import "ZHAssetManager.h"
@import CoreLocation;
@import Photos;



@interface ZHAssetManager ()
@property (nonatomic, strong) PHCachingImageManager *imageManager;

@end

@interface ZHAssetManager (PHPhotoLibraryChangeObserver) <PHPhotoLibraryChangeObserver>
@end

@implementation ZHAssetManager

+(ZHAssetManager*)sharedInstance{
    static ZHAssetManager *instance;
    if(instance == nil){
        instance = [[ZHAssetManager alloc]initSingleton];
    }
    return instance;
}

- (instancetype)init {
    NSAssert(NO, @"Must use sharedInstance");
    return nil;
}

- (instancetype)initSingleton {
    self = [super init];
    if (self) {
        _imageManager = [[PHCachingImageManager alloc] init];
        [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
    }
    return self;
}

-(void)dealloc{
    [[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];
}

-(void)getAssetsWithoutLocationWithCompletionBlock:(ZHAssetManagerErrorBlock)completionBlock{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        PHFetchOptions *options = [[PHFetchOptions alloc] init];
        options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
        PHFetchResult *results = [PHAsset fetchAssetsWithOptions:options];
        
        self.assets = [[NSMutableArray alloc]initWithCapacity:results.count];
        self.assetsNoLocation = [[NSMutableArray alloc]initWithCapacity:results.count];
        [results enumerateObjectsUsingBlock:^(PHAsset *asset, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.assets addObject:asset];
            if(asset.location == nil){
                [self.assetsNoLocation addObject:asset];
            }
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock(nil);
        });
    });
}

@end

@implementation ZHAssetManager (PHPhotoLibraryChangeObserver)

- (void)photoLibraryDidChange:(PHChange *)changeInstance {
    
    //    PHFetchResultChangeDetails *changeDetails = [changeInstance changeDetailsForFetchResult:self.moments];
    //
    //    if(changeDetails.changedIndexes){
    //        PK_LOG_DEBUG(@"Detected that object(s) changed at indexes: %@", changeDetails.changedIndexes.description);
    //        NSMutableArray *changedMoments = [[NSMutableArray alloc]initWithCapacity:changeDetails.changedIndexes.count];
    //        [changeDetails.changedIndexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
    //            PHAssetCollection *moment = self.moments[idx];
    //            [changedMoments addObject:moment];
    //        }];
    //        if(changedMoments.count){
    //            NSDictionary *dictionary = @{@"changedMoments" : changedMoments};
    //            [[NSNotificationCenter defaultCenter] postNotificationName:PKAssetManagerMomentsChanged object:nil userInfo:dictionary];
    //        }
    //    }
}


@end

@implementation ZHAssetManager (Images)

//-(void)requestResizedImageForAsset:(PHAsset*)phAsset
//                              size:(CGSize)size
//                     progressBlock:(ZHAssetManagerFloatBlock)progressBlock
//                   completionBlock:(ZHAssetManagerImageErrorBlock)completionBlock{
//    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
//    options.networkAccessAllowed = YES;
//    options.deliveryMode = PHImageRequestOptionsDeliveryModeFastFormat;
//    options.resizeMode = PHImageRequestOptionsResizeModeFast;
//    [options setSynchronous:YES];
//    options.progressHandler = ^(double progress, NSError *error, BOOL *stop, NSDictionary *info) {
//        
//    };
//    
//    [_imageManager requestImageForAsset:phAsset targetSize:size contentMode:PHImageContentModeAspectFit options:options resultHandler:^(UIImage *result, NSDictionary *info) {
//        completionBlock(result, nil);
//    }];
//}

-(void)requestResizedImageForAsset:(PHAsset*)phAsset
                         imageView:(UIImageView*)imageView
                     progressBlock:(ZHAssetManagerFloatBlock)progressBlock
                   completionBlock:(ZHAssetManagerErrorBlock)completionBlock{
    
    void (^cleanUp)(NSError* error) = ^(NSError* error){
        dispatch_async(dispatch_get_main_queue(), ^{
            [imageView layoutIfNeeded];
            completionBlock(error);
        });
    };
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
        options.networkAccessAllowed = YES;
        options.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;
        options.resizeMode = PHImageRequestOptionsResizeModeExact;
        options.progressHandler = ^(double progress, NSError *error, BOOL *stop, NSDictionary *info) {
            dispatch_async(dispatch_get_main_queue(), ^{
                // Call progress block
                dispatch_async(dispatch_get_main_queue(), ^{
                    progressBlock(progress);
                });
                
                // Call completion block
                if(error){
                    cleanUp(error);
                }
                if(progress == 1.0){
                    cleanUp(nil);
                }
                
            });
        };
        
        CGFloat scale = [[UIScreen mainScreen]scale];
        CGSize size = CGSizeMake(imageView.bounds.size.width * scale, imageView.bounds.size.height * scale);
        //        PK_LOG_DEBUG(@"Requesting image for imageView of size %@", NSStringFromCGSize(size));
        [_imageManager requestImageForAsset:phAsset targetSize:size contentMode:PHImageContentModeAspectFit options:options resultHandler:^(UIImage *result, NSDictionary *info) {
            //        PK_LOG_DEBUG(@"info for asset: %@", info.description);
            if(info[PHImageResultIsInCloudKey]){
                // Call completion block from above
                if(result){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [imageView setImage:result];
                    });
                }
                
            } else {
                if(result){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [imageView setImage:result];
                    });
                }
                cleanUp(nil);
            }
        }];
    });
}

@end