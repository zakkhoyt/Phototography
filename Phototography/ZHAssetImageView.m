//
//  ZHAssetImageView.m
//  Phototography
//
//  Created by Zakk Hoyt on 11/28/15.
//  Copyright © 2015 Zakk Hoyt. All rights reserved.
//

#import "ZHAssetImageView.h"
#import "ZHAssetManager.h"

@implementation ZHAssetImageView

-(void)setAsset:(PHAsset *)asset {
    _asset = asset;
    [[ZHAssetManager sharedInstance] requestResizedImageForAsset:_asset imageView:self progressBlock:^(float progress) {
        
    } completionBlock:^(NSError *error) {
        
    }];
}

@end
