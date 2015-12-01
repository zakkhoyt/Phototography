//
//  ZHAvatarPickerCollectionViewController.m
//  Phototography
//
//  Created by Zakk Hoyt on 11/30/15.
//  Copyright © 2015 Zakk Hoyt. All rights reserved.
//

#import "ZHAvatarPickerCollectionViewController.h"
#import "ZHAvatarCollectionViewCell.h"

@interface ZHAvatarPickerCollectionViewController ()

@end

@implementation ZHAvatarPickerCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 115;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ZHAvatarCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZHAvatarCollectionViewCell" forIndexPath:indexPath];
    [cell setAvatarForIndex:indexPath.item];
    return cell;
}



- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(self.view.bounds.size.width / 3.0, self.view.bounds.size.width / 3.0);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsZero;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *avatarName = [NSString stringWithFormat:@"avatar_%05lu", (unsigned long)indexPath.item];
    ZHUser *currentUser = [[ZHUser currentUser] copy];
    currentUser.avatarName = avatarName;
    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate.cloudManager updateUser:currentUser completionBlock:^(ZHUser *user, NSError *error) {
        if(error != nil) {
            [self presentAlertDialogWithTitle:@"Could not update avatar" errorAsMessage:error];
        } else {
            [ZHUser setCurrentUser:currentUser];
        }
        [self dismissViewControllerAnimated:YES completion:NULL];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}


@end
