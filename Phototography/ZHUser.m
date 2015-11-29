//
//  ZHUser.m
//  Phototography
//
//  Created by Zakk Hoyt on 11/26/15.
//  Copyright © 2015 Zakk Hoyt. All rights reserved.
//

#import "ZHUser.h"

static ZHUser *currentUser;

@implementation ZHUser

+(void)setCurrentUser:(ZHUser*)user{
    currentUser = user;
}

+(ZHUser*)currentUser{
    return currentUser;
}



- (instancetype)initWithRecord:(CKRecord*)record{
    self = [super init];
    if (self) {
        self.firstName = [record objectForKey:@"FirstName"];
        self.lastName = [record objectForKey:@"LastName"];
        self.email = [record objectForKey:@"Email"];
        self.phone = [record objectForKey:@"Phone"];
        self.uuid = [record objectForKey:@"uuid"];
        self.friends = [record objectForKey:@"Friends"];
    }
    return self;
}

- (instancetype)initWithDiscoveredUserInfo:(CKDiscoveredUserInfo*) userInfo{
    self = [super init];
    if (self) {
        self.firstName = userInfo.displayContact.givenName;
        self.lastName = userInfo.displayContact.familyName;
        self.email = [userInfo.displayContact.emailAddresses firstObject].value;
        self.phone = [userInfo.displayContact.phoneNumbers firstObject].value.stringValue;
        self.uuid = [NSString stringWithFormat:@"uuid%@", userInfo.userRecordID.recordName];
        self.recordID = userInfo.userRecordID;
//        self.uuid = [record objectForKey:@"uuid"];
//        self.friends = [record objectForKey:@"Friends"];
    }
    return self;
    
}

-(NSString*)fullName {
    if(self.firstName && self.lastName == nil){
        return self.firstName;
    } else if(self.firstName == nil && self.lastName) {
        return self.lastName;
    } else if(self.firstName && self.lastName) {
        return [NSString stringWithFormat:@"%@ %@", self.firstName, self.lastName];
    }
    return nil;
}

-(BOOL)isEqual:(id)object {
    if([object isKindOfClass:[ZHUser class]] == NO){
        return NO;
    }
    
    ZHUser *aUser = object;
//    if(self.email && aUser.email) {
//        return [self.email isEqualToString:aUser.email];
//    } else {
//        return [self.firstName isEqualToString:aUser.firstName] && [self.lastName isEqualToString:aUser.lastName];
//    }
    NSAssert(self.uuid != nil, @"uuid is nil");
    return [self.uuid isEqualToString:aUser.uuid];
}

-(NSUInteger)hash {
//    if(self.email){
//        return self.email.hash;
//    } else {
//        return self.firstName.hash + self.lastName.hash;
//    }
    NSAssert(self.uuid != nil, @"uuid is nil");
    return self.uuid.hash;
}


@end
