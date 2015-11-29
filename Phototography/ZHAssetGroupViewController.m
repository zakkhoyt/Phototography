//
//  ZHAssetGroupViewController.m
//  Phototography
//
//  Created by Zakk Hoyt on 11/28/15.
//  Copyright © 2015 Zakk Hoyt. All rights reserved.
//

#import "ZHAssetGroupViewController.h"
#import "ZHAssetCollectionViewCell.h"

@interface ZHAssetGroupViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end


@interface ZHAssetGroupViewController (UICollectionViewDataSource) <UICollectionViewDataSource>

@end


@interface ZHAssetGroupViewController (UICollectionViewDelegateFlowLayout) <UICollectionViewDelegateFlowLayout>

@end

@interface ZHAssetGroupViewController (UICollectionViewDelegate) <UICollectionViewDelegate>

@end


@implementation ZHAssetGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.collectionView reloadData];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

@end

@implementation ZHAssetGroupViewController (UICollectionViewDataSource)
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.assets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ZHAssetCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZHAssetCollectionViewCell" forIndexPath:indexPath];
    cell.asset = self.assets[indexPath.item];
    return cell;
}

@end


@implementation ZHAssetGroupViewController (UICollectionViewDelegateFlowLayout)


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
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
//    
//}
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
//    
//}

@end

@implementation ZHAssetGroupViewController (UICollectionViewDelegate)

@end
