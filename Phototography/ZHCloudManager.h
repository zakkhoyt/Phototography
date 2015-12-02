//
//  ZHCloudManager.h
//  Phototography
//
//  Created by Zakk Hoyt on 11/26/15.
//  Copyright © 2015 Zakk Hoyt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CloudKit/CloudKit.h>
#import "ZHUser.h"

typedef void (^ZHCloudManagerBoolBlock)(BOOL loggedIn);
typedef void (^ZHCloudManagerArrayErrorBlock)(NSArray *, NSError *error);
typedef void (^ZHCloudManagerDiscoveredUserInfoErrorBlock)(CKDiscoveredUserInfo *discoveredUserInfo, NSError *error);
typedef void (^ZHCloudManagerRecordIDErrorBlock)(CKRecordID *recordID, NSError *error);
typedef void (^ZHCloudManagerErrorBlock)(NSError *error);
typedef void (^ZHCloudManagerUserErrorBlock)(ZHUser *user, NSError *error);
typedef void (^ZHCloudManagerProgressBlock)(NSUInteger uploadedCount, NSUInteger totalCount);

@interface ZHCloudManager : NSObject

-(void)updateUser:(ZHUser*)user completionBlock:(ZHCloudManagerUserErrorBlock)completionBlock;

-(void)createPhotographer:(ZHUser*)user completionBlock:(ZHCloudManagerUserErrorBlock)completionBlock;
-(void)getFriendsForReferences:(NSArray*)references completionBlock:(ZHCloudManagerArrayErrorBlock)completionBlock;

-(void)loggedInToICloud:(ZHCloudManagerBoolBlock)completionBlock;
-(void)userInfo:(ZHCloudManagerUserErrorBlock)completionBlock;
-(void)findUsersForEmail:(NSString*)email completionBlock:(ZHCloudManagerArrayErrorBlock)completionBlock;
-(void)getPhotographerWithUUID:(NSString*)uuid completionBlock:(ZHCloudManagerUserErrorBlock)completionBlock;
-(void)subscribeToLocationUpdatesForPhotographer:(ZHUser*)photographer completionBlock:(ZHCloudManagerErrorBlock)completionBlock;


-(void)updateAssets:(NSArray*)assets progressBlock:(ZHCloudManagerProgressBlock)progressBlock completionBlock:(ZHCloudManagerErrorBlock)completionBlock;

-(void)getAssetsForUserUUID:(NSString*)userUUID completionBlock:(ZHCloudManagerArrayErrorBlock)completionBlock;


-(void)getAssetsNearLocation:(CLLocation*)location completionBlock:(ZHCloudManagerArrayErrorBlock)completionBlock;
-(void)getAssetsNearLocation:(CLLocation*)location ownerUUID:(NSString*)ownerUUID completionBlock:(ZHCloudManagerArrayErrorBlock)completionBlock;


@end
