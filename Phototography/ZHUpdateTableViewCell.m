//
//  ZHUpdateTableViewCell.m
//  Phototography
//
//  Created by Zakk Hoyt on 11/28/15.
//  Copyright © 2015 Zakk Hoyt. All rights reserved.
//

#import "ZHUpdateTableViewCell.h"
#import "ZHViewControllerImports.h"

@interface ZHUpdateTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *LocationLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end

@implementation ZHUpdateTableViewCell

-(void)setUpdate:(ZHLocationUpdate *)update{
    _update = update;
    self.LocationLabel.text = @"";
    [_update.location stringLocalityCompletionBlock:^(NSString *string) {
        self.LocationLabel.text = string;
    }];
    
    self.dateLabel.text = [_update.date stringRelativeTimeFromDate];
}
@end
