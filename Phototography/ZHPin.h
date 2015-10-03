//
//  ZHPin.h
//  Phototography
//
//  Created by Zakk Hoyt on 10/2/15.
//  Copyright © 2015 Zakk Hoyt. All rights reserved.
//

#import <Foundation/Foundation.h>
@import MapKit;

@interface ZHPin : NSObject <MKAnnotation>

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
- (instancetype)initWithCoordinate:(CLLocationCoordinate2D)coordinate;
- (instancetype)initWithLocation:(CLLocation*)location;
@end
