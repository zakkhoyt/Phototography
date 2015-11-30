//
//  ZHUserAsset.h
//  Phototography
//
//  Created by Zakk Hoyt on 11/29/15.
//  Copyright © 2015 Zakk Hoyt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <Photos/Photos.h>
#import <CloudKit/CloudKit.h>

@interface ZHAsset : NSObject
@property (nonatomic, strong) NSDate *dateCreated;
@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, strong) NSString *localIdentifier;
@property (nonatomic, strong) NSString *ownerUUID;

- (instancetype)initWithAsset:(PHAsset*)asset;
- (instancetype)initWithRecord:(CKRecord*)record;
- (CKRecord*)recordRepresentation;
@end

@interface ZHAsset (NSSecureCoding) <NSSecureCoding>

@end
