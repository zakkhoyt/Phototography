//
//  ZHFindFriendsViewController.m
//  Phototography
//
//  Created by Zakk Hoyt on 11/27/15.
//  Copyright © 2015 Zakk Hoyt. All rights reserved.
//

#import "ZHFindFriendsViewController.h"
#import "ZHContactsManager.h"
#import "ZHFriendTableViewCell.h"

typedef enum {
    ZHFindFriendsViewControllerFindTypeAddressBook = 0,
    ZHFindFriendsViewControllerFindTypeEmailSearch = 1,
} ZHFindFriendsViewControllerFindType;

@interface ZHFindFriendsViewController ()
@property (weak, nonatomic) IBOutlet UIView *addressBookView;
@property (weak, nonatomic) IBOutlet UIView *searchEmailView;
@property (weak, nonatomic) IBOutlet UITextField *emailSearchTextField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *findTypeSegment;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
//@property (nonatomic, strong) ZHContactsManager *contactManager;
@property (nonatomic, strong) NSMutableArray *users;
@end


@interface ZHFindFriendsViewController (UITableViewDataSource) <UITableViewDataSource>
@end

@interface ZHFindFriendsViewController (UITableViewDelegate) <UITableViewDelegate>
@end

@implementation ZHFindFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //    self.contactManager = [[ZHContactsManager alloc]init];
    self.tableView.hidden = YES;
    self.tableView.contentInset = UIEdgeInsetsZero;
}



- (IBAction)findTypeSegmentValueChanged:(UISegmentedControl*)sender {
    if(sender.selectedSegmentIndex == ZHFindFriendsViewControllerFindTypeAddressBook) {
        self.addressBookView.hidden = NO;
        self.searchEmailView.hidden = YES;
    } else if(sender.selectedSegmentIndex == ZHFindFriendsViewControllerFindTypeEmailSearch) {
        self.searchEmailView.hidden = NO;
        self.addressBookView.hidden = YES;
    }
}
- (IBAction)closeBarButtonAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}


- (IBAction)addressBookButtonTouchUpInside:(id)sender {
    //    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //    hud.labelText = @"Reading contacts...";
    //    [self.contactManager getEmailContactsWithCompletionBlock:^(NSArray<CNContact*> *contacts, NSError *error) {
    //        if(error != nil) {
    //            dispatch_async(dispatch_get_main_queue(), ^{
    //                [MBProgressHUD hideHUDForView:self.view animated:YES];
    //                [self presentAlertDialogWithTitle:@"Could not read contacts" errorAsMessage:error];
    //            });
    //        } else {
    //            // Let's just assume there is an average of 3 emails per contact for initial capacity
    //            NSMutableArray *emails = [[NSMutableArray alloc]initWithCapacity:contacts.count * 3];
    //            NSLog(@"Foudn the following email addresses: ");
    //            [contacts enumerateObjectsUsingBlock:^(CNContact * _Nonnull contact, NSUInteger idx, BOOL * _Nonnull stop) {
    //                [contact.emailAddresses enumerateObjectsUsingBlock:^(CNLabeledValue<NSString *> * _Nonnull emailAddress, NSUInteger idx, BOOL * _Nonnull stop) {
    //                    NSLog(@"%@", emailAddress.value);
    //                    [emails addObject:emailAddress.value];
    //                }];
    //            }];
    //
    //
    ////            AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    ////            [appDelegate.cloudManager findUsersForEmails:emails completionBlock:^(NSArray *users, NSError *error) {
    ////                if(users.count == 0) {
    ////                    [self presentAlertDialogWithMessage:@"No users found :("];
    ////                } else {
    ////                    self.users = users;
    ////                    [self.tableView reloadData];
    ////                    self.tableView.hidden = NO;
    ////                }
    ////            }];
    //
    //            dispatch_async(dispatch_get_main_queue(), ^{
    //                [MBProgressHUD hideHUDForView:self.view animated:YES];
    ////                [self presentAlertDialogWithMessage:@"TODO: search iCloud"];
    //
    //            });
    //        }
    //    }];
}

- (IBAction)emailSearchButtonTouchUpInsde:(id)sender {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Searching...";
    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate.cloudManager findUsersForEmail:self.emailSearchTextField.text completionBlock:^(NSArray *potentialFriends, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if(potentialFriends.count == 0) {
            [self presentAlertDialogWithMessage:@"No users found :("];
        } else {
            self.users = [potentialFriends mutableCopy];
            [self.tableView reloadData];
            self.tableView.hidden = NO;
        }
    }];
}

@end

@implementation ZHFindFriendsViewController (UITableViewDataSource)
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.users.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZHFriendTableViewCell *cell = [ZHFriendTableViewCell cellForTableView:tableView];
    ZHUser *user = self.users[indexPath.row];
    [cell setUser:user];
    return cell;
}

@end


@implementation ZHFindFriendsViewController (UITableViewDelegate)
#pragma mark UITableViewDelegate (editing)
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    // Empty implementation required
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    __weak typeof(self) welf = self;
    
    UITableViewRowAction *followAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Follow" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
        ZHUser *currentUser = [[ZHUser currentUser] copy];
        ZHUser *friendToAdd = self.users[indexPath.row];
        
        if([currentUser.friendUUIDs containsObject:friendToAdd.uuid] == YES) {
            NSLog(@"Already friends!");
        } else {
            [currentUser.friendUUIDs addObject:friendToAdd.uuid];
            [appDelegate.cloudManager updateUser:currentUser completionBlock:^(ZHUser *user, NSError *error) {
                if(error != nil) {
                    [self presentAlertDialogWithTitle:@"Could not follow user" errorAsMessage:error];
                } else {
                    // Update user
                    [ZHUser setCurrentUser:currentUser];
                    
                    // Update tableView
                    [welf.tableView setEditing:NO animated:YES];
                    
                    // Tell other view controllers and cells
                    [[NSNotificationCenter defaultCenter] postNotificationName:ZHNotificationNamesFriendsUpdated object:nil];
                }
            }];
        }
        [self.tableView setEditing:NO animated:YES];
    }];
    followAction.backgroundColor = [UIColor zhGreenColor];
    return @[followAction];
}
@end
