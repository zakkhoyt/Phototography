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


-(void)setUser:(ZHUser *)user{
    _user = user;
    self.textLabel.text = user.fullName;
    
    self.detailTextLabel.text = @"";
    [user.location stringLocalityCompletionBlock:^(NSString *string) {
        self.detailTextLabel.text = string;
    }];
}

@end
