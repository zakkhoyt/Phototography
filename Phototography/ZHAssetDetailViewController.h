//
//  DetailViewController.h
//  Phototography
//
//  Created by Zakk Hoyt on 10/2/15.
//  Copyright © 2015 Zakk Hoyt. All rights reserved.
//

#import "ZHViewController.h"
@class PHAsset;
@class PHAssetCollection;

@interface ZHAssetDetailViewController : ZHViewController
@property (strong, nonatomic) PHAsset *asset;
-(void)setMoment:(PHAssetCollection*)moment assets:(NSMutableArray*)assets;
@end

