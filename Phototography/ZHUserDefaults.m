//
//  ZHUserDefaults.m
//  Phototography
//
//  Created by Zakk Hoyt on 10/3/15.
//  Copyright © 2015 Zakk Hoyt. All rights reserved.
//

#import "ZHUserDefaults.h"

@implementation ZHUserDefaults


static NSString *ZHUserDefaultsMapType = @"ZHUserDefaultsMapType";

+(MKMapType)mapType{
    NSNumber *n = [[NSUserDefaults standardUserDefaults] objectForKey:ZHUserDefaultsMapType];
    MKMapType mapType = (MKMapType)n.unsignedIntegerValue;
    return mapType;
}

+(void)setMapType:(MKMapType)mapType{
    [[NSUserDefaults standardUserDefaults] setObject:@(mapType) forKey:ZHUserDefaultsMapType];
    [[NSUserDefaults standardUserDefaults] synchronize];
}



@end
