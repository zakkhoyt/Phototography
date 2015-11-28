//
//  ZHYouViewController.m
//  Phototography
//
//  Created by Zakk Hoyt on 11/27/15.
//  Copyright © 2015 Zakk Hoyt. All rights reserved.
//

#import "ZHYouViewController.h"

@interface ZHYouViewController ()
@property (nonatomic, strong) ZHCloudManager *cloudManager;
@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *uuidTextField;
@property (weak, nonatomic) IBOutlet UITextField *locationTextField;
@property (weak, nonatomic) IBOutlet UITextField *assetsTextField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveBarButton;
@end

@implementation ZHYouViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    self.cloudManager = appDelegate.cloudManager;

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.firstNameTextField.text = [ZHUser currentUser].firstName;
    self.lastNameTextField.text = [ZHUser currentUser].lastName;
    self.emailTextField.text = [ZHUser currentUser].email;
    self.phoneTextField.text = [ZHUser currentUser].phone;
    self.uuidTextField.text = [ZHUser currentUser].uuid;
//    self.locationTextField.text = [ZHUser currentUser].loc
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)textFieldEditingChanged:(id)sender {
    [self.navigationItem setRightBarButtonItem:self.saveBarButton animated:YES];
}

- (IBAction)saveBarButtonAction:(id)sender {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    ZHUser *user = [ZHUser currentUser];
    user.firstName = self.firstNameTextField.text;
    user.lastName = self.lastNameTextField.text;
    user.email = self.emailTextField.text;
    user.phone = self.phoneTextField.text;
    
    
    [self.cloudManager updateUser:user completionBlock:^(ZHUser *user, NSError *error) {
        if(error != nil) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Could not save account"
                                                                           message:error.localizedDescription
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"Okay"
                                                      style:UIAlertActionStyleCancel
                                                    handler:nil]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [self presentViewController:alert animated:YES completion:nil];
            });

        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
            
        }
    }];
}

@end
