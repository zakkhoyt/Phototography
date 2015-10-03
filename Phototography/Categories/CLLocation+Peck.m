//
//  CLLocation+Peck.m
//  Peck
//
//  Created by Zakk Hoyt on 4/28/15.
//  Copyright (c) 2015 Zakk Hoyt. All rights reserved.
//

#import "CLLocation+Peck.h"

@implementation CLLocation (Peck)


-(NSString*)stringForCoordinate{
    return [NSString stringWithFormat:@"%.5f,%.5f", self.coordinate.latitude, self.coordinate.longitude];
}
+(NSString*)stringForCoordinate:(CLLocationCoordinate2D)coordinate{
    return [NSString stringWithFormat:@"%.5f,%.5f", coordinate.latitude, coordinate.longitude];
}

-(void)stringLocalityCompletionBlock:(CLLocationStringBlock)completionBlock{
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    [geocoder reverseGeocodeLocation:self
                   completionHandler:^(NSArray *placemarks, NSError *error) {
                       if(placemarks.count){
                           CLPlacemark *placemark = placemarks[0];
                           if(placemark.locality && placemark.subLocality){
                               if([placemark.locality isEqualToString:placemark.subLocality]){
                                   return completionBlock(placemark.locality);
                               } else {
                                   return completionBlock([NSString stringWithFormat:@"%@ %@", placemark.subLocality, placemark.locality]);
                               }
                           }
                           if(placemark.subLocality)
                               return completionBlock(placemark.subLocality);
                           if(placemark.locality)
                               return completionBlock(placemark.locality);
                           if(placemark.subAdministrativeArea)
                               return completionBlock(placemark.subAdministrativeArea);
                           if(placemark.name)
                               return completionBlock(placemark.name);
                           if(placemark.thoroughfare)
                               return completionBlock(placemark.thoroughfare);
                           if(placemark.subThoroughfare)
                               return completionBlock(placemark.subThoroughfare);
                           if(placemark.administrativeArea)
                               return completionBlock(placemark.administrativeArea);
                           if(placemark.postalCode)
                               return completionBlock(placemark.postalCode);
                           if(placemark.ISOcountryCode)
                               return completionBlock(placemark.ISOcountryCode);
                           if(placemark.country)
                               return completionBlock(placemark.country);
                           if(placemark.inlandWater)
                               return completionBlock(placemark.inlandWater);
                           if(placemark.ocean)
                               return completionBlock(placemark.ocean);
                           if(placemark.areasOfInterest.count){
                               return completionBlock(placemark.areasOfInterest[0]);
                           }
                       }
                   }];
}

-(void)stringCityStateCompletionBlock:(CLLocationStringBlock)completionBlock{
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    [geocoder reverseGeocodeLocation:self
                   completionHandler:^(NSArray *placemarks, NSError *error) {
                       if(placemarks.count){
                           CLPlacemark *placemark = placemarks[0];
                           if(placemark.locality && placemark.subLocality){
                               if([placemark.locality isEqualToString:placemark.subLocality]){
                                   return completionBlock(placemark.locality);
                               } else {
                                   return completionBlock([NSString stringWithFormat:@"%@, %@", placemark.locality, placemark.administrativeArea]);
                               }
                           }
                           if(placemark.subLocality)
                               return completionBlock(placemark.subLocality);
                           if(placemark.locality)
                               return completionBlock(placemark.locality);
                           if(placemark.subAdministrativeArea)
                               return completionBlock(placemark.subAdministrativeArea);
                           if(placemark.name)
                               return completionBlock(placemark.name);
                           if(placemark.thoroughfare)
                               return completionBlock(placemark.thoroughfare);
                           if(placemark.subThoroughfare)
                               return completionBlock(placemark.subThoroughfare);
                           if(placemark.administrativeArea)
                               return completionBlock(placemark.administrativeArea);
                           if(placemark.postalCode)
                               return completionBlock(placemark.postalCode);
                           if(placemark.ISOcountryCode)
                               return completionBlock(placemark.ISOcountryCode);
                           if(placemark.country)
                               return completionBlock(placemark.country);
                           if(placemark.inlandWater)
                               return completionBlock(placemark.inlandWater);
                           if(placemark.ocean)
                               return completionBlock(placemark.ocean);
                           if(placemark.areasOfInterest.count){
                               return completionBlock(placemark.areasOfInterest[0]);
                           }
                       }
                   }];
}

-(void)stringThoroughfareCompletionBlock:(CLLocationStringBlock)completionBlock{
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    [geocoder reverseGeocodeLocation:self
                   completionHandler:^(NSArray *placemarks, NSError *error) {
                       if(placemarks.count){
                           CLPlacemark *placemark = placemarks[0];
                           if(placemark.thoroughfare && placemark.subThoroughfare)
                               return completionBlock([NSString stringWithFormat:@"%@ %@", placemark.subThoroughfare, placemark.thoroughfare]);
                           if(placemark.thoroughfare)
                               return completionBlock(placemark.thoroughfare);
                           if(placemark.subLocality)
                               return completionBlock(placemark.subLocality);
                           if(placemark.locality)
                               return completionBlock(placemark.locality);
                           if(placemark.subAdministrativeArea)
                               return completionBlock(placemark.subAdministrativeArea);
                           if(placemark.name)
                               return completionBlock(placemark.name);
                           if(placemark.subThoroughfare)
                               return completionBlock(placemark.subThoroughfare);
                           if(placemark.administrativeArea)
                               return completionBlock(placemark.administrativeArea);
                           if(placemark.postalCode)
                               return completionBlock(placemark.postalCode);
                           if(placemark.ISOcountryCode)
                               return completionBlock(placemark.ISOcountryCode);
                           if(placemark.country)
                               return completionBlock(placemark.country);
                           if(placemark.inlandWater)
                               return completionBlock(placemark.inlandWater);
                           if(placemark.ocean)
                               return completionBlock(placemark.ocean);
                           if(placemark.areasOfInterest.count){
                               return completionBlock(placemark.areasOfInterest[0]);
                           }
                       }
                   }];
}



+(instancetype)locationForHome{
    return [[CLLocation alloc]initWithLatitude:37.750958 longitude:-122.468686];
}
+(instancetype)locationForWork{
    return [[CLLocation alloc]initWithLatitude:37.93593 longitude:-122.5196];
}
+(instancetype)locationForTest1{
    return [[CLLocation alloc]initWithLatitude:37.753406 longitude:-122.446648];
}
+(instancetype)locationForTest2{
    return [[CLLocation alloc]initWithLatitude:37.881577 longitude:-121.913804];
}
+(instancetype)locationForTest3{
    return [[CLLocation alloc]initWithLatitude:37.803031 longitude:-122.250976];
}
+(instancetype)locationForTest4{
    return [[CLLocation alloc]initWithLatitude:37.532281 longitude:-122.383847];
}
+(instancetype)locationForTest5{
    return [[CLLocation alloc]initWithLatitude:37.417723 longitude:-122.204563];
}





@end
