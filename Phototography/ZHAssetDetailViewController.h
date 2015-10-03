//
//  DetailViewController.h
//  Phototography
//
//  Created by Zakk Hoyt on 10/2/15.
//  Copyright © 2015 Zakk Hoyt. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PHAsset;

@interface ZHAssetDetailViewController : UIViewController
@property (strong, nonatomic) PHAsset *asset;
@end

