//
//  ZHOnboardingViewController.m
//  Phototography
//
//  Created by Zakk Hoyt on 11/26/15.
//  Copyright © 2015 Zakk Hoyt. All rights reserved.
//

#import "ZHOnboardingViewController.h"
#import "ZHCloudManager.h"


@interface ZHOnboardingViewController ()
@property (nonatomic, strong) ZHCloudManager *cloudManager;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@end

@implementation ZHOnboardingViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    self.cloudManager = [[ZHCloudManager alloc]init];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self verifyAuthenticated];
}


-(void)verifyAuthenticated{
    [[CKContainer defaultContainer] accountStatusWithCompletionHandler:^(CKAccountStatus accountStatus, NSError *error) {
        if (accountStatus == CKAccountStatusNoAccount) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Sign in to iCloud"
                                                                           message:@"Sign in to your iCloud account to write records. On the Home screen, launch Settings, tap iCloud, and enter your Apple ID. Turn iCloud Drive on. If you don't have an iCloud account, tap Create a new Apple ID."
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"Okay"
                                                      style:UIAlertActionStyleCancel
                                                    handler:nil]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self presentViewController:alert animated:YES completion:nil];
            });
        }
    }];
}

- (IBAction)createUserButtonTouchUpInside:(id)sender {
    ZHUser *user = [[ZHUser alloc]init];
    user.firstName = @"Zakk";
    user.lastName = @"Hoyt";
    user.email =  @"zakkhoyt@gmail.com";
    user.phone = @"415-202-3907";
    user.uuid =  [[NSUUID UUID] UUIDString];
    
//    user.firstName = @"Lindy";
//    user.lastName = @"Wood";
//    user.email =  @"woodlindy@gmail.com";
//    user.phone = @"503-866-9212";
//    user.uuid =  [[NSUUID UUID] UUIDString];

    [self.cloudManager createPhotographer:user completionBlock:^(ZHUser *user, NSError *error) {
        if(error){
            NSLog(@"Error: %@", error.localizedDescription);
        } else {
// TODO: Save user object
            NSLog(@"Success :)");
        }
    }];
}


- (IBAction)findFriendsButtonTouchUpInside:(id)sender {
    [self.cloudManager getPhotographersWithEmail:self.emailTextField.text completionBlock:^(NSArray *friends, NSError *error) {
        NSLog(@"%lu friends", (unsigned long)friends.count);
    }];
}



@end
