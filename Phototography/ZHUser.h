//
//  ZHUser.h
//  Phototography
//
//  Created by Zakk Hoyt on 11/26/15.
//  Copyright © 2015 Zakk Hoyt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CloudKit/CloudKit.h>
#import <CoreLocation/CoreLocation.h>
#import "ZHAsset.h"

@interface ZHUser : NSObject <CKRecordValue>
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *uuid;
@property (nonatomic, strong) NSString *avatarName;
@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, strong) NSMutableArray <NSString*> *friendUUIDs;
@property (nonatomic, strong) NSMutableArray <ZHAsset*> *assets;

//@property (nonatomic, strong) CKRecordID *recordID;

+(void)setCurrentUser:(ZHUser*)user;
+(ZHUser*)currentUser;

- (instancetype)initWithRecord:(CKRecord*)record;
- (instancetype)initWithDiscoveredUserInfo:(CKDiscoveredUserInfo*) userInfo;
- (NSString*)fullName;
- (CKRecord*)recordRepresentation;

@end

@interface ZHUser (NSSecureCoding) <NSSecureCoding>

@end

@interface ZHUser (NSCopying) <NSCopying>

@end
