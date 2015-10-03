//
//  DetailViewController.m
//  Phototography
//
//  Created by Zakk Hoyt on 10/2/15.
//  Copyright © 2015 Zakk Hoyt. All rights reserved.
//

#import "ZHAssetDetailViewController.h"
#import "ZHAssetManager.h"

@interface ZHAssetDetailViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ZHAssetDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateDescription];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setAsset:(PHAsset *)asset{
    if(_asset != asset){
        _asset = asset;
    }
    [self updateDescription];
}


-(void)updateDescription{
    self.textView.text = self.asset.description;
    [[ZHAssetManager sharedInstance] requestResizedImageForAsset:self.asset imageView:self.imageView progressBlock:^(float progress) {
        
    } completionBlock:^(NSError *error) {
        
    }];
}


@end

