//
//  ZHAssetCollectionViewCell.m
//  Phototography
//
//  Created by Zakk Hoyt on 11/28/15.
//  Copyright © 2015 Zakk Hoyt. All rights reserved.
//

#import "ZHAssetCollectionViewCell.h"
#import "ZHAssetImageView.h"
#import "ZHViewControllerImports.h"

@interface ZHAssetCollectionViewCell ()
@property (weak, nonatomic) IBOutlet ZHAssetImageView *assetImageView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end

@implementation ZHAssetCollectionViewCell

-(void)setAsset:(PHAsset *)asset{
    _asset = asset;
    [_assetImageView setAsset:_asset];
    
    self.dateLabel.text = [self.asset.creationDate stringFromDateDayOnlyShort];
}
@end
