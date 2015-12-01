//
//  ZHAvatarImageView.m
//  Phototography
//
//  Created by Zakk Hoyt on 11/30/15.
//  Copyright © 2015 Zakk Hoyt. All rights reserved.
//

#import "ZHAvatarImageView.h"
#import "ZHUser.h"

@implementation ZHAvatarImageView

+(NSString*)randomAvatarName{
    NSUInteger random = arc4random() % 115;
    return [NSString stringWithFormat:@"avatar_%05lu", (unsigned long)random];
}


- (instancetype)initWithUser:(ZHUser*)user {
    self = [super init];
    if (self) {
        [self setupAvatarImage];
    }
    return self;
}

-(void)setUser:(ZHUser *)user {
    _user = user;
    [self setupAvatarImage];
}

-(void)setupAvatarImage{
    self.image = [UIImage imageNamed:_user.avatarName];
}

@end
