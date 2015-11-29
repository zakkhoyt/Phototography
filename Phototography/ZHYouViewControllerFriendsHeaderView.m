//
//  ZHYouViewControllerFriendsHeaderView.m
//  Phototography
//
//  Created by Zakk Hoyt on 11/28/15.
//  Copyright © 2015 Zakk Hoyt. All rights reserved.
//

#import "ZHYouViewControllerFriendsHeaderView.h"
#import "UIColor+zh.h"

@interface ZHYouViewControllerFriendsHeaderView ()
@property (nonatomic, strong) ZHYouViewControllerFriendsHeaderViewEmptyBlock addButtonClickedBlock;
@end

@implementation ZHYouViewControllerFriendsHeaderView


- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        self.backgroundColor = [UIColor zhBackgroundColor];
    }
    return self;
}

-(void)setAddButtonClickedBlock:(ZHYouViewControllerFriendsHeaderViewEmptyBlock)addButtonClickedBlock{
    _addButtonClickedBlock = addButtonClickedBlock;
}

- (IBAction)addButtonTouchUpInside:(id)sender {
    if(_addButtonClickedBlock){
        _addButtonClickedBlock();
    }
}


@end
