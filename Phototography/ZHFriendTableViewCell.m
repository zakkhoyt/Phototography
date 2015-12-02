//
//  ZHFriendTableViewCell.m
//  Phototography
//
//  Created by Zakk Hoyt on 11/28/15.
//  Copyright © 2015 Zakk Hoyt. All rights reserved.
//

#import "ZHFriendTableViewCell.h"
#import "ZHUser.h"
#import "ZHViewControllerImports.h"

@implementation ZHFriendTableViewCell

+(instancetype)cellForTableView:(UITableView*)tableView{
    NSString *identifier = NSStringFromClass([self class]);
    ZHFriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil){
        [tableView registerNib:[UINib nibWithNibName:identifier bundle:[NSBundle mainBundle]] forCellReuseIdentifier:identifier];
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    }
    return cell;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        self.detailTextLabel.text = @"";
        
        [[NSNotificationCenter defaultCenter] addObserverForName:ZHNotificationNamesFriendsUpdated object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
            [self setUser:_user];
            [self setNeedsDisplay];
        }];
    }
    return self;
}

-(void)setUser:(ZHUser *)user{
    _user = user;
    self.textLabel.text = user.fullName;
    
    if([[ZHUser currentUser].friends containsObject:user]){
        self.detailTextLabel.text = @"👍🏼";
    } else {
        self.detailTextLabel.text = @"";
    }
}

@end
