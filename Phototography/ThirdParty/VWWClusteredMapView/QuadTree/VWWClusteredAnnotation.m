//
//  VWWClusterAnnotation.m
//  VWWClusteredMapView
//
//  Created by Zakk Hoyt on 3/28/15.
//  Copyright (c) 2015 Zakk Hoyt. All rights reserved.

#import "VWWClusteredAnnotation.h"

@implementation VWWClusteredAnnotation

- (instancetype)initWithCoordinate:(CLLocationCoordinate2D)coordinate annotations:(NSArray*)annotations {
    self = [super init];
    if (self) {
        _coordinate = coordinate;
        _title = [NSString stringWithFormat:@"%u hotels in this area", (int)annotations.count];
        _annotations = annotations;
    }
    return self;
}

-(NSUInteger)hash {
    NSString *toHash = [NSString stringWithFormat:@"%.6f%.6f", self.coordinate.latitude, self.coordinate.longitude];
    return [toHash hash];
}

-(BOOL)isEqual:(id)object {
    return [self hash] == [object hash];
}

@end
