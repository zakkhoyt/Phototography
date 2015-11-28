//
//  ZHUser.h
//  Phototography
//
//  Created by Zakk Hoyt on 11/26/15.
//  Copyright © 2015 Zakk Hoyt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CloudKit/CloudKit.h>

@interface ZHUser : NSObject
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *uuid;
@property (nonatomic, strong) NSArray <ZHUser*> *friends;

+(void)setCurrentUser:(ZHUser*)user;
+(ZHUser*)currentUser;


- (instancetype)initWithRecord:(CKRecord*)record;
- (instancetype)initWithDiscoveredUserInfo:(CKDiscoveredUserInfo*) userInfo;
- (NSString*)fullName;
@end
