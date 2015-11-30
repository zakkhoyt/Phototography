//
//  ZHOnboardingViewController.m
//  Phototography
//
//  Created by Zakk Hoyt on 11/26/15.
//  Copyright © 2015 Zakk Hoyt. All rights reserved.
//

#import "ZHOnboardingViewController.h"
#import "VWWPermissionKit.h"

static NSString *SegueOnboardingToMain = @"SegueOnboardingToMain";

@interface ZHOnboardingViewController ()


@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UIButton *findFriendsButton;

@property (nonatomic, strong) ZHCloudManager *cloudManager;
@end

@implementation ZHOnboardingViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    
    self.view.backgroundColor = [UIColor zhTintColor];
    self.titleLabel.textColor = [UIColor zhBackgroundColor];
    self.statusLabel.textColor = [UIColor zhBackgroundColor];
    [self.startButton setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    self.cloudManager = appDelegate.cloudManager;
    
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillEnterForegroundNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        [self verifyAuthenticated];
    }];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.statusLabel.text = @"";
    self.startButton.hidden = YES;
    self.findFriendsButton.hidden = YES;
    [self verifyAuthenticated];
}


-(void)verifyAuthenticated{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Checking iCloud...";
    
    [self.cloudManager loggedInToICloud:^(BOOL loggedIn) {
        if (loggedIn == NO) {
            NSLog(@"Not logged into iCloud");
            self.statusLabel.text = @"Sign in to iCloud";
            NSString *helpString = @"Sign in to your iCloud account. On the Home screen, launch Settings, tap iCloud, and enter your Apple ID. Turn iCloud Drive on. If you don't have an iCloud account, tap Create a new Apple ID.";

            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Sign in to iCloud"
                                                                           message:helpString
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"Okay"
                                                      style:UIAlertActionStyleCancel
                                                    handler:nil]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [self presentViewController:alert animated:YES completion:nil];
            });
        } else {
            NSLog(@"Logged into iCloud");
            hud.labelText = @"Retrieving account...";
            [self.cloudManager userInfo:^(ZHUser *user, NSError *error) {
                if(error != nil) {
                    NSLog(@"Error getting user info: %@", error.localizedDescription);
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Could not retrieve account"
                                                                                   message:@"Failed to retreive your account from iCloud. Try again later."
                                                                            preferredStyle:UIAlertControllerStyleAlert];
                    [alert addAction:[UIAlertAction actionWithTitle:@"Okay"
                                                              style:UIAlertActionStyleCancel
                                                            handler:nil]];

                    dispatch_async(dispatch_get_main_queue(), ^{
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                        [self presentViewController:alert animated:YES completion:nil];
                    });

                } else {
                    
                    // TODO: Now use the private Users record to create a public Photographers record
                    
                    [self.cloudManager createPhotographer:user completionBlock:^(ZHUser *user, NSError *error) {
                        
                        
                        if(error != nil) {
                            NSLog(@"Failed to create photographer from user");
                        } else {
                            NSLog(@"Retrieved user info for %@ %@", user.firstName, user.lastName);
                            [ZHUser setCurrentUser:user];
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [MBProgressHUD hideHUDForView:self.view animated:YES];
                                self.statusLabel.text = [NSString stringWithFormat:@"Welcome to Phototography, %@ %@!\n"
                                                         @"This app will let you know if your friends have taken photos near your current location. You can recreate their photos and share them back. You can search for friends now using the buttons below or set that up later.",
                                                         user.firstName, user.lastName];
                                self.startButton.hidden = NO;
                                self.findFriendsButton.hidden = NO;
                            });
                        }
                    }];
                }
            }];
        }
    }];
}


-(void)checkPermissions{
    VWWPhotosPermission *photos = [VWWPhotosPermission permissionWithLabelText:@"We will read your photo library to find photos without a geotag."];
    VWWContactsPermission *contacts = [VWWContactsPermission permissionWithLabelText:@"Contacts to find your friends"];
//    VWWCoreLocationWhenInUsePermission *locationWhenInUse = [VWWCoreLocationWhenInUsePermission permissionWithLabelText:@"For obtaining your current location"];
    VWWCoreLocationWhenInUsePermission *locationInUse = [VWWCoreLocationWhenInUsePermission permissionWithLabelText:@"please"];
    NSArray *permissions = @[locationInUse, photos, contacts];
//    NSArray *permissions = @[photos];

    [VWWPermissionsManager requirePermissions:permissions
                                       title:@"Welcome to the Phototography! A tool to add geotags to your Apple Photo collection. Approve these permissions, then we can get started."
                          fromViewController:self
                                resultsBlock:^(NSArray *permissions) {
                                    [permissions enumerateObjectsUsingBlock:^(VWWPermission *permission, NSUInteger idx, BOOL *stop) {
                                        NSLog(@"%@ - %@", permission.type, [permission stringForStatus]);
                                        [self performSegueWithIdentifier:SegueOnboardingToMain sender:nil];
                                    }];
                                }];
}


- (IBAction)startButtonTouchUpInside:(id)sender {
//    [self checkPermissions];
    [self performSegueWithIdentifier:SegueOnboardingToMain sender:nil];
}


@end
