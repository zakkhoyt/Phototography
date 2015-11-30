//
//  ZHDebugTableViewController.m
//  Phototography
//
//  Created by Zakk Hoyt on 11/29/15.
//  Copyright © 2015 Zakk Hoyt. All rights reserved.
//

#import "ZHDebugTableViewController.h"
#import "ZHLocationManager.h"
#import "ZHAssetManager.h"

@interface ZHDebugTableViewController ()

@end

@implementation ZHDebugTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Debug";
}


- (IBAction)getFriendsAssetsButtonTouchUpInside:(id)sender {

    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Locating...";
    
#if TARGET_IPHONE_SIMULATOR
    CLLocation *location = [[CLLocation alloc]initWithLatitude:37.75 longitude:-122.45];
    [[ZHLocationManager sharedInstance] updateToLocation:location completionBlock:^(CLLocation *location) {
        
        ZHUser *currentUser = [ZHUser currentUser];
        currentUser.location = location;
        
        /// ******* get assets for all friends near location
        AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
        [appDelegate.cloudManager getAssetsNearLocation:location completionBlock:^(NSArray *userAssets, NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if(error != nil) {
                [self presentAlertDialogWithTitle:@"Failed to get assets" errorAsMessage:error];
            } else {
                [self presentAlertDialogWithMessage:[NSString stringWithFormat:@"Found %lu users with assets", (unsigned long)userAssets.count]];
            }
        }];
    }];
#else
    [[ZHLocationManager sharedInstance] updateToCurrentLocationWithCompletionBlock:^(CLLocation *location) {
        ZHUser *currentUser = [ZHUser currentUser];
        currentUser.location = location;
        
        /// ******* get assets for all friends near location
        AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
        [appDelegate.cloudManager getAssetsNearLocation:location completionBlock:^(NSArray *userAssets, NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if(error != nil) {
                [self presentAlertDialogWithTitle:@"Failed to get assets" errorAsMessage:error];
            } else {
                
                

//                NSMutableString *summary = [NSMutableString new];
//                [userAssets enumerateObjectsUsingBlock:^(NSDictionary *dictionary, NSUInteger idx, BOOL * _Nonnull stop) {
//                    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
//                    NSString *uuid = dictionary[@"uuid"];
//                    NSArray *assets = dictionary[@"assets"];
//                    [appDelegate.cloudManager getPhotographerWithUUID:uuid completionBlock:^(ZHUser *user, NSError *error) {
//                        [summary appendFormat:@"%@ - %lu\n", user.fullName, assets.count];
//                        dispatch_semaphore_signal(semaphore);
//                    }];
//                    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
//                }];
//                
                
                [self presentAlertDialogWithMessage:[NSString stringWithFormat:@"Found %lu users with assets", (unsigned long)userAssets.count]];

            }
            
        }];
    }];
#endif


}

- (IBAction)getYourAssetsButtonTouchUpInside:(id)sender {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Locating...";
    
#if TARGET_IPHONE_SIMULATOR
    CLLocation *location = [[CLLocation alloc]initWithLatitude:37.75 longitude:-122.45];
    [[ZHLocationManager sharedInstance] updateToLocation:location completionBlock:^(CLLocation *location) {
        ZHUser *currentUser = [ZHUser currentUser];
        currentUser.location = location;
        
        /// ******* get assets for all friends near location
        AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
        [appDelegate.cloudManager getAssetsNearLocation:location ownerUUID:currentUser.uuid completionBlock:^(NSArray *assets, NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if(error != nil) {
                [self presentAlertDialogWithTitle:@"Failed to get assets" errorAsMessage:error];
            } else {
                [self presentAlertDialogWithMessage:[NSString stringWithFormat:@"Found %lu assets", (unsigned long)assets.count]];
            }
        }];
    }];
#else
    [[ZHLocationManager sharedInstance] updateToCurrentLocationWithCompletionBlock:^(CLLocation *location) {
        ZHUser *currentUser = [ZHUser currentUser];
        currentUser.location = location;
        
        /// ******* get assets for all friends near location
        AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
        [appDelegate.cloudManager getAssetsNearLocation:location ownerUUID:currentUser.uuid completionBlock:^(NSArray *assets, NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if(error != nil) {
                [self presentAlertDialogWithTitle:@"Failed to get assets" errorAsMessage:error];
            } else {
                [self presentAlertDialogWithMessage:[NSString stringWithFormat:@"Found %lu assets", (unsigned long)assets.count]];
            }
        }];
    }];
#endif
}
- (IBAction)updateLocationButtonTouchUpInside:(id)sender {
    [[ZHLocationManager sharedInstance] updateToCurrentLocationWithCompletionBlock:^(CLLocation *location) {
        
        ZHUser *currentUser = [ZHUser currentUser];
        currentUser.location = location;

        // ** Updates currentUser's location
        AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
        [appDelegate.cloudManager updateUser:currentUser completionBlock:^(ZHUser *user, NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if(error != nil) {
                [self presentAlertDialogWithTitle:@"Could not update location" errorAsMessage:error];
            } else {
                [self presentAlertDialogWithMessage:@"Success"];
            }
        }];
    }];
}
- (IBAction)updateAssetsButtonTouchUpInside:(id)sender {
    NSMutableArray *userAssets = [[NSMutableArray alloc]initWithCapacity:[ZHAssetManager sharedInstance].assetsWithLocation.count];
    [[ZHAssetManager sharedInstance].assetsWithLocation enumerateObjectsUsingBlock:^(PHAsset*  _Nonnull phAsset, NSUInteger idx, BOOL * _Nonnull stop) {
        ZHAsset *asset = [[ZHAsset alloc]initWithAsset:phAsset];
        [userAssets addObject:asset];
    }];
    [ZHUser currentUser].assets = userAssets;
    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate.cloudManager updateAssets:[ZHUser currentUser].assets completionBlock:^(NSError *error) {
        if(error) {
            [self presentAlertDialogWithTitle:@"Failed to save assets" errorAsMessage:error];
        } else {
            [self presentAlertDialogWithMessage:@"Saved asset(s)"];
        }
    }];

}

@end