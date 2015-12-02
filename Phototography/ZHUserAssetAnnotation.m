//
//  ZHUserAssetAnnotation.m
//  Phototography
//
//  Created by Zakk Hoyt on 12/1/15.
//  Copyright © 2015 Zakk Hoyt. All rights reserved.
//

#import "ZHUserAssetAnnotation.h"
@import  Photos;
#import "ZHUser.h"

@implementation ZHUserAssetAnnotation
-(instancetype)initWithAsset:(PHAsset*)asset user:(ZHUser*)user {
    self = [super init];
    if(self){
        _asset = asset;
        _user = user;
        _coordinate = _asset.location.coordinate;
        _title = user.fullName;
    }
    return self;
}

@end
