//
//  ZHCloudManager.m
//  Phototography
//
//  Created by Zakk Hoyt on 11/26/15.
//  Copyright © 2015 Zakk Hoyt. All rights reserved.
//
//  Documentation: https://developer.apple.com/library/ios/documentation/DataManagement/Conceptual/CloudKitQuickStart/CloudKit_Quick_Start.pdf

#import "ZHCloudManager.h"
#import "NSError+ZH.h"

@interface ZHCloudManager ()
@property (nonatomic, strong) CKContainer *container;
@property (nonatomic, strong) CKDatabase *publicDB;
@property (nonatomic, strong) CKDatabase *privateDB;

@end

@implementation ZHCloudManager

- (instancetype)init {
    self = [super init];
    if (self) {
        self.container = [CKContainer defaultContainer];
        self.publicDB = self.container.publicCloudDatabase;
        self.privateDB = self.container.privateCloudDatabase;
        self.friends = [[NSMutableArray alloc]init];
    }
    return self;
}


-(void)createUser:(ZHUser*)user completionBlock:(ZHCloudManagerErrorBlock)completionBlock{
    
    
    [self getExistingUser:user completionBlock:^(ZHUser *existingUser, NSError *error) {
        if(existingUser != nil){
            // user already exists so use it
            NSLog(@"User account already exists");
            self.user = existingUser;
            completionBlock(nil);
        } else {
            CKRecordID *recordID = [[CKRecordID alloc]initWithRecordName:user.uuid];
            CKRecord *record = [[CKRecord alloc]initWithRecordType:@"Photographers" recordID:recordID];
            record[@"FirstName"] = user.firstName;
            record[@"LastName"] = user.lastName;
            record[@"Email"] = user.email;
            record[@"Phone"] = user.phone;
            record[@"UUID"] = user.uuid;
            
            
            [self.publicDB saveRecord:record completionHandler:^(CKRecord * _Nullable record, NSError * _Nullable error) {
                if(error != nil) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completionBlock(error);
                    });
                } else {
                    NSLog(@"Created new user account");
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.user = [[ZHUser alloc]initWithRecord:record];
                        completionBlock(nil);
                    });
                }
            }];
        }
    }];
}

-(void)getExistingUser:(ZHUser*)user completionBlock:(ZHCloudManagerUserErrorBlock)completionBlock{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"Email == '%@'", user.email];
    CKQuery *query = [[CKQuery alloc]initWithRecordType:@"Photographers" predicate:predicate];
    
    [self.publicDB performQuery:query inZoneWithID:nil completionHandler:^(NSArray<CKRecord *> * _Nullable results, NSError * _Nullable error) {
        if(error != nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(nil, error);
            });
        } else {
            if(results.count == 0){
                completionBlock(nil, nil);
            } else {
                for(CKRecord *record in results) {
                    ZHUser *retrievedUser = [[ZHUser alloc]initWithRecord:record];
                    if([user.email isEqualToString:retrievedUser.email]){
                        completionBlock(retrievedUser, nil);
                    } else {
                        completionBlock(nil, nil);
                    }
                }
            }
        }
    }];
}


-(void)getFriendsWithCompletionBlock:(ZHCloudManagerArrayErrorBlock)completionBlock{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"UUID != ''"];
    CKQuery *query = [[CKQuery alloc]initWithRecordType:@"User" predicate:predicate];
    
    [self.publicDB performQuery:query inZoneWithID:nil completionHandler:^(NSArray<CKRecord *> * _Nullable results, NSError * _Nullable error) {
        if(error != nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(nil, error);
            });
        } else {
            [self.friends removeAllObjects];
            for(CKRecord *record in results) {
                ZHUser *user = [[ZHUser alloc]initWithRecord:record];
                [self.friends addObject:user];
            }
            
        }
    }];
}



//func fetchEstablishments(location:CLLocation,
//                         radiusInMeters:CLLocationDistance) {
//    
//    let radiusInKilometers = radiusInMeters / 1000.0
//    
//    let locationPredicate = NSPredicate(format: "distanceToLocation:fromLocation:(%K,%@) < %f",
//                                        "Location",
//                                        location,
//                                        radiusInKilometers)
//    let query = CKQuery(recordType: "Player",
//                        predicate:  locationPredicate)
//    
//    
//    publicDB.performQuery(query, inZoneWithID: nil) {
//        results, error in
//        if error != nil {
//            print("error")
//            dispatch_async(dispatch_get_main_queue()) {
//                self.delegate?.errorUpdating(error!)
//                return
//            }
//        } else {
//            self.players.removeAll(keepCapacity: true)
//            for record in results!{
//                let establishment = Player(record: record, database: self.publicDB)
//                self.players.append(establishment)
//            }
//            dispatch_async(dispatch_get_main_queue()) {
//                self.delegate?.modelUpdated()
//                return
//            }
//        }
//    }
//}
@end
