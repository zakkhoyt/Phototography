//
//  ZHLocationUpdate.h
//  Phototography
//
//  Created by Zakk Hoyt on 11/28/15.
//  Copyright © 2015 Zakk Hoyt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface ZHLocationUpdate : NSObject
@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSArray *results;
@end
