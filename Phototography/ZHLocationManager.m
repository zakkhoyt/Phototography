//
//  ZHLocationManager.m
//  Phototography
//
//  Created by Zakk Hoyt on 11/28/15.
//  Copyright © 2015 Zakk Hoyt. All rights reserved.
//

#import "ZHLocationManager.h"
#import "ZHLocationUpdate.h"

@interface ZHLocationManager ()
@property (nonatomic, strong) NSMutableArray *updates;
@property (nonatomic, strong) CLLocation *lastLocation;
@property (nonatomic, strong) CLLocationManager *locationManager;
//@property (nonatomic, strong) PKLocationMonitorLocationErrorBlock locationBlock;
@property (nonatomic, strong) NSTimer *acquireLocationTimer;
@property (nonatomic, strong) ZHLocationManagerLocationBlock accurateLocationBlock;
@end

@interface ZHLocationManager (CLLocationManagerDelegate) <CLLocationManagerDelegate>
@end

@implementation ZHLocationManager

#pragma mark Public methods

+(ZHLocationManager*)sharedInstance{
    static ZHLocationManager *instance;
    if(instance == nil){
        instance = [[ZHLocationManager alloc]init];
    }
    return instance;
}

-(id)init{
    self = [super init];
    if(self){
        _updates = [@[]mutableCopy];
        _locationManager = [[CLLocationManager alloc]init];
        _locationManager.delegate = self;
        [_locationManager requestWhenInUseAuthorization];
    }
    return self;
}

-(void)getBroadLocation{
    [_locationManager stopMonitoringSignificantLocationChanges];
    [_locationManager stopUpdatingLocation];
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    [self.locationManager setDistanceFilter:500];
    [_locationManager startMonitoringSignificantLocationChanges];
}

-(void)getAccurateLocation{
    [self.locationManager stopUpdatingLocation];
//    [self.locationManager stopMonitoringSignificantLocationChanges];
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    [self.locationManager setDistanceFilter:500];
    [self.locationManager startUpdatingLocation];
}

-(void)locationManagerAuthorizationStatus:(CLAuthorizationStatus)status{
    
    switch(status){
        case kCLAuthorizationStatusAuthorizedAlways:
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            NSLog(@"Should be okay to recieve locations");
            break;
        case kCLAuthorizationStatusNotDetermined:
            [_locationManager requestWhenInUseAuthorization];
            break;
        case kCLAuthorizationStatusRestricted:
        case kCLAuthorizationStatusDenied:
            NSLog(@"Use has CoreLocation permissions disabled");
            break;
    }
}


-(NSArray*)updates{
    return [NSArray arrayWithArray:_updates];
}

-(void)updateToCurrentLocationWithCompletionBlock:(ZHLocationManagerLocationBlock)completionBlock {
    _accurateLocationBlock = completionBlock;
    [self getAccurateLocation];
}

-(void)updateToLocation:(CLLocation*)location completionBlock:(ZHLocationManagerLocationBlock)completionBlock{
    ZHLocationUpdate *update = [ZHLocationUpdate new];
    update.location = location;
    update.date = [NSDate date];
    [_updates addObject:update];
    completionBlock(location);
}


@end


@implementation ZHLocationManager (CLLocationManagerDelegate)

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {

    CLLocation *newLocation = [locations lastObject];
    if(newLocation){
        
        NSLog(@"Acquired GPS location: %@", newLocation.description);
        
        ZHLocationUpdate *update = [ZHLocationUpdate new];
        update.location = newLocation;
        update.date = [NSDate date];
        [_updates addObject:update];
        
        if(self.accurateLocationBlock){
            self.accurateLocationBlock(newLocation);
            self.accurateLocationBlock = nil;
        }
        [self.locationManager stopUpdatingLocation];
    }

}

- (void)locationManager:(CLLocationManager *)manager
       didUpdateHeading:(CLHeading *)newHeading {
    
}

- (BOOL)locationManagerShouldDisplayHeadingCalibration:(CLLocationManager *)manager{
    return NO;
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error{
    NSLog(@"Error: %@", error);
    [self.locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if(status != kCLAuthorizationStatusNotDetermined){
        [self locationManagerAuthorizationStatus:status];
    }
}

@end

