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
#import "GHContextMenuView.h"

static NSString *SegueMapToAssetGroup = @"SegueMapToAssetGroup";

@interface ZHMapViewController ()
@property (weak, nonatomic) IBOutlet VWWClusteredMapView *clusteredMapView;
@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, strong) GHContextMenuView* contextMenuView;
@end

@interface ZHMapViewController (VWWClusteredMapViewDataSource) <VWWClusteredMapViewDataSource>
@end

@interface ZHMapViewController (VWWClusteredMapViewDelegate) <VWWClusteredMapViewDelegate>
@end

@interface ZHMapViewController (GHContextOverlayViewDelegate) <GHContextOverlayViewDelegate>
@end

@interface ZHMapViewController (GHContextOverlayViewDataSource) <GHContextOverlayViewDataSource>
-(void)setupContextMenu;
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
    
    
    [self setupContextMenu];

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



@implementation ZHMapViewController (GHContextOverlayViewDataSource)
-(void)setupContextMenu{
    self.contextMenuView = [[GHContextMenuView alloc] initWithFrame:self.view.bounds];
    self.contextMenuView.dataSource = self;
    self.contextMenuView.delegate = self;

    
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self.contextMenuView action:@selector(longPressDetected:)];
    [self.view addGestureRecognizer:longPressGesture];
}
#pragma mark IBActions
-(void)longPressDetected:(UILongPressGestureRecognizer*)sender{

}


#pragma mark YALContextMenuTableViewDelegate
- (NSInteger) numberOfMenuItems {
    return 4;
}

-(UIImage*) imageForItemAtIndex:(NSInteger)index
{
    NSString* imageName = nil;
    switch (index) {
            break;
        case 0:{
            return [UIImage imageNamed:@"ic_location"];
        }
            break;
            
        case 1:{
            return [UIImage imageNamed:@"ic_zoom_in"];
        }
            break;

        case 2:{
            return [UIImage imageNamed:@"ic_zoom_out"];
        }

        case 3:{
            return [UIImage imageNamed:@"ic_globe"];
        }

            break;

        default:
            break;
    }
    return [UIImage imageNamed:imageName];
}


@end


@implementation ZHMapViewController (GHContextOverlayViewDelegate)

- (void) didSelectItemAtIndex:(NSInteger)selectedIndex forMenuAtPoint:(CGPoint)point{
    switch (selectedIndex) {
        case 0:{
//            MKCoordinateRegion region = MKCoordinateRegionMake(self.clusteredMapView.userLocation.coordinate, MKCoordinateSpanMake(0.005, 0.005));
//            [self.clusteredMapView setRegion:region animated:YES];
            [self.clusteredMapView setCenterCoordinate:self.clusteredMapView.userLocation.coordinate animated:YES];

        }
            break;
        case 1:{
            CLLocationCoordinate2D coordinate = [self.clusteredMapView convertPoint:point toCoordinateFromView:self.clusteredMapView];
            MKCoordinateRegion region = MKCoordinateRegionMake(coordinate, MKCoordinateSpanMake(0.005, 0.005));
            [self.clusteredMapView setRegion:region animated:YES];
        }
            break;
            
        case 2:{
            MKCoordinateRegion region = MKCoordinateRegionMake(self.clusteredMapView.region.center, MKCoordinateSpanMake(45, 90));
            [self.clusteredMapView setRegion:region animated:YES];
        }
            break;
            
        case 3:{
            UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"Map Type" message:nil preferredStyle:UIAlertControllerStyleAlert];
            
            NSString *mapString = nil;
            if(self.clusteredMapView.mapType == MKMapTypeStandard){
                mapString = @"📍 Map 📍";
            } else {
                mapString = @"Map";
            }
            [ac addAction:[UIAlertAction actionWithTitle:mapString style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                self.clusteredMapView.mapType = MKMapTypeStandard;
            }]];
            
            NSString *satelliteString = nil;
            if(self.clusteredMapView.mapType == MKMapTypeSatellite ||
               self.clusteredMapView.mapType == MKMapTypeSatelliteFlyover){
                satelliteString = @"📍 Satellite 📍";
            } else {
                satelliteString = @"Satellite";
            }
            
            [ac addAction:[UIAlertAction actionWithTitle:satelliteString style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                self.clusteredMapView.mapType = MKMapTypeSatelliteFlyover;
            }]];
            
            NSString *hybridString = nil;
            if(self.clusteredMapView.mapType == MKMapTypeHybrid ||
               self.clusteredMapView.mapType == MKMapTypeHybridFlyover){
                hybridString = @"📍 Hybrid 📍";
            } else {
                hybridString = @"Hybrid";
            }
            
            [ac addAction:[UIAlertAction actionWithTitle:hybridString style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                self.clusteredMapView.mapType = MKMapTypeHybridFlyover;
            }]];
            
            [ac addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }]];
            
            [self presentViewController:ac animated:YES completion:NULL];
            
        }
            break;
        default:
            break;
    }
}

@end



