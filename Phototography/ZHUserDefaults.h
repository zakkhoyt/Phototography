//
//  ZHUserDefaults.h
//  Phototography
//
//  Created by Zakk Hoyt on 10/3/15.
//  Copyright © 2015 Zakk Hoyt. All rights reserved.
//

#import <Foundation/Foundation.h>
@import MapKit;

@interface ZHUserDefaults : NSObject


+(MKMapType)mapType;
+(void)setMapType:(MKMapType)mapType;

@end
