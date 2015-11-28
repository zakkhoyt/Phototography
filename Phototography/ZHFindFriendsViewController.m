//
//  ZHFindFriendsViewController.m
//  Phototography
//
//  Created by Zakk Hoyt on 11/27/15.
//  Copyright © 2015 Zakk Hoyt. All rights reserved.
//

#import "ZHFindFriendsViewController.h"

typedef enum {
    ZHFindFriendsViewControllerFindTypeAddressBook = 0,
    ZHFindFriendsViewControllerFindTypeEmailSearch = 1,
} ZHFindFriendsViewControllerFindType;

@interface ZHFindFriendsViewController ()
@property (weak, nonatomic) IBOutlet UIView *addressBookView;
@property (weak, nonatomic) IBOutlet UIView *searchEmailView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *findTypeSegment;

@end

@implementation ZHFindFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (IBAction)findTypeSegmentValueChanged:(UISegmentedControl*)sender {
    if(sender.selectedSegmentIndex == ZHFindFriendsViewControllerFindTypeAddressBook) {
        self.addressBookView.hidden = NO;
        self.searchEmailView.hidden = YES;
    } else if(sender.selectedSegmentIndex == ZHFindFriendsViewControllerFindTypeEmailSearch) {
        self.searchEmailView.hidden = NO;
        self.addressBookView.hidden = YES;
    }
}


- (IBAction)addressBookButtonTouchUpInside:(id)sender {
    
}

- (IBAction)emailSearchButtonTouchUpInsde:(id)sender {
    
}

@end
