//
//  ZHUserDefaults.m
//  Phototography
//
//  Created by Zakk Hoyt on 10/3/15.
//  Copyright © 2015 Zakk Hoyt. All rights reserved.
//
//  https://stackoverflow.com/questions/2315948/how-to-store-custom-objects-in-nsuserdefaults/2315972#2315972



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


static NSString *ZHUserDefaultsUpdates = @"ZHUserDefaultsUpdates";




+(void)setUpdates:(NSArray<ZHLocationUpdate*>*)updates {
    
    NSMutableArray *updatesData = [[NSMutableArray alloc]initWithCapacity:updates.count];
    [updates enumerateObjectsUsingBlock:^(ZHLocationUpdate * _Nonnull update, NSUInteger idx, BOOL * _Nonnull stop) {
        NSData *updateData = [NSKeyedArchiver archivedDataWithRootObject:updates];
        [updatesData addObject:updateData];
    }];
    
    
    
    [[NSUserDefaults standardUserDefaults] setObject:updatesData forKey:ZHUserDefaultsUpdates];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSArray<ZHLocationUpdate*>*)updates {
    NSArray<NSData*> *updatesData = [[NSUserDefaults standardUserDefaults] objectForKey:ZHUserDefaultsUpdates];
    if(updatesData == nil){
        return @[];
    } else {
        NSMutableArray<ZHLocationUpdate*> *updates = [[NSMutableArray alloc]initWithCapacity:updatesData.count];
        [updatesData enumerateObjectsUsingBlock:^(NSData * _Nonnull updateData, NSUInteger idx, BOOL * _Nonnull stop) {
            ZHLocationUpdate *update = [[NSKeyedUnarchiver unarchiveObjectWithData:updateData] firstObject];
            [updates addObject:update];
        }];
        return updates;
    }
}




//- (void)saveCustomObject:(MyObject *)object key:(NSString *)key {
//    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:object];
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    [defaults setObject:encodedObject forKey:key];
//    [defaults synchronize];
//    
//}
//
//- (MyObject *)loadCustomObjectWithKey:(NSString *)key {
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSData *encodedObject = [defaults objectForKey:key];
//    MyObject *object = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
//    return object;
//}

@end
