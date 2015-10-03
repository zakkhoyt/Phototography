//
//  CLLocation+ZH.h
//  ZH
//
//  Created by Zakk Hoyt on 4/28/15.
//  Copyright (c) 2015 Zakk Hoyt. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

typedef void (^CLLocationStringBlock)(NSString *string);

@interface CLLocation (ZH)

-(NSString*)stringForCoordinate;
+(NSString*)stringForCoordinate:(CLLocationCoordinate2D)coordinate;

-(void)stringLocalityCompletionBlock:(CLLocationStringBlock)completionBlock;
-(void)stringCityStateCompletionBlock:(CLLocationStringBlock)completionBlock;
-(void)stringThoroughfareCompletionBlock:(CLLocationStringBlock)completionBlock;

+(instancetype)locationForHome;
+(instancetype)locationForWork;
+(instancetype)locationForTest1;
+(instancetype)locationForTest2;
+(instancetype)locationForTest3;
+(instancetype)locationForTest4;
+(instancetype)locationForTest5;

@end
