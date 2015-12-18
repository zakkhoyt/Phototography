//
//  VWWSnapAnnotationCollectionViewCell.m
//  VWWClusteredMapView
//
//  Created by Zakk Hoyt on 3/28/15.
//  Copyright (c) 2015 Zakk Hoyt. All rights reserved.

#import "VWWSnapAnnotationCollectionViewCell.h"
#import <UIKit/UIKit.h>



@interface VWWSnapAnnotationCollectionViewCell ()
@property (nonatomic, strong) UILabel *locationLabel;
@property (nonatomic, strong) UIImageView *imageView;
@end


@implementation VWWSnapAnnotationCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(0, 0, 44, 44)];
    if (self) {
        [self commonInitWithFrame:self.frame];
    }
    return self;
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self) {
        self.frame = CGRectMake(0, 0, 44, 44);
        [self commonInitWithFrame:self.frame];
    }
    return self;
}

- (void)commonInitWithFrame:(CGRect)frame {
    self.backgroundColor = [UIColor clearColor];
//    self.imageView = [[UIImageView alloc]initWithFrame:self.frame];
//    self.imageView.image = [UIImage imageNamed:SnapAnnotationImage];
//    [self addSubview:self.imageView];
//    self.layer.anchorPoint = CGPointMake(1.0, 0.5);
}

-(void)setAnnotationView:(MKAnnotationView *)annotationView{
    _annotationView = annotationView;
    
    [self.subviews enumerateObjectsUsingBlock:^(UIView *subView, NSUInteger idx, BOOL *stop) {
        [subView removeFromSuperview];
    }];
    
    CGRect frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    _annotationView.frame = frame;

    [self addSubview:_annotationView];
}
@end
