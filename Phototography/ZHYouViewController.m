//
//  ZHYouViewController.m
//  Phototography
//
//  Created by Zakk Hoyt on 11/27/15.
//  Copyright © 2015 Zakk Hoyt. All rights reserved.
//

#import "ZHYouViewController.h"
#import "ZHFriendTableViewCell.h"
#import "ZHAssetManager.h"
#import "ZHYouViewControllerFriendsHeaderView.h"
#import "ZHYouViewControllerUserDetailHeaderView.h"
#import "ZHPhotographerViewController.h"

static NSString *SegueYouToFindFriends = @"SegueYouToFindFriends";
static NSString *SegueYouToAvatarPicker = @"SegueYouToAvatarPicker";

typedef enum {
    ZHYouViewControllerSectionUserDetails = 0,
    ZHYouViewControllerSectionFriends = 1,
} ZHYouViewControllerSection;

typedef enum {
    ZHYouViewControllerUserDetailFullName = 0,
    ZHYouViewControllerUserDetailAvatar = 1,
    ZHYouViewControllerUserDetailLocation = 2,
    ZHYouViewControllerUserDetailAssetCount = 3,
    ZHYouViewControllerUserDetailSharedAssetCount = 4,
} ZHYouViewControllerUserDetail;


@interface ZHYouViewController ()
@property (nonatomic, strong) ZHCloudManager *cloudManager;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveBarButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end


@interface ZHYouViewController (UITableViewDataSource) <UITableViewDataSource>
@end

@interface ZHYouViewController (UITableViewDelegate) <UITableViewDelegate>
@end


@implementation ZHYouViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    self.cloudManager = appDelegate.cloudManager;

    
    CGFloat top = [UIApplication sharedApplication].statusBarFrame.size.height + self.navigationController.navigationBar.frame.size.height;
    self.tableView.contentInset = UIEdgeInsetsMake(top, 0, 0, 0);
    
    [[NSNotificationCenter defaultCenter] addObserverForName:ZHNotificationNamesCurrentUserUpdated object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        [self.tableView reloadData];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:ZHNotificationNamesFriendsUpdated object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        [self.tableView reloadData];
    }];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    if([segue.identifier isEqualToString:SegueYouToFindFriends]){
//        
//    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)textFieldEditingChanged:(id)sender {
    [self.navigationItem setRightBarButtonItem:self.saveBarButton animated:YES];
}

- (IBAction)saveBarButtonAction:(id)sender {
    
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    
//    ZHUser *user = [ZHUser currentUser];
//    user.firstName = self.firstNameTextField.text;
//    user.lastName = self.lastNameTextField.text;
//    
//    
//    [self.cloudManager updateUser:user completionBlock:^(ZHUser *user, NSError *error) {
//        if(error != nil) {
//            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Could not save account"
//                                                                           message:error.localizedDescription
//                                                                    preferredStyle:UIAlertControllerStyleAlert];
//            [alert addAction:[UIAlertAction actionWithTitle:@"Okay"
//                                                      style:UIAlertActionStyleCancel
//                                                    handler:nil]];
//            
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [MBProgressHUD hideHUDForView:self.view animated:YES];
//                [self presentViewController:alert animated:YES completion:nil];
//            });
//            
//        } else {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [MBProgressHUD hideHUDForView:self.view animated:YES];
//            });
//            
//        }
//    }];
    [self presentAlertDialogWithMessage:@"TODO"];
}

@end


@implementation ZHYouViewController (UITableViewDataSource)
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case ZHYouViewControllerSectionUserDetails:
            return 5;
        case ZHYouViewControllerSectionFriends:
            return [ZHUser currentUser].friendUUIDs.count;
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case ZHYouViewControllerSectionUserDetails: {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserDetailCell" forIndexPath:indexPath];
            switch (indexPath.row) {
                case ZHYouViewControllerUserDetailFullName:
                    cell.textLabel.text = @"FullName";
                    cell.detailTextLabel.text = [ZHUser currentUser].fullName;
                    break;
                case ZHYouViewControllerUserDetailAvatar:
                    cell.textLabel.text = @"Avatar";
                    cell.imageView.image = [UIImage imageNamed:[ZHUser currentUser].avatarName];
                    break;
                case ZHYouViewControllerUserDetailLocation:{
                    cell.textLabel.text = @"Location";
                    cell.detailTextLabel.text = @"";
                    [[ZHUser currentUser].location stringLocalityCompletionBlock:^(NSString *string) {
                        cell.detailTextLabel.text = string;
                    }];
                }
                    break;
                case ZHYouViewControllerUserDetailAssetCount:{
                    cell.textLabel.text = @"# Assets";
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long) [ZHAssetManager sharedInstance].assets.count];
                }
                    break;
                case ZHYouViewControllerUserDetailSharedAssetCount:{
                    cell.textLabel.text = @"# Shared Assets";
                    cell.detailTextLabel.text = [NSString stringWithFormat:@""];
                }
                    break;

                    
                default:
                    break;
            }
            return cell;
            
        }
            break;
        case ZHYouViewControllerSectionFriends: {
            ZHFriendTableViewCell *cell = [ZHFriendTableViewCell cellForTableView:tableView];
            NSString *uuid = [ZHUser currentUser].friendUUIDs[indexPath.row];
            [self.cloudManager getPhotographerWithUUID:uuid completionBlock:^(ZHUser *user, NSError *error) {
                cell.user = user;
            }];
            return cell;
        }
            break;
        default:
            NSAssert(NO, @"Invalid table view index");
            return [UITableViewCell new];
    }
}

@end


@implementation ZHYouViewController (UITableViewDelegate)

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case ZHYouViewControllerSectionUserDetails:{
            if(indexPath.item == ZHYouViewControllerUserDetailAvatar) {
                [self performSegueWithIdentifier:SegueYouToAvatarPicker sender:nil];
            }
        }

            break;
        case ZHYouViewControllerSectionFriends:{
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Photographer" bundle:[NSBundle mainBundle]];
            ZHPhotographerViewController *vc = [storyboard instantiateInitialViewController];
            NSString *uuid = [ZHUser currentUser].friendUUIDs[indexPath.row];
            [self.cloudManager getPhotographerWithUUID:uuid completionBlock:^(ZHUser *user, NSError *error) {
                vc.user = user;
                [self.navigationController pushViewController:vc animated:YES];
            }];
        }
            break;
        default:
            break;
    }
        

}

#pragma mark UITableViewDelegate (header)
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    switch (section) {
        case ZHYouViewControllerSectionUserDetails:
            return 44;
        case ZHYouViewControllerSectionFriends:
            return 44;
        default:
            return 0;
    }
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    NSLog(@"");
    switch (section) {
        case ZHYouViewControllerSectionUserDetails: {
            ZHYouViewControllerUserDetailHeaderView *headerView = [[[NSBundle mainBundle] loadNibNamed:@"ZHYouViewControllerUserDetailHeaderView" owner:self options:nil] firstObject];
            return headerView;
        }
            break;
        case ZHYouViewControllerSectionFriends:{
            ZHYouViewControllerFriendsHeaderView *headerView = [[[NSBundle mainBundle] loadNibNamed:@"ZHYouViewControllerFriendsHeaderView" owner:self options:nil] firstObject];
            [headerView setAddButtonClickedBlock:^{
                [self performSegueWithIdentifier:SegueYouToFindFriends sender:nil];
            }];
            return headerView;
        }
            break;
        default:
            return nil;
    }

    
}

#pragma mark UITableViewDelegate (editing)
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    // Empty implementation required
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case ZHYouViewControllerSectionUserDetails:
            return NO;
        case ZHYouViewControllerSectionFriends:
            return YES;
        default:
            return 0;
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case ZHYouViewControllerSectionFriends: {
            UITableViewRowAction *unfollowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Unfollow" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
                NSString *uuidToRemove = [ZHUser currentUser].friendUUIDs[indexPath.row];
                ZHUser *currentUser = [[ZHUser currentUser] copy];
                [currentUser.friendUUIDs removeObject:uuidToRemove];
                [self.cloudManager updateUser:currentUser completionBlock:^(ZHUser *user, NSError *error) {
                    if(error != nil) {
                        [self presentAlertDialogWithTitle:@"Could not unfollow user" errorAsMessage:error];
                    } else {
                        [ZHUser setCurrentUser:currentUser];
                        [self.tableView reloadData];
                    }
                }];
                [self.tableView setEditing:NO animated:YES];
            }];
            unfollowAction.backgroundColor = [UIColor zhRedColor];
            return @[unfollowAction];
        }
            break;
        default:
            return nil;
    }

}
@end
