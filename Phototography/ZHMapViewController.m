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

    // Let's get started

    self.clusteredMapView.delegate = self;
    self.clusteredMapView.dataSource = self;
    self.clusteredMapView.addAnimationType = VWWClusteredMapViewAnnotationAddAnimationGrowStaggered;
    self.clusteredMapView.removeAnimationType = VWWClusteredMapViewAnnotationRemoveAnimationAutomatic;
    self.clusteredMapView.showsUserLocation = YES;
    [self refreshMapView];

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

#pragma mark Private methods

-(void)refreshMapView{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Reading...";
    
    [[ZHAssetManager sharedInstance] getAssetsWithLocationWithCompletionBlock:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        if(error){
            NSLog(@"Error reading assets");
        } else {
//            self.items = [ZHAssetManager sharedInstance].assetsNoLocation;
            NSMutableArray *items = [[NSMutableArray alloc] initWithCapacity:[ZHAssetManager sharedInstance].assetsNoLocation.count];
            [[ZHAssetManager sharedInstance].assetsNoLocation enumerateObjectsUsingBlock:^(PHAsset *_Nonnull asset, NSUInteger idx, BOOL * _Nonnull stop) {
                ZHAssetAnnotation *annotation = [[ZHAssetAnnotation alloc]initWithAsset:asset];
                [items addObject:annotation];
            }];
            self.items = items;
            
            self.navigationItem.title = [NSString stringWithFormat:@"%lu/%lu",
                                         (unsigned long)[ZHAssetManager sharedInstance].assetsNoLocation.count,
                                         (unsigned long)[ZHAssetManager sharedInstance].assets.count];
            [self.clusteredMapView reloadData];
        }
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
//    CLLocationCoordinate2D coordinate = [view.annotation coordinate];
    
//    [self showDetailsForAnnotationView:view coordinate:coordinate];
}

@end


