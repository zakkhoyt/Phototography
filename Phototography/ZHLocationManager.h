//
//  ZHLocationManager.h
//  Phototography
//
//  Created by Zakk Hoyt on 11/28/15.
//  Copyright © 2015 Zakk Hoyt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


const CLLocationDistance ZHLocationManagerRadiusInMeters = 100;

typedef void (^ZHLocationManagerLocationBlock)(CLLocation *location);
typedef void (^ZHLocationManagerLocationErrorBlock)(CLLocation *location, NSError *error);

@interface ZHLocationManager : NSObject

+(ZHLocationManager*)sharedInstance;

// Get the list of updates
-(NSArray*)updates;

// Get your current locatoin and then check in
-(void)updateToCurrentLocationWithCompletionBlock:(ZHLocationManagerLocationErrorBlock)completionBlock;

// Update to a specific location
-(void)updateToLocation:(CLLocation*)location completionBlock:(ZHLocationManagerLocationErrorBlock)completionBlock;

@end
