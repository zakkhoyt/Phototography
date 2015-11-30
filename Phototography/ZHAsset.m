//
//  ZHUserAsset.m
//  Phototography
//
//  Created by Zakk Hoyt on 11/29/15.
//  Copyright © 2015 Zakk Hoyt. All rights reserved.
//

#import "ZHAsset.h"
#import "ZHUser.h"

static NSString *ZHUserAssetDateCreatedKey = @"DateCreated";
static NSString *ZHUserAssetLocationKey = @"Location";
static NSString *ZHUserAssetLocalIdentifierKey = @"LocalIdentifier";
static NSString *ZHUserAssetLocalOwnerUUIDKey = @"OwnerUUID";

@implementation ZHAsset
- (instancetype)initWithAsset:(PHAsset*)asset {
    self = [super init];
    if (self) {
        self.dateCreated = asset.creationDate;
        self.location = asset.location;
        self.localIdentifier = asset.localIdentifier;

        CKRecord *record = [[ZHUser currentUser] recordRepresentation];
        self.ownerUUID = [[CKReference alloc]initWithRecord:record action:CKReferenceActionDeleteSelf];
    }
    return self;
}

- (CKRecord*)recordRepresentation{
    CKRecordID *recordID = [[CKRecordID alloc]initWithRecordName:self.localIdentifier];
    CKRecord *record = [[CKRecord alloc]initWithRecordType:@"Assets" recordID:recordID];
    record[ZHUserAssetDateCreatedKey] = self.dateCreated;
    record[ZHUserAssetLocationKey] = self.location;
    record[ZHUserAssetLocalIdentifierKey] = self.localIdentifier;
    record[ZHUserAssetLocalOwnerUUIDKey] = self.ownerUUID;
    return record;
}

@end

@implementation ZHAsset (NSSecureCoding)
+ (BOOL)supportsSecureCoding{
    return YES;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.dateCreated forKey:ZHUserAssetDateCreatedKey];
    [aCoder encodeObject:self.location forKey:ZHUserAssetLocationKey];
    [aCoder encodeObject:self.localIdentifier forKey:ZHUserAssetLocalIdentifierKey];
    [aCoder encodeObject:self.ownerUUID forKey:ZHUserAssetLocalOwnerUUIDKey];
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        self.dateCreated = [coder decodeObjectForKey:ZHUserAssetDateCreatedKey];
        self.location = [coder decodeObjectForKey:ZHUserAssetLocationKey];
        self.localIdentifier = [coder decodeObjectForKey:ZHUserAssetLocalIdentifierKey];
        self.ownerUUID = [coder decodeObjectForKey:ZHUserAssetLocalOwnerUUIDKey];
    }
    return self;
}


@end