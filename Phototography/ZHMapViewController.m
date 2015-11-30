//
//  ZHMapViewController.m
//  Phototography
//
//  Created by Zakk Hoyt on 10/5/15.
//  Copyright © 2015 Zakk Hoyt. All rights reserved.
//

#import "ZHMapViewController.h"
#import "ZHAssetManager.h"
#import "VWWClusteredMapView.h"
#import "ZHAssetAnnotation.h"
#import "ZHAssetAnnotationView.h"
#import "ZHAssetGroupViewController.h"
#import "ZHAsset.h"

static NSString *SegueMapToAssetGroup = @"SegueMapToAssetGroup";

@interface ZHMapViewController ()
@property (weak, nonatomic) IBOutlet VWWClusteredMapView *clusteredMapView;
@property (nonatomic, strong) NSMutableArray *items;
@end

@interface ZHMapViewController (VWWClusteredMapViewDataSource) <VWWClusteredMapViewDataSource>
@end

@interface ZHMapViewController (VWWClusteredMapViewDelegate) <VWWClusteredMapViewDelegate>
@end


@implementation ZHMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"Map";

    self.clusteredMapView.mapType = MKMapTypeHybridFlyover;
    self.clusteredMapView.delegate = self;
    self.clusteredMapView.dataSource = self;
    self.clusteredMapView.addAnimationType = VWWClusteredMapViewAnnotationAddAnimationGrowStaggered;
    self.clusteredMapView.removeAnimationType = VWWClusteredMapViewAnnotationRemoveAnimationAutomatic;
    self.clusteredMapView.showsUserLocation = YES;
    [self refreshMapView];

}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarHidden = YES;
    self.navigationController.navigationBarHidden = YES;
    self.tabBarController.tabBar.hidden = NO;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarHidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:SegueMapToAssetGroup]){
        ZHAssetGroupViewController *vc = segue.destinationViewController;
        vc.assets = sender;
        self.tabBarController.tabBar.hidden = YES;
    }
}

#pragma mark Private methods

-(void)refreshMapView{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Reading...";
    
    [[ZHAssetManager sharedInstance] getAssetsWithCompletionBlock:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        if(error){
            NSLog(@"Error reading assets");
        } else {
            NSMutableArray *items = [[NSMutableArray alloc] initWithCapacity:[ZHAssetManager sharedInstance].assetsNoLocation.count];
            [[ZHAssetManager sharedInstance].assetsWithLocation enumerateObjectsUsingBlock:^(PHAsset *_Nonnull asset, NSUInteger idx, BOOL * _Nonnull stop) {
                ZHAssetAnnotation *annotation = [[ZHAssetAnnotation alloc]initWithAsset:asset];
                [items addObject:annotation];
            }];
            self.items = items;
            
            [self.clusteredMapView reloadData];
        }
        
//        NSMutableArray *userAssets = [[NSMutableArray alloc]initWithCapacity:[ZHAssetManager sharedInstance].assetsWithLocation.count];
//        [[ZHAssetManager sharedInstance].assetsWithLocation enumerateObjectsUsingBlock:^(PHAsset*  _Nonnull phAsset, NSUInteger idx, BOOL * _Nonnull stop) {
//            ZHAsset *asset = [[ZHAsset alloc]initWithAsset:phAsset];
//            [userAssets addObject:asset];
//        }];
//        [ZHUser currentUser].assets = userAssets;
//        
//        AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
//        [appDelegate.cloudManager updateAssets:[ZHUser currentUser].assets completionBlock:^(NSError *error) {
//            if(error) {
//                [self presentAlertDialogWithTitle:@"Failed to save assets" errorAsMessage:error];
//            } else {
//                [self presentAlertDialogWithMessage:@"Saved asset(s)"];
//            }
//        }];
    }];
}

@end


@implementation ZHMapViewController (VWWClusteredMapViewDataSource)
- (NSInteger)numberOfSectionsInMapView:(VWWClusteredMapView*)mapView{
    return 1;
}
- (NSInteger)mapView:(VWWClusteredMapView*)mapView numberOfAnnotationsInSection:(NSInteger)section{
    return self.items.count;
}

- (id<MKAnnotation>)mapView:(VWWClusteredMapView*)mapView annotationForItemAtIndexPath:(NSIndexPath *)indexPath{
    return self.items[indexPath.item];
}

@end

@implementation ZHMapViewController (VWWClusteredMapViewDelegate)

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
    NSLog(@"annotationView.class: %@", NSStringFromClass([view class]));
    VWWClusteredAnnotation *annotation = (VWWClusteredAnnotation*)view.annotation;
    NSArray *assets = [annotation.annotations valueForKeyPath:@"asset"];
    [self performSegueWithIdentifier:SegueMapToAssetGroup sender:assets];
    
    
}

@end


