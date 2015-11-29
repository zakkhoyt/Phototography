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

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.firstName forKey:@"FirstName"];
    [aCoder encodeObject:self.lastName forKey:@"LastName"];
    [aCoder encodeObject:self.uuid forKey:@"UUID"];
    [aCoder encodeObject:self.location forKey:@"Location"];
    [aCoder encodeObject:self.friends forKey:@"Friends"];
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        self.firstName = [coder decodeObjectForKey:@"FirstName"];
        self.lastName = [coder decodeObjectForKey:@"LastName"];
        self.uuid = [coder decodeObjectForKey:@"UUID"];
        self.location = [coder decodeObjectForKey:@"Location"];
        self.friends = [coder decodeObjectForKey:@"Friends"];
    }
    return self;
}

- (instancetype)initWithRecord:(CKRecord*)record{
    self = [super init];
    if (self) {
        
        self.firstName = [record objectForKey:@"FirstName"];
        self.lastName = [record objectForKey:@"LastName"];
        self.uuid = [record objectForKey:@"UUID"];
        self.friends = [record objectForKey:@"Friends"];
        if(self.friends == nil) {
            self.friends = [@[]mutableCopy];
        }
    }
    return self;
}


- (instancetype)initWithDiscoveredUserInfo:(CKDiscoveredUserInfo*) userInfo{
    self = [super init];
    if (self) {
        self.firstName = userInfo.displayContact.givenName;
        self.lastName = userInfo.displayContact.familyName;
        self.uuid = [NSString stringWithFormat:@"uuid%@", userInfo.userRecordID.recordName];
        self.recordID = userInfo.userRecordID;
//        self.uuid = [record objectForKey:@"uuid"];
        self.friends = [@[]mutableCopy];

    }
    return self;
    
}

- (CKRecord*)recordRepresentation{
    CKRecord *record = [[CKRecord alloc]initWithRecordType:@"Photographers" recordID:self.recordID];
    record[@"FirstName"] = self.firstName;
    record[@"LastName"] = self.lastName;
    record[@"UUID"] = self.uuid;
//    record[@"Location"] = self.location;
    record[@"Friends"] = self.friends;
    return record;
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

-(NSString*)description{
    return  [NSString stringWithFormat:@"%@ %@ %@", self.firstName, self.lastName, self.uuid];
}

+ (BOOL)supportsSecureCoding{
    return YES;
}
@end
