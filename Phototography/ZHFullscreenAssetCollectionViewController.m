//
//  ZHFullscreenAssetCollectionViewController.m
//  
//
//  Created by Zakk Hoyt on 8/20/15.
//
//

#import "ZHFullscreenAssetCollectionViewController.h"
#import "ZHAssetManager.h"
#import "ZHFullscreenAssetCollectionViewCell.h"

@interface ZHFullscreenAssetCollectionViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (nonatomic, strong) UIView *doubleTapToolTipView;
@property (nonatomic, strong) UIView *doubleFingerTapToolTipView;
@end

@interface ZHFullscreenAssetCollectionViewController (UICollectionViewDataSource) <UICollectionViewDataSource>
@end

@interface ZHFullscreenAssetCollectionViewController (UICollectionViewDelegateFlowLayout) <UICollectionViewDelegateFlowLayout>
@end

@interface ZHFullscreenAssetCollectionViewController (UICollectionViewDelegate) <UICollectionViewDelegate>
@end


@implementation ZHFullscreenAssetCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.collectionView.backgroundColor = [UIColor blackColor];
    [self refreshCollectionView];
    [self.view bringSubviewToFront:self.closeButton];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarHidden = YES;
    self.navigationController.navigationBarHidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark Private methods
-(void)refreshCollectionView{
    [self.collectionView reloadData];
    [self.collectionView performBatchUpdates:^{
        
    } completion:^(BOOL finished) {
        [self.collectionView scrollToItemAtIndexPath:self.indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    }];
}



-(void)shareItems:(NSArray*)items{
    NSMutableArray *activities = [@[]mutableCopy];
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc]initWithActivityItems:items
                                                                                        applicationActivities:activities];
    
    [activityViewController setCompletionWithItemsHandler:^(NSString *activityType, BOOL completed, NSArray *returnedItems, NSError *activityError){
        if(completed){
//            [self dismissViewControllerAnimated:YES completion:^{
//            }];
        }
    }];
    
    
    activityViewController.excludedActivityTypes = @[UIActivityTypePostToTwitter,
                                                     UIActivityTypePostToFacebook,
                                                     UIActivityTypePostToWeibo,
                                                     UIActivityTypePrint,
                                                     UIActivityTypeAssignToContact,
                                                     UIActivityTypeSaveToCameraRoll,
                                                     UIActivityTypeAddToReadingList,
                                                     UIActivityTypePostToFlickr,
                                                     UIActivityTypePostToVimeo,
                                                     UIActivityTypePostToTencentWeibo];
    [self presentViewController:activityViewController animated:YES completion:nil];
    
}


#pragma mark IBActions

- (IBAction)closeButtonTouchUpInside:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end


@implementation ZHFullscreenAssetCollectionViewController (UICollectionViewDataSource)

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.assets.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    

    ZHFullscreenAssetCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZHFullscreenAssetCollectionViewCell" forIndexPath:indexPath];
    cell.asset = self.assets[indexPath.item];
    [cell setActionButtonBlock:^(UIImage *image) {
        if(image){
            [self shareItems:@[image]];
        } else {
            [self presentAlertDialogWithMessage:@"No image available to share"];
        }
    }];
    return cell;
}

@end

@implementation ZHFullscreenAssetCollectionViewController (UICollectionViewDelegateFlowLayout)
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return self.view.bounds.size;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)cv layout:(UICollectionViewLayout*)cvl insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0.0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0.0;
}

@end



@implementation ZHFullscreenAssetCollectionViewController (UICollectionViewDelegate)


@end

@implementation ZHFullscreenAssetCollectionViewController (UIScrollViewDelegate)

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
}


@end
