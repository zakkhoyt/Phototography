//
//  ZHAssetManager.h
//  Phototography
//
//  Created by Zakk Hoyt on 10/2/15.
//  Copyright © 2015 Zakk Hoyt. All rights reserved.
//

#import <Foundation/Foundation.h>
@import Photos;

typedef void (^ZHAssetManagerErrorBlock)(NSError *error);
typedef void (^ZHAssetManagerFloatBlock)(float progress);



@interface ZHAssetManager : NSObject
+(ZHAssetManager*)sharedInstance;

@property (nonatomic, strong) NSMutableArray *moments;
@property (nonatomic, strong) NSMutableArray *assets;
@property (nonatomic, strong) NSMutableArray *assetsNoLocation;



-(void)getAssetsWithoutLocationWithCompletionBlock:(ZHAssetManagerErrorBlock)completionBlock;
//-(void)getMomentsWithoutLocationWithCompletionBlock:(ZHAssetManagerMutableArrayBlock)completionBlock;

-(void)writeLocation:(CLLocation*)location toAssetAtIndex:(NSUInteger)index completionBlock:(ZHAssetManagerErrorBlock)completionBlock;

@end


@interface ZHAssetManager (Images)

-(void)requestResizedImageForAsset:(PHAsset*)asset
                         imageView:(UIImageView*)imageView
                     progressBlock:(ZHAssetManagerFloatBlock)progressBlock
                   completionBlock:(ZHAssetManagerErrorBlock)completionBlock;

@end
