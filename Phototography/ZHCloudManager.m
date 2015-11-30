//
//  ZHCloudManager.m
//  Phototography
//
//  Created by Zakk Hoyt on 11/26/15.
//  Copyright © 2015 Zakk Hoyt. All rights reserved.
//
//  Documentation: https://developer.apple.com/library/ios/documentation/DataManagement/Conceptual/CloudKitQuickStart/CloudKit_Quick_Start.pdf
//  Subscriptions: https://developer.apple.com/library/prerelease/ios/documentation/DataManagement/Conceptual/CloudKitQuickStart/SubscribingtoRecordChanges/SubscribingtoRecordChanges.html
//  One to many: https://www.hackingwithswift.com/read/33/7/working-with-cloudkit-records-ckreference-fetchrecordwithid-and-

#import "ZHCloudManager.h"
#import "NSError+ZH.h"
#import <CoreLocation/CoreLocation.h>
#import "ZHNotificationNames.h"

@interface ZHCloudManager ()
@property (nonatomic, strong) CKContainer *container;
@property (nonatomic, strong) CKDatabase *publicDB;
@property (nonatomic, strong) CKDatabase *privateDB;
@property (nonatomic, strong) CKRecordID *userRecordID;
@end

@implementation ZHCloudManager

#pragma mark Public methods

- (instancetype)init {
    self = [super init];
    if (self) {
        self.container = [CKContainer defaultContainer];
        self.publicDB = self.container.publicCloudDatabase;
        self.privateDB = self.container.privateCloudDatabase;
    }
    return self;
}




-(void)createPhotographer:(ZHUser*)user completionBlock:(ZHCloudManagerUserErrorBlock)completionBlock{
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"UUID == %@", user.uuid];
    CKQuery *query = [[CKQuery alloc]initWithRecordType:@"Photographers" predicate:predicate];
    
    [self.publicDB performQuery:query inZoneWithID:nil completionHandler:^(NSArray<CKRecord *> * _Nullable results, NSError * _Nullable error) {
        if(error != nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(nil, error);
            });
        } else {
            if(results.count == 0){
                // Photographer not found. Create a new entry
                CKRecord *record = [user recordRepresentation];
                [self.publicDB saveRecord:record completionHandler:^(CKRecord * _Nullable record, NSError * _Nullable error) {
                    if(error != nil) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            completionBlock(nil, error);
                        });
                    } else {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            completionBlock(user, nil);
                        });
                    }
                }];
            } else {
                BOOL userFound = NO;
                ZHUser *foundUser;
                for(CKRecord *record in results) {
                    ZHUser *retrievedUser = [[ZHUser alloc]initWithRecord:record];
                    if([user isEqual:retrievedUser]) {
                        userFound = YES;
                        foundUser = retrievedUser;
                        break;
                    }
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if(userFound == YES) {
                        completionBlock(foundUser, nil);
                    } else {
                        completionBlock(nil, nil);
                    }
                    
                });

            }
        }
    }];
}

-(void)getPhotographerWithUUID:(NSString*)uuid completionBlock:(ZHCloudManagerUserErrorBlock)completionBlock{
    CKRecordID *recordID = [[CKRecordID alloc]initWithRecordName:uuid];
    [self.publicDB fetchRecordWithID:recordID completionHandler:^(CKRecord * _Nullable record, NSError * _Nullable error) {
        if(error != nil) {
            if(error.code == 11) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(nil, nil);
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(nil, error);
                });
            }
        } else {
            ZHUser *photographer = [[ZHUser alloc]initWithRecord:record];
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(photographer, nil);
            });
        }
    }];

}




-(void)getFriendsWithEmail:(NSString*)email completionBlock:(ZHCloudManagerArrayErrorBlock)completionBlock{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"Email == %@", email];
    //        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"Email != ''", email];
    CKQuery *query = [[CKQuery alloc]initWithRecordType:@"Photographers" predicate:predicate];
    
    [self.publicDB performQuery:query inZoneWithID:nil completionHandler:^(NSArray<CKRecord *> * _Nullable results, NSError * _Nullable error) {
        if(error != nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(nil, error);
            });
        } else {
            
            NSMutableArray *friendsWithEmail = [[NSMutableArray alloc]initWithCapacity:results.count];
            for(CKRecord *record in results) {
                ZHUser *user = [[ZHUser alloc]initWithRecord:record];
                [friendsWithEmail addObject:user];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(friendsWithEmail, nil);
            });
        }
    }];
}



-(void)loggedInToICloud:(ZHCloudManagerBoolBlock)completionBlock{
    [self.container accountStatusWithCompletionHandler:^(CKAccountStatus accountStatus, NSError * _Nullable error) {
        if(accountStatus == CKAccountStatusAvailable){
            completionBlock(YES);
        } else {
            NSLog(@"iCloud authentication status: %lu", (unsigned long)accountStatus);
            completionBlock(NO);
        }
    }];
}

-(void)userID:(ZHCloudManagerRecordIDErrorBlock)completionBlock{
    if(self.userRecordID != nil){
        completionBlock(self.userRecordID, nil);
    } else {
        [self.container fetchUserRecordIDWithCompletionHandler:^(CKRecordID * _Nullable recordID, NSError * _Nullable error) {
            if(error != nil) {
                completionBlock(nil, error);
            } else {
                if(recordID != nil) {
                    self.userRecordID = recordID;
                }
                completionBlock(self.userRecordID, nil);
            }
        }];
    }
}


-(void)userInfo:(ZHCloudManagerUserErrorBlock)completionBlock{
    [self requestDiscoverablity:^(BOOL discoverable) {
        [self userID:^(CKRecordID *recordID, NSError *error) {
            if(error != nil) {
                completionBlock(nil, error);
            } else {
                [self userInfo:recordID completionBlock:^(CKDiscoveredUserInfo *discoveredUserInfo, NSError *error) {
                    ZHUser *user = [[ZHUser alloc]initWithDiscoveredUserInfo:discoveredUserInfo];
                    completionBlock(user, nil);
                }];
            }
        }];
    }];
}

-(void)userInfo:(CKRecordID*)recordID completionBlock:(ZHCloudManagerDiscoveredUserInfoErrorBlock)completionBlock{
    [self.container discoverUserInfoWithUserRecordID:recordID completionHandler:completionBlock];
}


-(void)requestDiscoverablity:(ZHCloudManagerBoolBlock)completionBlock{
    [self.container statusForApplicationPermission:CKApplicationPermissionUserDiscoverability completionHandler:^(CKApplicationPermissionStatus applicationPermissionStatus, NSError * _Nullable error) {
        if(error != nil || applicationPermissionStatus == CKApplicationPermissionStatusDenied) {
            completionBlock(NO);
        } else {
            // This causes an iOS prompt
            [self.container requestApplicationPermission:CKApplicationPermissionUserDiscoverability completionHandler:^(CKApplicationPermissionStatus applicationPermissionStatus, NSError * _Nullable error) {
                completionBlock(YES);
            }];
        }
    }];
}



-(void)updateUser:(ZHUser*)user completionBlock:(ZHCloudManagerUserErrorBlock)completionBlock{
    
    CKRecord *record = user.recordRepresentation;
    CKModifyRecordsOperation *modifyRecordsOperation = [[CKModifyRecordsOperation alloc] initWithRecordsToSave:@[record] recordIDsToDelete:nil];
    modifyRecordsOperation.savePolicy = CKRecordSaveAllKeys;
    [modifyRecordsOperation setModifyRecordsCompletionBlock:^(NSArray <CKRecord *> * __nullable savedRecords,
                                                              NSArray <CKRecordID *> * __nullable deletedRecordIDs,
                                                              NSError * __nullable operationError){
        if(operationError != nil){
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(nil, operationError);
            });
        } else {
            NSLog(@"Updated photographer record");
            dispatch_async(dispatch_get_main_queue(), ^{
                ZHUser *newUser = [[ZHUser alloc]initWithRecord:record];
                
                if([user isEqual:[ZHUser currentUser]]) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:ZHNotificationNamesCurrentUserUpdated object:nil];
                }

                completionBlock(newUser, nil);
            });
        }
    }];
    
    [self.publicDB addOperation:modifyRecordsOperation];


}




-(void)findContacts:(ZHCloudManagerArrayErrorBlock)completionBlock{
    [self.container discoverAllContactUserInfosWithCompletionHandler:^(NSArray<CKDiscoveredUserInfo *> * _Nullable userInfos, NSError * _Nullable error) {
        NSLog(@"");
    }];
}


-(void)findUsersForEmail:(NSString*)email completionBlock:(ZHCloudManagerArrayErrorBlock)completionBlock{
    [self.container discoverUserInfoWithEmailAddress:email completionHandler:^(CKDiscoveredUserInfo * _Nullable userInfo, NSError * _Nullable error) {
        if(error != nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(nil, error);
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                if(userInfo == nil) {
                    completionBlock(nil, nil);
                } else {
                    ZHUser *user = [[ZHUser alloc]initWithDiscoveredUserInfo:userInfo];
                    // Now get Photographer from user.uuid
                    [self getPhotographerWithUUID:user.uuid completionBlock:^(ZHUser *photographer, NSError *error) {
                        if(photographer == nil) {
                            completionBlock(nil, nil);
                        } else {
                            completionBlock(@[photographer], nil);
                        }
                    }];
                }
            });
        }
    }];
}

-(void)findUsersForEmails:(NSArray*)emails completionBlock:(ZHCloudManagerArrayErrorBlock)completionBlock {
    //    [self.container discoverAllContactUserInfosWithCompletionHandler:^(NSArray<CKDiscoveredUserInfo *> * _Nullable userInfos, NSError * _Nullable error) {
    //        if(error != nil) {
    //            dispatch_async(dispatch_get_main_queue(), ^{
    //                completionBlock(nil, error);
    //            });
    //        } else {
    //            NSMutableSet *users = [[NSMutableSet alloc]initWithCapacity:userInfos.count * 3];
    //            [userInfos enumerateObjectsUsingBlock:^(CKDiscoveredUserInfo * _Nonnull userInfo, NSUInteger idx, BOOL * _Nonnull stop) {
    //                //            if(userInfo.displayContact.emailAddresses.count > 0) {
    //                [userInfo.displayContact.emailAddresses enumerateObjectsUsingBlock:^(CNLabeledValue<NSString *> * _Nonnull email, NSUInteger idx, BOOL * _Nonnull stop) {
    //                    if([emails containsObject:email.value]){
    //                        ZHUser *user = [[ZHUser alloc]initWithDiscoveredUserInfo:userInfo];
    //                        [users addObject:user];
    //                    }
    //                }];
    //                dispatch_async(dispatch_get_main_queue(), ^{
    //                    completionBlock(users.allObjects, nil);
    //                });
    //            }];
    //        }
    //    }];
    
    //    NSMutableSet *users = [[NSMutableSet alloc]initWithCapacity:emails.count];
    //    __block NSError *returnError;
    //    [emails enumerateObjectsUsingBlock:^(NSString*  _Nonnull email, NSUInteger idx, BOOL * _Nonnull stop) {
    //        [self.container discoverUserInfoWithEmailAddress:email completionHandler:^(CKDiscoveredUserInfo * _Nullable userInfo, NSError * _Nullable error) {
    //            if(error != nil) {
    //                returnError = error;
    //                *stop = YES;
    //            } else {
    //                ZHUser *user = [[ZHUser alloc]initWithDiscoveredUserInfo:userInfo];
    //                [users addObject:user];
    //            }
    //        }];
    //    }];
    //    
    //    if(returnError != nil) {
    //        dispatch_async(dispatch_get_main_queue(), ^{
    //            completionBlock(nil, returnError);
    //        });
    //    } else {
    //        dispatch_async(dispatch_get_main_queue(), ^{
    //            completionBlock(users.allObjects, nil);
    //        });
    //    }
}


-(void)subscribeToLocationUpdatesForPhotographer:(ZHUser*)photographer completionBlock:(ZHCloudManagerErrorBlock)completionBlock {
 
    // 1
    CKRecordID *artistRecordID = [[CKRecordID alloc] initWithRecordName:@"Mei Chen"];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"artist = %@", artistRecordID];
    
    // 2
    CKSubscription *subscription = [[CKSubscription alloc]
                                    
                                    initWithRecordType:@"Artwork"
                                    
                                    predicate:predicate
                                    
                                    options:CKSubscriptionOptionsFiresOnRecordCreation];
    
    // 3
    CKNotificationInfo *notificationInfo = [CKNotificationInfo new];
    
    notificationInfo.alertLocalizationKey = @"New artwork by your favorite artist.";
    
    notificationInfo.shouldBadge = YES;
    
    // 4
    subscription.notificationInfo = notificationInfo;
    
    // 5
    [self.publicDB saveSubscription:subscription completionHandler:^(CKSubscription * _Nullable subscription, NSError * _Nullable error) {
        if(error != nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(error);
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(nil);
            });
            
        }
    }];
}



-(void)updateAssets:(NSArray*)assets progressBlock:(ZHCloudManagerProgressBlock)progressBlock completionBlock:(ZHCloudManagerErrorBlock)completionBlock {
        
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        const NSUInteger kBatchSize = 100;
        __block NSError *error;
        __block NSUInteger uploadedCount = 0;
        for(NSUInteger index = 0; index < assets.count / kBatchSize; index++){
            NSUInteger startIndex = index * kBatchSize;                             // 0 * 10 = 0
            NSUInteger endIndex = MIN(assets.count, startIndex + kBatchSize - 1);   // 0 + 10 - 1 = 9
            NSUInteger batchSize = (endIndex - startIndex) + 1;                     // 9 - 0 + 1 = 10
            
            NSLog(@"Uploading assets from %lu to %lu", (unsigned long) startIndex, (unsigned long) endIndex);
            // Get sub array of assets
            NSMutableArray *records = [[NSMutableArray alloc]initWithCapacity:assets.count];
            for(NSUInteger i = startIndex; i < endIndex; i++) {
                ZHAsset *asset = assets[i];
                CKRecord *record = [asset recordRepresentation];
                [records addObject:record];
            }
            
            
            dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
            
            CKModifyRecordsOperation *modifyRecordsOperation = [[CKModifyRecordsOperation alloc] initWithRecordsToSave:records recordIDsToDelete:nil];
            modifyRecordsOperation.savePolicy = CKRecordSaveAllKeys;
            [modifyRecordsOperation setModifyRecordsCompletionBlock:^(NSArray <CKRecord *> * __nullable savedRecords,
                                                                      NSArray <CKRecordID *> * __nullable deletedRecordIDs,
                                                                      NSError * __nullable operationError){
                if(operationError != nil){
                    NSLog(@"Error: %@", operationError);
                    error = operationError;
                }
                dispatch_semaphore_signal(semaphore);
            }];
            
            [self.publicDB addOperation:modifyRecordsOperation];
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
            
            if(progressBlock) {
                uploadedCount += batchSize;
                dispatch_async(dispatch_get_main_queue(), ^{
                    progressBlock(uploadedCount, assets.count);
                });
            }
        }
        
        if(error != nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(error);
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(nil);
            });
        }
    });
}


-(void)getAssetsForUserUUID:(NSString*)userUUID completionBlock:(ZHCloudManagerArrayErrorBlock)completionBlock{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"OwnerUUID = %@", userUUID];
    CKQuery *query = [[CKQuery alloc] initWithRecordType:@"Assets" predicate:predicate];
    
    [self.publicDB performQuery:query inZoneWithID:nil completionHandler:^(NSArray *results, NSError *error) {\
        
        if(error != nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(nil, error);
            });
        } else {
            
            NSMutableArray *assets = [[NSMutableArray alloc]initWithCapacity:results.count];
            for (CKRecord *record in results) {
                ZHAsset *asset = [[ZHAsset alloc]initWithRecord:record];
                [assets addObject:asset];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(assets, nil);
            });
        }
    }];
}



-(void)getAssetsNearLocation:(CLLocation*)location completionBlock:(ZHCloudManagerArrayErrorBlock)completionBlock {
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);

    NSUInteger count = [ZHUser currentUser].friendUUIDs.count;
    NSMutableArray *userAssets = [[NSMutableArray alloc]initWithCapacity:count];
    __block NSError *retError;
    [[ZHUser currentUser].friendUUIDs enumerateObjectsUsingBlock:^(NSString * _Nonnull uuid, NSUInteger idx, BOOL * _Nonnull stop) {
        dispatch_group_enter(group);
        dispatch_async(queue, ^{
            [self getAssetsNearLocation:location ownerUUID:uuid completionBlock:^(NSArray *assets, NSError *error) {

                if(error != nil) {
                    retError = error;
                } else if(assets != nil) {
                    NSDictionary *dictionary = @{@"uuid": uuid,
                                                 @"assets": assets};
                    [userAssets addObject:dictionary];
                }
                
                dispatch_group_leave(group);
            }];
        });

    }];
    
    dispatch_group_notify(group, queue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if(retError != nil) {
                    completionBlock(nil, retError);
                } else {
                    completionBlock(userAssets, nil);
                }
            });
        });
    });

}

-(void)getAssetsNearLocation:(CLLocation*)location ownerUUID:(NSString*)ownerUUID completionBlock:(ZHCloudManagerArrayErrorBlock)completionBlock{
    
    
//    let locationPredicate = NSPredicate(format: "distanceToLocation:fromLocation:(%K,%@) < %f",
//                                        "Location",
//                                        location,
//                                        radiusInKilometers)
    
    
    
//    NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"OwnerUUID = %@", ownerUUID];
//    NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"distanceToLocation:fromLocation:(Location, %@) < %f", location, 100000];
//    NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[predicate1, predicate2]];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"OwnerUUID = %@", ownerUUID];
    CKQuery *query = [[CKQuery alloc] initWithRecordType:@"Assets" predicate:predicate];
    
    [self.publicDB performQuery:query inZoneWithID:nil completionHandler:^(NSArray *results, NSError *error) {\
        
        if(error != nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(nil, error);
            });
        } else {
            
            NSMutableArray *assets = [[NSMutableArray alloc]initWithCapacity:results.count];
            for (CKRecord *record in results) {
                ZHAsset *asset = [[ZHAsset alloc]initWithRecord:record];
                [assets addObject:asset];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(assets.count > 0 ? assets : nil, nil);
            });
        }
    }];
    
}
@end













