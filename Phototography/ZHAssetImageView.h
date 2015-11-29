//
//  ZHAssetImageView.h
//  Phototography
//
//  Created by Zakk Hoyt on 11/28/15.
//  Copyright © 2015 Zakk Hoyt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@interface ZHAssetImageView : UIImageView
@property (nonatomic, strong) PHAsset *asset;
@end
