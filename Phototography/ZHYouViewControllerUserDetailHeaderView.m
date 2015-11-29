//
//  ZHYouViewControllerUserDetailHeaderView.m
//  Phototography
//
//  Created by Zakk Hoyt on 11/28/15.
//  Copyright © 2015 Zakk Hoyt. All rights reserved.
//

#import "ZHYouViewControllerUserDetailHeaderView.h"
#import "UIColor+zh.h"

@implementation ZHYouViewControllerUserDetailHeaderView

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        self.backgroundColor = [UIColor zhBackgroundColor];
    }
    return self;
}

@end
