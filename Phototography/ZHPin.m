//
//  ZHPin.m
//  Phototography
//
//  Created by Zakk Hoyt on 10/2/15.
//  Copyright © 2015 Zakk Hoyt. All rights reserved.
//

#import "ZHPin.h"

@implementation ZHPin

- (instancetype)initWithCoordinate:(CLLocationCoordinate2D)coordinate {
    self = [super init];
    if (self) {
        _coordinate = coordinate;
    }
    return self;
}


- (instancetype)initWithLocation:(CLLocation*)location {
    self = [super init];
    if (self) {
        _coordinate = location.coordinate;
    }
    return self;
}



@end
