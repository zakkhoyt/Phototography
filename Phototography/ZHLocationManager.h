//
//  ZHLocationManager.h
//  Phototography
//
//  Created by Zakk Hoyt on 11/28/15.
//  Copyright © 2015 Zakk Hoyt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


typedef void (^ZHLocationManagerLocationBlock)(CLLocation *location);

@interface ZHLocationManager : NSObject

+(ZHLocationManager*)sharedInstance;

// Get the list of updates
-(NSArray*)updates;

// Get your current locatoin and then check in
-(void)updateToCurrentLocationWithCompletionBlock:(ZHLocationManagerLocationBlock)completionBlock;

// Update to a specific location
-(void)updateToLocation:(CLLocation*)location completionBlock:(ZHLocationManagerLocationBlock)completionBlock;

@end
