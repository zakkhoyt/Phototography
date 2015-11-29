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
#import <CoreLocation/CoreLocation.h>

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
                CKRecordID *recordID = [[CKRecordID alloc]initWithRecordName:user.uuid];
                CKRecord *record = [[CKRecord alloc]initWithRecordType:@"Photographers" recordID:recordID];
                record[@"FirstName"] = user.firstName;
                record[@"LastName"] = user.lastName;
                //                record[@"Email"] = user.email;
                //                record[@"Phone"] = user.phone;
                record[@"UUID"] = user.uuid;
                record[@"Location"] = [[CLLocation alloc]initWithLatitude:37.5 longitude:-122.4];
                
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
                for(CKRecord *record in results) {
                    ZHUser *retrievedUser = [[ZHUser alloc]initWithRecord:record];
                    if([user isEqual:retrievedUser]) {
                        userFound = YES;
                        break;
                    }
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if(userFound == YES) {
                        completionBlock(user, nil);
                    } else {
                        completionBlock(nil, nil);
                    }
                    
                });

            }
        }
    }];
    
    
    
    //    [self getExistingUser:user completionBlock:^(ZHUser *existingUser, NSError *error) {
    //        if(existingUser != nil){
    //            // user already exists so use it
    //            NSLog(@"User account already exists");
    //            completionBlock(existingUser, nil);
    //        } else {
    //            CKRecordID *recordID = [[CKRecordID alloc]initWithRecordName:user.uuid];
    //            CKRecord *record = [[CKRecord alloc]initWithRecordType:@"Photographers" recordID:recordID];
    //            record[@"FirstName"] = user.firstName;
    //            record[@"LastName"] = user.lastName;
    //            record[@"Email"] = user.email;
    //            record[@"Phone"] = user.phone;
    //            record[@"UUID"] = user.uuid;
    //
    //
    //            [self.publicDB saveRecord:record completionHandler:^(CKRecord * _Nullable record, NSError * _Nullable error) {
    //                if(error != nil) {
    //                    dispatch_async(dispatch_get_main_queue(), ^{
    //                        completionBlock(nil, error);
    //                    });
    //                } else {
    //                    NSLog(@"Created new user account");
    //                    dispatch_async(dispatch_get_main_queue(), ^{
    //                        ZHUser *newUser = [[ZHUser alloc]initWithRecord:record];
    //                        completionBlock(newUser, nil);
    //                    });
    //                }
    //            }];
    //        }
    //    }];
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

#pragma mark Private methods

-(void)getExistingUser:(ZHUser*)user completionBlock:(ZHCloudManagerUserErrorBlock)completionBlock{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"Email == %@", user.email];
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
                        break;
                    } else {
                        completionBlock(nil, nil);
                    }
                }
            }
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
                    [ZHUser setCurrentUser:user];
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
    
    CKRecord *record = [[CKRecord alloc]initWithRecordType:@"Users" recordID:self.userRecordID];
    //    record[@"FirstName"] = user.firstName;
    //    record[@"LastName"] = user.lastName;
    record[@"Email"] = user.email;
    record[@"Phone"] = user.phone;
    record[@"UUID"] = user.uuid;
    record[@"Location"] = [[CLLocation alloc]initWithLatitude:37.5 longitude:-122.4];
    
    
    
    [self.privateDB saveRecord:record completionHandler:^(CKRecord * _Nullable record, NSError * _Nullable error) {
        if(error != nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(nil, error);
            });
        } else {
            NSLog(@"Created new user account");
            dispatch_async(dispatch_get_main_queue(), ^{
                ZHUser *newUser = [[ZHUser alloc]initWithRecord:record];
                completionBlock(newUser, nil);
            });
        }
    }];
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
                    completionBlock(@[user], nil);
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
@end













