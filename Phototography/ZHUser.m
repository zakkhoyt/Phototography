//
//  ZHUser.m
//  Phototography
//
//  Created by Zakk Hoyt on 11/26/15.
//  Copyright © 2015 Zakk Hoyt. All rights reserved.
//

#import "ZHUser.h"
#import "ZHAvatarImageView.h"
#import "AppDelegate.h"

static ZHUser *currentUser;
static NSString *ZHUserFirstNameKey = @"FirstName";
static NSString *ZHUserLastNameKey = @"LastName";
static NSString *ZHUserUUIDKey = @"UUID";
static NSString *ZHUserAvatarNameKey = @"AvatarName";
static NSString *ZHUserLocationKey = @"Location";
static NSString *ZHUserLocationDateKey = @"LocationDate";
static NSString *ZHUserFriendsKey = @"Friends";
static NSString *ZHUserAssetsKey = @"Assets";


@implementation ZHUser

+(void)setCurrentUser:(ZHUser*)user{
    currentUser = user;
}

+(ZHUser*)currentUser{
    return currentUser;
}

+(BOOL)isCurrentUser:(ZHUser*)user{
    return [user.uuid isEqualToString:[ZHUser currentUser].uuid];
}

- (instancetype)initWithRecord:(CKRecord*)record{
    self = [super init];
    if (self) {
        
        self.firstName = [record objectForKey:ZHUserFirstNameKey];
        self.lastName = [record objectForKey:ZHUserLastNameKey];
        self.uuid = [record objectForKey:ZHUserUUIDKey];
        self.avatarName = [record objectForKey:ZHUserAvatarNameKey];
        self.location = [record objectForKey:ZHUserLocationKey];
        self.locationDate = [record objectForKey:ZHUserLocationDateKey];
        
        NSArray *friends = [record objectForKey:@"Friends"];
        if(friends == nil) {
            self.friends = [@[]mutableCopy];
        } else {
//            // We only want to exchange references for users for current user, else it will crawl outward and loop.
//            if([ZHUser isCurrentUser:self]) {
//                AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
//                [appDelegate.cloudManager getFriendsForReferences:friends completionBlock:^(NSArray *friends, NSError *error) {
//                    if(error != nil) {
//                        NSLog(@"Error getting friends");
//                        self.friends = [@[]mutableCopy];
//                    } else {
//                        self.friends = [friends mutableCopy];
//                    }
//                }];
//            } else {
            self.friends = [friends copy];
//            }
            
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
        self.friends = [@[]mutableCopy];
        
        self.assets = [@[]mutableCopy];
        
    }
    return self;
    
}

- (CKRecord*)recordRepresentation{
    CKRecordID *recordID = [[CKRecordID alloc]initWithRecordName:self.uuid];
    CKRecord *record = [[CKRecord alloc]initWithRecordType:@"Photographers" recordID:recordID];
    record[ZHUserFirstNameKey] = self.firstName;
    record[ZHUserLastNameKey] = self.lastName;
    record[ZHUserUUIDKey] = self.uuid;

    record[ZHUserAvatarNameKey] = self.avatarName;
    if(self.avatarName == nil) {
        NSAssert(NO, @"avatarName is nil");
    }
    record[ZHUserLocationKey] = self.location;
    record[ZHUserLocationDateKey] = self.locationDate;
    
    NSMutableArray *friendReferences = [[NSMutableArray alloc]initWithCapacity:self.friends.count];
    [self.friends enumerateObjectsUsingBlock:^(ZHUser * _Nonnull user, NSUInteger idx, BOOL * _Nonnull stop) {
        CKRecordID *recordID = [[CKRecordID alloc]initWithRecordName:user.uuid];
        CKReference *friendReference = [[CKReference alloc]initWithRecordID:recordID action:CKReferenceActionNone];
        [friendReferences addObject:friendReference];
    }];
    record[@"Friends"] = friendReferences;
    
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
    return  [NSString stringWithFormat:@"%@ %@\n"
             @"%@\n"
             @"avatar: %@\n"
             @"location: %f,%f\n"
             @"%lu friends\n"
             @"%lu assets\n",
             self.firstName, self.lastName,
             self.uuid,
             self.avatarName,
             self.location.coordinate.latitude, self.location.coordinate.longitude,
             (unsigned long)self.friends.count,
             (unsigned long)self.assets.count];
}

@end


@implementation ZHUser (NSSecureCoding)
+ (BOOL)supportsSecureCoding{
    return YES;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.firstName forKey:ZHUserFirstNameKey];
    [aCoder encodeObject:self.lastName forKey:ZHUserLastNameKey];
    [aCoder encodeObject:self.uuid forKey:ZHUserUUIDKey];
    [aCoder encodeObject:self.avatarName forKey:ZHUserAvatarNameKey];
    [aCoder encodeObject:self.location forKey:ZHUserLocationKey];
    [aCoder encodeObject:self.locationDate forKey:ZHUserLocationDateKey];
    [aCoder encodeObject:self.friends forKey:@"Friends"];
    [aCoder encodeObject:self.assets forKey:@"Assets"];
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        self.firstName = [coder decodeObjectForKey:ZHUserFirstNameKey];
        self.lastName = [coder decodeObjectForKey:ZHUserLastNameKey];
        self.uuid = [coder decodeObjectForKey:ZHUserUUIDKey];
        self.avatarName = [coder decodeObjectForKey:ZHUserAvatarNameKey];
        self.location = [coder decodeObjectForKey:ZHUserLocationKey];
        self.locationDate = [coder decodeObjectForKey:ZHUserLocationDateKey];
        
        NSArray *friends = [coder decodeObjectForKey:@"Friends"];
        self.friends = [friends mutableCopy];
        
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
    user.avatarName = [self.avatarName copy];
    user.friends = [self.friends mutableCopy];
    user.location = [self.location copy];
    user.locationDate = [self.locationDate copy];
    user.assets = [self.assets copy];
    return user;
}

@end
