//
//  ZHFriendTableViewCell.h
//  Phototography
//
//  Created by Zakk Hoyt on 11/28/15.
//  Copyright © 2015 Zakk Hoyt. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZHUser;

@interface ZHFriendTableViewCell : UITableViewCell
+(instancetype)cellForTableView:(UITableView*)tableView;
@property (nonatomic, strong) ZHUser *user;
@end
