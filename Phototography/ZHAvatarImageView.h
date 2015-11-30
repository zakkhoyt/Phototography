//
//  ZHAvatarImageView.h
//  Phototography
//
//  Created by Zakk Hoyt on 11/30/15.
//  Copyright © 2015 Zakk Hoyt. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZHUser;

@interface ZHAvatarImageView : UIImageView
+(NSString*)randomAvatarName;
@property (nonatomic, strong) ZHUser *user;
@end
