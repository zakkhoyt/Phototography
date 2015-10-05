//
//  VWWClusterAnnotation.h
//  VWWClusteredMapView
//
//  Created by Zakk Hoyt on 3/28/15.
//  Copyright (c) 2015 Zakk Hoyt. All rights reserved.

#import <Foundation/Foundation.h>
@import  MapKit;

static NSString *const VWWAnnotatioViewReuseID = @"VWWAnnotatioViewReuseID";

@interface VWWClusteredAnnotation : NSObject <MKAnnotation>
- (instancetype)initWithCoordinate:(CLLocationCoordinate2D)coordinate annotations:(NSArray*)annotations;

@property (assign, nonatomic) CLLocationCoordinate2D coordinate;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *subtitle;

// TODO: Can this be an NSSet?
@property (nonatomic, strong) NSArray *annotations; // [VWWClusteredAnnotation]
@end
