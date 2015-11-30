//
//  ZHUserAsset.m
//  Phototography
//
//  Created by Zakk Hoyt on 11/29/15.
//  Copyright © 2015 Zakk Hoyt. All rights reserved.
//

#import "ZHUserAsset.h"

static NSString *ZHUserAssetDateKey = @"Date";
static NSString *ZHUserAssetLocationKey = @"Location";
static NSString *ZHUserAssetLocalIdentifierKey = @"LocalIdentifier";

@implementation ZHUserAsset
- (instancetype)initWithAsset:(PHAsset*)asset {
    self = [super init];
    if (self) {
        self.date = asset.creationDate;
        self.location = asset.location;
        self.localIdentifier = asset.localIdentifier;
    }
    return self;
}
@end

@implementation ZHUserAsset (NSSecureCoding)
+ (BOOL)supportsSecureCoding{
    return YES;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.date forKey:ZHUserAssetDateKey];
    [aCoder encodeObject:self.location forKey:ZHUserAssetLocationKey];
    [aCoder encodeObject:self.localIdentifier forKey:ZHUserAssetLocalIdentifierKey];
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        self.date = [coder decodeObjectForKey:ZHUserAssetDateKey];
        self.location = [coder decodeObjectForKey:ZHUserAssetLocationKey];
        self.localIdentifier = [coder decodeObjectForKey:ZHUserAssetLocalIdentifierKey];
    }
    return self;
}


@end