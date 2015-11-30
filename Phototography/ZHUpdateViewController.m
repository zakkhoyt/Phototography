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

@interface ZHUpdateViewController ()
@property (weak, nonatomic) IBOutlet VWWClusteredMapView *clusteredMapView;
@property (nonatomic, strong) NSArray *assets;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)findNearbyPhotos{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Locating...";
    
#if TARGET_IPHONE_SIMULATOR
    CLLocation *location = [[CLLocation alloc]initWithLatitude:37.75 longitude:-122.45];
    [[ZHLocationManager sharedInstance] updateToLocation:location completionBlock:^(CLLocation *location) {

        ZHUser *currentUser = [ZHUser currentUser];
        currentUser.location = location;
        
        // Get assets for self near location
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
                [self.clusteredMapView reloadData];
            }
            
        }];

    }];
    
#else
    [[ZHLocationManager sharedInstance] updateToCurrentLocationWithCompletionBlock:^(CLLocation *location) {
        ZHUser *currentUser = [ZHUser currentUser];
        currentUser.location = location;
        AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
        [appDelegate.cloudManager updateUser:currentUser completionBlock:^(ZHUser *user, NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if(error != nil) {
                [self presentAlertDialogWithTitle:@"Could not update location" errorAsMessage:error];
            } else {
                [self.clusteredMapView reloadData];
            }
        }];
    }];
#endif
    
    
    

//    -(void)getAssetsNearLocation:(CLLocation*)location ownerUUID:(NSString*)ownerUUID completionBlock:(ZHCloudManagerArrayErrorBlock)completionBlock
    


}


- (IBAction)refreshBarButtonAction:(id)sender {
    [self findNearbyPhotos];
}

@end



@implementation ZHUpdateViewController (VWWClusteredMapViewDataSource)
- (NSInteger)numberOfSectionsInMapView:(VWWClusteredMapView*)mapView{
    return 1;
}
- (NSInteger)mapView:(VWWClusteredMapView*)mapView numberOfAnnotationsInSection:(NSInteger)section{
    
    return self.assets.count;
}

- (id<MKAnnotation>)mapView:(VWWClusteredMapView*)mapView annotationForItemAtIndexPath:(NSIndexPath *)indexPath{
    return self.assets[indexPath.item];
}

@end

@implementation ZHUpdateViewController (VWWClusteredMapViewDelegate)

-(VWWClusteredAnnotationView *)clusteredMapView:(VWWClusteredMapView *)clusteredMapView viewForClusteredAnnotation:(VWWClusteredAnnotation*)annotation {
    
    if([annotation isKindOfClass:[MKUserLocation class]]){
        return nil;
    }
    
    id obj = [annotation.annotations firstObject];
    if([obj isKindOfClass:[ZHAssetAnnotation class]]){
        ZHAssetAnnotationView *annotationView = (ZHAssetAnnotationView*)[clusteredMapView dequeueReusableAnnotationViewWithIdentifier:@"ZHAssetAnnotationView"];
        if(annotationView == nil){
            annotationView = [[ZHAssetAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"ZHAssetAnnotationView"];
            annotationView.annotation = annotation;
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
