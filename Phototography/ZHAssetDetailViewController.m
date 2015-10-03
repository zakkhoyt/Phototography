//
//  DetailViewController.m
//  Phototography
//
//  Created by Zakk Hoyt on 10/2/15.
//  Copyright © 2015 Zakk Hoyt. All rights reserved.
//

#import "ZHAssetDetailViewController.h"
#import "ZHAssetManager.h"
#import "ZHLocationViewController.h"

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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"SegueDetailsToLocation"]){
        ZHLocationViewController *vc = segue.destinationViewController;
        vc.asset = self.asset;
    }
    
}

-(void)setAsset:(PHAsset *)asset{
//    if(_asset != asset){
        _asset = asset;
//    }
    [self updateDescription];
}

-(void)setMoment:(PHAssetCollection*)moment assets:(NSMutableArray*)assets{
//    _moment = moment;
//    _assets = _assets;
}

-(void)updateDescription{
    self.textView.text = self.asset.description;
    [[ZHAssetManager sharedInstance] requestResizedImageForAsset:self.asset imageView:self.imageView progressBlock:^(float progress) {
        
    } completionBlock:^(NSError *error) {
        
    }];
}



- (IBAction)tagBarButtonAction:(id)sender {
    
}


@end

