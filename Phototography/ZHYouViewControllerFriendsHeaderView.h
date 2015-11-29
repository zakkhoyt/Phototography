//
//  ZHYouViewControllerFriendsHeaderView.h
//  Phototography
//
//  Created by Zakk Hoyt on 11/28/15.
//  Copyright © 2015 Zakk Hoyt. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ZHYouViewControllerFriendsHeaderViewEmptyBlock)();

@interface ZHYouViewControllerFriendsHeaderView : UIView
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
-(void)setAddButtonClickedBlock:(ZHYouViewControllerFriendsHeaderViewEmptyBlock)addButtonClickedBlock;
@end
