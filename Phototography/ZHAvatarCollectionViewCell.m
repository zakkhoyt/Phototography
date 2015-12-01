//
//  ZHAvatarCollectionViewCell.m
//  Phototography
//
//  Created by Zakk Hoyt on 11/30/15.
//  Copyright © 2015 Zakk Hoyt. All rights reserved.
//

#import "ZHAvatarCollectionViewCell.h"


@interface ZHAvatarCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ZHAvatarCollectionViewCell

-(void)setAvatarForIndex:(NSUInteger)index{
    NSString *avatarName = [NSString stringWithFormat:@"avatar_%05lu", (unsigned long)index];
    self.imageView.image = [UIImage imageNamed:avatarName];
}

@end
