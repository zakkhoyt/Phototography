//
//  ZHPhotographerTableViewCell.m
//  Phototography
//
//  Created by Zakk Hoyt on 12/1/15.
//  Copyright © 2015 Zakk Hoyt. All rights reserved.
//

#import "ZHPhotographerTableViewCell.h"
#import "ZHUser.h"
#import "ZHViewControllerImports.h"


@interface ZHPhotographerTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *friendsLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@end

@implementation ZHPhotographerTableViewCell

+(instancetype)cellForTableView:(UITableView*)tableView{
    NSString *identifier = NSStringFromClass([self class]);
    ZHPhotographerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil){
        [tableView registerNib:[UINib nibWithNibName:identifier bundle:[NSBundle mainBundle]] forCellReuseIdentifier:identifier];
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    }
    return cell;
}

-(void)setUser:(ZHUser *)user{
    _user = user;
    
    _nameLabel.text = _user.fullName;
    
    if(_user.location == nil) {
        _locationLabel.text = @"Parts Unknown";
    } else {
        _locationLabel.text = @"";
        [_user.location stringLocalityCompletionBlock:^(NSString *string) {
            _locationLabel.text = string;
        }];
    }
    if(_user.location == nil) {
        _dateLabel.text = [[NSDate date] stringRelativeTimeFromDate];
    } else {
        _dateLabel.text = [_user.locationDate stringRelativeTimeFromDate];
    }
    _avatarImageView.image = [UIImage imageNamed:_user.avatarName];
    _friendsLabel.text = [NSString stringWithFormat:@"Following %lu photographers", (unsigned long)_user.friends.count];
}
@end
