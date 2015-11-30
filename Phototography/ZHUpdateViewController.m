//
//  ZHUpdateViewController.m
//  Phototography
//
//  Created by Zakk Hoyt on 11/29/15.
//  Copyright © 2015 Zakk Hoyt. All rights reserved.
//

#import "ZHUpdateViewController.h"
#import "VWWClusteredMapView.h"
#import "ZHAssetAnnotation.h"
#import "ZHAssetAnnotationView.h"
#import "ZHLocationManager.h"
#import "ZHCloudManager.h"
#import "ZHAssetAnnotation.h"
#import "ZHAssetAnnotationView.h"
#import "ZHUserAnnotationView.h"

@interface ZHUpdateViewController ()
@property (weak, nonatomic) IBOutlet VWWClusteredMapView *clusteredMapView;
@property (nonatomic, strong) NSArray *userAssets;
@end

@interface ZHUpdateViewController (VWWClusteredMapViewDataSource) <VWWClusteredMapViewDataSource>
@end

@interface ZHUpdateViewController (VWWClusteredMapViewDelegate) <VWWClusteredMapViewDelegate>
@end


@implementation ZHUpdateViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.clusteredMapView.mapType = MKMapTypeHybridFlyover;
    self.clusteredMapView.delegate = self;
    self.clusteredMapView.dataSource = self;
    self.clusteredMapView.addAnimationType = VWWClusteredMapViewAnnotationAddAnimationGrowStaggered;
    self.clusteredMapView.removeAnimationType = VWWClusteredMapViewAnnotationRemoveAnimationAutomatic;
    self.clusteredMapView.showsUserLocation = YES;

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self findNearbyPhotos];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)findNearbyPhotos{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Locating...";
    
#if TARGET_IPHONE_SIMULATOR
    CLLocation *location = [[CLLocation alloc]initWithLatitude:37.75 longitude:-122.45];
    [[ZHLocationManager sharedInstance] updateToLocation:location completionBlock:^(CLLocation *location) {

        ZHUser *currentUser = [ZHUser currentUser];
        currentUser.location = location;
        
        /// ** Updates currentUser's location
//        AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
//        [appDelegate.cloudManager updateUser:currentUser completionBlock:^(ZHUser *user, NSError *error) {
//            [MBProgressHUD hideHUDForView:self.view animated:YES];
//            if(error != nil) {
//                [self presentAlertDialogWithTitle:@"Could not update location" errorAsMessage:error];
//            } else {
//                [self.clusteredMapView reloadData];
//            }
//        }];
        
        /// ******* get assets for all friends near location
        AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
        [appDelegate.cloudManager getAssetsNearLocation:location completionBlock:^(NSArray *userAssets, NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if(error != nil) {
                [self presentAlertDialogWithTitle:@"Could not update location" errorAsMessage:error];
            } else {
                [self presentAlertDialogWithMessage:[NSString stringWithFormat:@"Found %lu assets", (unsigned long)userAssets.count]];
                self.userAssets = userAssets;
                [self.clusteredMapView reloadData];
            }
        }];
    }];
    
#else
    [[ZHLocationManager sharedInstance] updateToCurrentLocationWithCompletionBlock:^(CLLocation *location) {
        
        MKCoordinateSpan span = MKCoordinateSpanMake(0.1, 0.1);
        MKCoordinateRegion region = MKCoordinateRegionMake(location.coordinate, span);
        [self.clusteredMapView setRegion:region animated:YES];
        
        ZHUser *currentUser = [ZHUser currentUser];
        currentUser.location = location;
        
        /// ** Updates currentUser's location
//        AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
//        [appDelegate.cloudManager updateUser:currentUser completionBlock:^(ZHUser *user, NSError *error) {
//            [MBProgressHUD hideHUDForView:self.view animated:YES];
//            if(error != nil) {
//                [self presentAlertDialogWithTitle:@"Could not update location" errorAsMessage:error];
//            } else {
//                [self.clusteredMapView reloadData];
//            }
//        }];
        
        /// ******* get assets for all friends near location
        AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
        [appDelegate.cloudManager getAssetsNearLocation:location completionBlock:^(NSArray *userAssets, NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if(error != nil) {
                [self presentAlertDialogWithTitle:@"Could not update location" errorAsMessage:error];
            } else {
                [self presentAlertDialogWithMessage:[NSString stringWithFormat:@"Found %lu users with assets", (unsigned long)userAssets.count]];
                self.userAssets = userAssets;
                [self.clusteredMapView reloadData];
            }
        }];

    }];
#endif

}


- (IBAction)refreshBarButtonAction:(id)sender {
    [self findNearbyPhotos];
}

@end



@implementation ZHUpdateViewController (VWWClusteredMapViewDataSource)
- (NSInteger)numberOfSectionsInMapView:(VWWClusteredMapView*)mapView{
    return self.userAssets.count;
}
- (NSInteger)mapView:(VWWClusteredMapView*)mapView numberOfAnnotationsInSection:(NSInteger)section{
    NSDictionary *dictionary = self.userAssets[section];
    NSArray *assets = dictionary[@"assets"];
    return assets.count;
}

- (id<MKAnnotation>)mapView:(VWWClusteredMapView*)mapView annotationForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dictionary = self.userAssets[indexPath.section];
    NSArray *assets = dictionary[@"assets"];
    ZHAssetAnnotation *annotation = [[ZHAssetAnnotation alloc]initWithAsset:assets[indexPath.row]];
    return annotation;
}

@end

@implementation ZHUpdateViewController (VWWClusteredMapViewDelegate)

-(VWWClusteredAnnotationView *)clusteredMapView:(VWWClusteredMapView *)clusteredMapView viewForClusteredAnnotation:(VWWClusteredAnnotation*)annotation {
    
    if([annotation isKindOfClass:[MKUserLocation class]]){
        return nil;
    }
    
    id obj = [annotation.annotations firstObject];
    if([obj isKindOfClass:[ZHAssetAnnotation class]]){
        ZHUserAnnotationView *annotationView = (ZHUserAnnotationView*)[clusteredMapView dequeueReusableAnnotationViewWithIdentifier:@"ZHUserAnnotationView"];
        if(annotationView == nil){
            annotationView = [[ZHUserAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"ZHUserAnnotationView"];
            annotationView.annotation = annotation;
            annotationView.user = [ZHUser currentUser];
        }
        annotationView.count = annotation.annotations.count;
        return annotationView;
    }

    return nil;
}

- (void)clusteredMapView:(VWWClusteredMapView *)clusteredMapView didSelectClusteredAnnotationView:(VWWClusteredAnnotationView *)view {
//    NSLog(@"annotationView.class: %@", NSStringFromClass([view class]));
//    VWWClusteredAnnotation *annotation = (VWWClusteredAnnotation*)view.annotation;
//    //    PHAssetCollection *assetCollection = [PHAssetCollection transientAssetCollectionWithAssets:annotation.annotations title:nil];
//    NSArray *assets = [annotation.annotations valueForKeyPath:@"asset"];
//    [self performSegueWithIdentifier:SegueMapToAssetGroup sender:assets];
    
    [self presentAlertDialogWithMessage:@"TODO: Show photos"];
}

@end
