//
//  ZHAssetAnnotationView.m
//  Zakk Hoyt
//
//  Created by Zakk Hoyt on 10/4/15.
//  Copyright © 2015 Zakk Hoyt. All rights reserved.
//

#import "ZHAssetAnnotationView.h"
#import "UIColor+ZH.h"
#import "ZHDefines.h"
#import "ZHAssetManager.h"
#import "ZHAssetAnnotation.h"
#import "VWWClusteredAnnotation.h"

#define ZH_HIDE_ANNOTATION_COUNT 1

@interface ZHAssetAnnotationView ()
@property (strong, nonatomic) UILabel *countLabel;
@end

@implementation ZHAssetAnnotationView
- (instancetype)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self setupLabel];
        [self setCount:0];
        self.layer.zPosition = 0;
    }
    return self;
}

-(void)dealloc{
}

- (void)drawRect:(CGRect)rect{
    if([self.annotation isKindOfClass:[VWWClusteredAnnotation class]]){
        ZHAssetAnnotation *assetAnnotation = [((VWWClusteredAnnotation*)self.annotation).annotations firstObject];
        [[ZHAssetManager sharedInstance] requestResizedImageForAsset:assetAnnotation.asset size:self.bounds.size progressBlock:^(float progress) {
            
        } completionBlock:^(UIImage *image, NSError *error) {
            self.layer.masksToBounds = YES;
            self.layer.cornerRadius = self.bounds.size.width / 2.0;
            [image drawInRect:self.bounds];
        }];
    } else {
        UIImage *image = [UIImage imageNamed:@"target"];
        [image drawInRect:self.bounds];
    }
}


- (void)setupLabel{
    _countLabel = [[UILabel alloc] initWithFrame:self.frame];
    _countLabel.backgroundColor = [UIColor clearColor];
    _countLabel.textColor = [UIColor zhBackgroundColor];
    _countLabel.textAlignment = NSTextAlignmentCenter;
    //    _countLabel.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.75];
    //    _countLabel.shadowOffset = CGSizeMake(0, -1);
    _countLabel.adjustsFontSizeToFitWidth = YES;
    _countLabel.numberOfLines = 1;
    _countLabel.font = [UIFont boldSystemFontOfSize:12];
    _countLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    [self addSubview:_countLabel];
}

- (void)setCount:(NSUInteger)count{
    _count = count;
    
#if defined(ZH_HIDE_ANNOTATION_COUNT)
    self.countLabel.hidden = YES;
#else
    self.countLabel.hidden = self.count == 0;
#endif
    
    CGRect newBounds = CGRectMake(0, 0, roundf(44 * [self scaledValueForValue:count]), roundf(44 * [self scaledValueForValue:count]));
    self.frame = [self centerRect:newBounds onPoint:self.center];
    
    //    CGRect newLabelBounds = CGRectMake(0, 0, newBounds.size.width / 1.3, newBounds.size.height / 1.3);
    CGRect newLabelBounds = CGRectMake(0, 0, newBounds.size.width, newBounds.size.height);
    self.countLabel.frame = [self centerRect:newLabelBounds onPoint:[self centerOfRect:newBounds]];
    self.countLabel.text = [@(_count) stringValue];
    
    
    [self setNeedsDisplay];
}


-(CGPoint)centerOfRect:(CGRect)rect{
    
    return CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
}

-(CGRect)centerRect:(CGRect)rect onPoint:(CGPoint)point{
    CGRect r = CGRectMake(point.x - rect.size.width/2.0,
                          point.y - rect.size.height/2.0,
                          rect.size.width,
                          rect.size.height);
    return r;
}

static CGFloat const VWWScaleFactorAlpha = 0.3;
static CGFloat const VWWScaleFactorBeta = 0.4;

-(CGFloat)scaledValueForValue:(CGFloat)value{
    return 1.0 / (1.0 + expf(-1 * VWWScaleFactorAlpha * powf(value, VWWScaleFactorBeta)));
}


@end
