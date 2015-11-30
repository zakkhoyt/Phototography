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

@interface ZHUserAsset : NSObject
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, strong) NSString *localIdentifier;
- (instancetype)initWithAsset:(PHAsset*)asset;

@end

@interface ZHUserAsset (NSSecureCoding) <NSSecureCoding>

@end
