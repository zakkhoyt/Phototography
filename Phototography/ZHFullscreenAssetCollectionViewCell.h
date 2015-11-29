//
//  PKFullscreenAssetCollectionViewCell.h
//  
//
//  Created by Zakk Hoyt on 8/25/15.
//
//

#import <UIKit/UIKit.h>

@class PHAsset;

typedef void (^ZHFullscreenAssetCollectionViewCellImageBlock)(UIImage *image);

@interface ZHFullscreenAssetCollectionViewCell : UICollectionViewCell
@property (nonatomic) NSUInteger displayIndex;
@property (nonatomic) NSUInteger displayTotalCount;
@property (nonatomic, strong) PHAsset *asset;
-(void)setActionButtonBlock:(ZHFullscreenAssetCollectionViewCellImageBlock)actionButtonBlock;
@end
