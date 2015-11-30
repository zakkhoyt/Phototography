//
//  ZHUser.m
//  Phototography
//
//  Created by Zakk Hoyt on 11/26/15.
//  Copyright © 2015 Zakk Hoyt. All rights reserved.
//

#import "ZHUser.h"
#import "ZHAvatarImageView.h"
static ZHUser *currentUser;



static NSString *ZHUserFirstNameKey = @"FirstName";
static NSString *ZHUserLastNameKey = @"LastName";
static NSString *ZHUserUUIDKey = @"UUID";
static NSString *ZHUserAvatarNameKey = @"AvatarName";
static NSString *ZHUserLocationKey = @"Location";
static NSString *ZHUserFriendUUIDsKey = @"FriendUUIDs";
static NSString *ZHUserAssetsKey = @"Assets";


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
        self.uuid = [record objectForKey:@"UUID"];
        self.avatarName = [record objectForKey:@"AvatarName"];
        NSArray *friends = [record objectForKey:@"FriendUUIDs"];
        if(friends == nil) {
            self.friendUUIDs = [@[]mutableCopy];
        } else {
            self.friendUUIDs = [friends mutableCopy];
        }
        
        NSArray *assets = [record objectForKey:@"Assets"];
        if(assets == nil) {
            self.assets = [@[]mutableCopy];
        } else {
            self.assets = [assets mutableCopy];
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
        self.avatarName = [ZHAvatarImageView randomAvatarName];
        self.friendUUIDs = [@[]mutableCopy];
        self.assets = [@[]mutableCopy];

    }
    return self;
    
}

- (CKRecord*)recordRepresentation{
    CKRecordID *recordID = [[CKRecordID alloc]initWithRecordName:self.uuid];
    CKRecord *record = [[CKRecord alloc]initWithRecordType:@"Photographers" recordID:recordID];
    record[@"FirstName"] = self.firstName;
    record[@"LastName"] = self.lastName;
    record[@"UUID"] = self.uuid;
    record[@"AvatarName"] = self.avatarName;
    record[@"Location"] = self.location;
    record[@"FriendUUIDs"] = self.friendUUIDs;
    record[@"Assets"] = self.assets;
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
    NSAssert(self.uuid != nil, @"uuid is nil");
    return [self.uuid isEqualToString:aUser.uuid];
}

-(NSUInteger)hash {
    NSAssert(self.uuid != nil, @"uuid is nil");
    return self.uuid.hash;
}

-(NSString*)description{
    return  [NSString stringWithFormat:@"%@ %@ %@", self.firstName, self.lastName, self.uuid];
}

@end


@implementation ZHUser (NSSecureCoding)
+ (BOOL)supportsSecureCoding{
    return YES;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.firstName forKey:@"FirstName"];
    [aCoder encodeObject:self.lastName forKey:@"LastName"];
    [aCoder encodeObject:self.uuid forKey:@"UUID"];
    [aCoder encodeObject:self.avatarName forKey:@"AvatarName"];
    [aCoder encodeObject:self.location forKey:@"Location"];
    [aCoder encodeObject:self.friendUUIDs forKey:@"FriendUUIDs"];
    [aCoder encodeObject:self.assets forKey:@"Assets"];
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        self.firstName = [coder decodeObjectForKey:@"FirstName"];
        self.lastName = [coder decodeObjectForKey:@"LastName"];
        self.uuid = [coder decodeObjectForKey:@"UUID"];
        self.avatarName = [coder decodeObjectForKey:@"AvatarName"];
        self.location = [coder decodeObjectForKey:@"Location"];
        
        NSArray *friendUUIDs = [coder decodeObjectForKey:@"FriendUUIDs"];
        self.friendUUIDs = [friendUUIDs mutableCopy];
        
        NSArray *assets = [coder decodeObjectForKey:@"Assets"];
        self.assets = [assets mutableCopy];

    }
    return self;
}


@end


@implementation ZHUser (NSCopying)

- (id)copyWithZone:(nullable NSZone *)zone{
    ZHUser *user = [ZHUser new];
    user.uuid = [self.uuid copy];
    user.firstName = [self.firstName copy];
    user.lastName = [self.lastName copy];
    user.friendUUIDs = [self.friendUUIDs mutableCopy];
    user.location = [self.location copy];
    user.assets = [self.assets copy];
    return user;
}

@end
