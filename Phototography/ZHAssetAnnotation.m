//
//  ZHAssetAnnotation.m
//  Zakk Hoyt
//
//  Created by Zakk Hoyt on 10/4/15.
//  Copyright © 2015 Zakk Hoyt. All rights reserved.
//

#import "ZHAssetAnnotation.h"
@import  Photos;

@implementation ZHAssetAnnotation
-(instancetype)initWithAsset:(PHAsset *)asset{
    self = [super init];
    if(self){
        _asset = asset;
        _coordinate = _asset.location.coordinate;
        _title = @"?";
    }
    return self;
}

@end
