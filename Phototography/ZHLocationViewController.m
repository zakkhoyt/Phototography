//
//  ZHLocationViewController.m
//  ;
//
//  Created by Zakk Hoyt on 10/2/15.
//  Copyright © 2015 Zakk Hoyt. All rights reserved.
//

#import "ZHLocationViewController.h"
@import MapKit;
@import CoreLocation;
#import "ZHAssetManager.h"
#import "PHAsset+Utility.h"
#import "ZHPin.h"
#import "ZHLocationSearchTableViewController.h"

typedef void (^ZHLocationViewControllerEmptyBlock)();
typedef void (^ZHLocationViewControllerSearchResponseBlock)(MKLocalSearchResponse *response);

@interface ZHLocationViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) ZHLocationViewControllerEmptyBlock performAfterUpdatingLocation;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic) CLLocationCoordinate2D coordinate;
@end

@interface ZHLocationViewController (MKMapViewDelegate) <MKMapViewDelegate>
@end


@implementation ZHLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mapView.mapType = MKMapTypeHybridFlyover;
    
    __weak typeof(self) welf = self;
    [self setPerformAfterUpdatingLocation:^(){
        MKCoordinateSpan span = MKCoordinateSpanMake(0.1, 0.1);
        MKCoordinateRegion region = MKCoordinateRegionMake(welf.mapView.userLocation.coordinate, span);
        [welf.mapView setRegion:region animated:YES];
    }];
    
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
    [self.view addGestureRecognizer:longPressGesture];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if(self.locationManager == nil){
        self.locationManager = [CLLocationManager new];
        //        self.locationManager.delegate = self;
    }
    
    [self.locationManager requestAlwaysAuthorization];
    
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


#pragma mark IBActions
- (IBAction)currentBarButtonAction:(id)sender {
    
}


- (IBAction)searchBarButtonAction:(id)sender {
    ZHLocationSearchTableViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ZHLocationSearchTableViewController"];
    [vc setCoordinateBlock:^(CLLocationCoordinate2D coordinate) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.mapView removeAnnotations:self.mapView.annotations];
            ZHPin *annotation = [[ZHPin alloc] initWithCoordinate:coordinate];
            [self.mapView addAnnotation:annotation];
            [self.mapView setCenterCoordinate:coordinate animated:YES];
            [self dismissViewControllerAnimated:YES completion:NULL];
        });
    }];
    UISearchController *sc = [[UISearchController alloc]initWithSearchResultsController:vc];
    sc.searchBar.tintColor = [UIColor zhTintColor];
    sc.searchResultsUpdater = vc;
    [self presentViewController:sc animated:YES completion:NULL];
}

- (IBAction)saveButtonAction:(id)sender {

    CLLocation *location = [[CLLocation alloc]initWithLatitude:self.coordinate.latitude longitude:self.coordinate.longitude];
    [self.asset updateLocation:location creationDate:nil completionBlock:^(BOOL success) {
        if(success){
            NSLog(@"Success (color pin green)");
            [self.mapView removeAnnotations:self.mapView.annotations];
        } else {
            NSLog(@"Failed (color pin red)");
        }
    }];
}

- (void)longPress:(UILongPressGestureRecognizer*)sender {
    if (sender.state == UIGestureRecognizerStateBegan){
        [self.mapView removeAnnotations:self.mapView.annotations];
        
        CGPoint touchPoint = [sender locationInView:self.mapView];
        CLLocationCoordinate2D coordinate = [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
        ZHPin *annotation = [[ZHPin alloc] initWithCoordinate:coordinate];
        [self.mapView addAnnotation:annotation];
    }
}

@end

#pragma mark MKMapViewDelegate
@implementation ZHLocationViewController (MKMapViewDelegate)

//- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
//    NSLog(@"");
//}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    if(_performAfterUpdatingLocation){
        _performAfterUpdatingLocation();
        _performAfterUpdatingLocation = nil;
    }
}

- (nullable MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation{
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    MKPinAnnotationView *pinView = (MKPinAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:@"pin"];
    if(pinView == nil){
        pinView = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"pin"];
        pinView.pinTintColor = self.asset.location ? [UIColor greenColor] : [UIColor blueColor];
    }
    
    return pinView;
}

@end

