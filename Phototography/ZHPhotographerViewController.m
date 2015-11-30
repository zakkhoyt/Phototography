//
//  ZHPhotographerViewController.m
//  Phototography
//
//  Created by Zakk Hoyt on 11/29/15.
//  Copyright © 2015 Zakk Hoyt. All rights reserved.
//

#import "ZHPhotographerViewController.h"

@interface ZHPhotographerViewController ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation ZHPhotographerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.nameLabel.text = self.user.fullName;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
