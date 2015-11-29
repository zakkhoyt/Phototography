//
//  ZHFullscreenAssetCollectionViewCell.m
//  
//
//  Created by Zakk Hoyt on 8/25/15.
//
//

#import "ZHFullscreenAssetCollectionViewCell.h"
#import "ZHAssetImageView.h"

@import Photos;

@interface ZHFullscreenAssetCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) ZHAssetImageView *assetImageView;
@property (strong, nonatomic) UITapGestureRecognizer *doubleTapRecognizer;
@property (strong, nonatomic) UITapGestureRecognizer *twoFingerTapRecognizer;
@property (nonatomic, strong) ZHFullscreenAssetCollectionViewCellImageBlock actionButtonBlock;
@end

@interface ZHFullscreenAssetCollectionViewCell (UIScrollViewDelegate) <UIScrollViewDelegate>
@end

@implementation ZHFullscreenAssetCollectionViewCell


-(void)layoutSubviews{
    [super layoutSubviews];
    [self centerScrollViewContents];
}


-(void)prepareForReuse{
    [super prepareForReuse];
    
    [self.scrollView removeGestureRecognizer:_twoFingerTapRecognizer];
    [self.scrollView removeGestureRecognizer:_doubleTapRecognizer];
    
    if(_assetImageView){
        [_assetImageView removeFromSuperview];
    }
}



#pragma mark Public methods
-(void)setAsset:(PHAsset *)asset{
    
    // TODO: this class and PKFullscreenWebAssetCollectionViewCell are really the same class wiht a different image view type to zoom in on
    // What we could do is add a public property of UIView and a CGSize property for the full resolution size.
    // The reason this isn't done yet is because PKAssetImageView has a pixelWidth and pixelHeight property where webAsset has webAsset.resolution.width/height.
    // This would allow us to zoom into anythign we like, not just the two image types
    _asset = asset;
    
    self.backgroundColor = [UIColor blackColor];
    
    self.assetImageView = [[ZHAssetImageView alloc]init];
    [self.assetImageView setAsset:_asset];
    self.assetImageView.frame = CGRectMake(0, 0, _asset.pixelWidth, _asset.pixelHeight);
    self.scrollView.delegate = self;
    [self.scrollView addSubview:self.assetImageView];
    
    self.scrollView.contentSize = CGSizeMake(_asset.pixelWidth, _asset.pixelHeight);
    self.scrollView.frame = self.bounds;
    
    self.doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewDoubleTapped:)];
    self.doubleTapRecognizer.numberOfTapsRequired = 2;
    self.doubleTapRecognizer.numberOfTouchesRequired = 1;
    [self.scrollView addGestureRecognizer:self.doubleTapRecognizer];
    
    self.twoFingerTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewTwoFingerTapped:)];
    self.twoFingerTapRecognizer.numberOfTapsRequired = 1;
    self.twoFingerTapRecognizer.numberOfTouchesRequired = 2;
    [self.scrollView addGestureRecognizer:self.twoFingerTapRecognizer];
    
    CGRect scrollViewFrame = self.scrollView.frame;
    CGFloat scaleWidth = scrollViewFrame.size.width / self.scrollView.contentSize.width;
    CGFloat scaleHeight = scrollViewFrame.size.height / self.scrollView.contentSize.height;
    CGFloat minScale = MIN(scaleWidth, scaleHeight);
    self.scrollView.minimumZoomScale = minScale;
    
    self.scrollView.maximumZoomScale = 1.0f;
    self.scrollView.zoomScale = minScale;
    
    
    [self centerScrollViewContents];
    
}

-(void)setActionButtonBlock:(ZHFullscreenAssetCollectionViewCellImageBlock)actionButtonBlock{
    _actionButtonBlock = actionButtonBlock;
}

#pragma mark Private methods


- (void)centerScrollViewContents {
    CGSize boundsSize = self.scrollView.bounds.size;
    CGRect contentsFrame = self.assetImageView.frame;
    
    if (contentsFrame.size.width < boundsSize.width) {
        contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0f;
    } else {
        contentsFrame.origin.x = 0.0f;
    }
    
    if (contentsFrame.size.height < boundsSize.height) {
        contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0f;
    } else {
        contentsFrame.origin.y = 0.0f;
    }
    
    self.assetImageView.frame = contentsFrame;
}


- (void)scrollViewDoubleTapped:(UITapGestureRecognizer*)recognizer {
    // 1
    CGPoint pointInView = [recognizer locationInView:self.assetImageView];
    
    // 2
    CGFloat newZoomScale = self.scrollView.zoomScale * 1.5f;
    newZoomScale = MIN(newZoomScale, self.scrollView.maximumZoomScale);
    
    // 3
    CGSize scrollViewSize = self.scrollView.bounds.size;
    
    CGFloat w = scrollViewSize.width / newZoomScale;
    CGFloat h = scrollViewSize.height / newZoomScale;
    CGFloat x = pointInView.x - (w / 2.0f);
    CGFloat y = pointInView.y - (h / 2.0f);
    
    CGRect rectToZoomTo = CGRectMake(x, y, w, h);
    
    // 4
    [self.scrollView zoomToRect:rectToZoomTo animated:YES];
}


- (void)scrollViewTwoFingerTapped:(UITapGestureRecognizer*)recognizer {
    // Zoom out slightly, capping at the minimum zoom scale specified by the scroll view
    CGFloat newZoomScale = self.scrollView.zoomScale / 1.5f;
    newZoomScale = MAX(newZoomScale, self.scrollView.minimumZoomScale);
    [self.scrollView setZoomScale:newZoomScale animated:YES];
}

#pragma mark IBAction
- (IBAction)shareButtonTouchUpInside:(id)sender {
    UIImage *image = self.assetImageView.image;
    if(_actionButtonBlock){
        _actionButtonBlock(image);
    }
}


@end

@implementation ZHFullscreenAssetCollectionViewCell (UIScrollViewDelegate)
- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    // Return the view that you want to zoom
    return self.assetImageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    // The scroll view has zoomed, so you need to re-center the contents
    [self centerScrollViewContents];
}
@end
