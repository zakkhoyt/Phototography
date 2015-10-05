//
//  VWWContextOverlayView.m
//  VWWContextMenu
//
//  Created by Tapasya on 27/01/14.
//  Copyright (c)2014 Tapasya. All rights reserved.
//

#import "VWWAnnotationFanoutView.h"
#import "UIColor+ZH.h"
#import "UIView+RenderToImage.h"

const CGFloat VWWAnimationTime = 0.3;
const CGFloat VWWFanAngle = M_PI / 2.0;

@interface VWWAnnotationFanoutItem : NSObject
@property (nonatomic, strong) UIView *originalView;
@property (nonatomic, strong) UIImageView *menuImageView;
@property (nonatomic) CGFloat fanAngle;
@property (nonatomic) CGPoint fanPoint;
@property (nonatomic, strong) CAShapeLayer *lineLayer;
@end

@implementation VWWAnnotationFanoutItem
@end

@interface VWWAnnotationFanoutView () <UIGestureRecognizerDelegate>
@property (nonatomic, strong) NSMutableArray *menuItems;
@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) VWWAnnotationFanoutViewUIntegerBlock completionBlock;
@property (nonatomic) CGPoint menuOrigin;
@property (nonatomic) BOOL isHiding;
@end

@implementation VWWAnnotationFanoutView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        // Initialization code
        self.userInteractionEnabled = YES;
        self.backgroundColor  = [UIColor clearColor];
    }
    return self;
}


-(void)showContextForMapView:(MKMapView*)mapView
                     atPoint:(CGPoint)point
                   menuViews:(NSArray*)menuViews
             completionBlock:(VWWAnnotationFanoutViewUIntegerBlock)completionBlock{
    
    self.mapView = mapView;
    self.menuOrigin = point;
    _completionBlock = completionBlock;
    
    self.menuItems = [[NSMutableArray alloc]initWithCapacity:menuViews.count];
    for(UIView *view in menuViews){
        VWWAnnotationFanoutItem *item = [VWWAnnotationFanoutItem new];
        item.originalView = view;
        [self.menuItems addObject:item];
    }
    
    
    self.frame = self.mapView.bounds;
    [self.mapView addSubview:self];
    
    [UIView animateWithDuration:VWWAnimationTime animations:^{
        self.backgroundColor = [UIColor zhDimBackgroundColor];
    }];
    
    [self showMenu];
}

-(CGFloat)menuAngle{
    CGFloat opposite = self.center.y - self.menuOrigin.y;
    CGFloat adjacent = self.center.x - self.menuOrigin.x;
    CGFloat angle = atan2(opposite, adjacent);
    return angle;
}


-(void)animateFanLinesInForItem:(VWWAnnotationFanoutItem*)item{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:self.menuOrigin];
    CGPoint end = CGPointMake(item.fanPoint.x + item.menuImageView.bounds.size.width / 2.0,
                              item.fanPoint.y + item.menuImageView.bounds.size.height / 2.0);
    [path addLineToPoint:end];
    
    item.lineLayer = [CAShapeLayer layer];
    item.lineLayer.frame = self.bounds;
    item.lineLayer.path = path.CGPath;
    item.lineLayer.strokeColor = [[UIColor zhLightTextColor] CGColor];
    item.lineLayer.fillColor = nil;
    item.lineLayer.lineWidth = 1.0f;
    item.lineLayer.lineJoin = kCALineJoinBevel;
    
    [self.layer insertSublayer:item.lineLayer below:item.menuImageView.layer];
    
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = VWWAnimationTime;
    pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    [item.lineLayer addAnimation:pathAnimation forKey:@"strokeEnd"];
}

-(void)animateFanLinesOutForItem:(VWWAnnotationFanoutItem*)item{
    [CATransaction begin];
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = VWWAnimationTime;
    pathAnimation.fromValue = [NSNumber numberWithFloat:1.0f];
    pathAnimation.toValue = [NSNumber numberWithFloat:0.0f];
    [item.lineLayer addAnimation:pathAnimation forKey:@"strokeEnd"];
    [CATransaction setCompletionBlock:^{
        [item.lineLayer removeFromSuperlayer];
    }];
    
    [CATransaction commit];
}

-(void)showMenu{
    CGFloat anglePerItem = VWWFanAngle;
    anglePerItem /= (float)self.menuItems.count - 1;
    CGFloat kDistanceFromOrigin = 25 * self.menuItems.count;
    kDistanceFromOrigin = MIN(kDistanceFromOrigin, 200);
    for(NSUInteger index = 0; index < self.menuItems.count; index++){
        VWWAnnotationFanoutItem *item = self.menuItems[index];
        UIImage *image = [item.originalView imageRepresentation];
        item.menuImageView = [[UIImageView alloc]initWithImage:image];
        item.menuImageView.userInteractionEnabled = YES;
        item.menuImageView.frame = CGRectMake(self.menuOrigin.x - item.originalView.frame.size.width / 2.0,
                                              self.menuOrigin.y - item.originalView.frame.size.height / 2.0,
                                              item.originalView.frame.size.width,
                                              item.originalView.frame.size.height);
        [self addSubview:item.menuImageView];
        item.originalView.alpha = 0.0;
        
        // Move to fanout point
        CGFloat itemAngle = index * anglePerItem;
        CGFloat deltaX = kDistanceFromOrigin * cos(self.menuAngle - VWWFanAngle / 2.0 + itemAngle);
        CGFloat deltaY = kDistanceFromOrigin * sin(self.menuAngle - VWWFanAngle / 2.0 + itemAngle);
        item.fanPoint = CGPointMake(self.menuOrigin.x + deltaX,
                                    self.menuOrigin.y + deltaY);
        item.fanAngle = self.menuAngle - VWWFanAngle / 2.0 + itemAngle;
        [self animateFanLinesInForItem:item];
        
        [UIView animateWithDuration:VWWAnimationTime delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            item.menuImageView.frame = CGRectMake(item.fanPoint.x,
                                                  item.fanPoint.y,
                                                  item.originalView.frame.size.width,
                                                  item.originalView.frame.size.height);
            
        } completion:NULL];
    }
}




-(void)hideMenu{
    
    if(self.isHiding == YES){
        return;
    }
    self.isHiding = YES;
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    for(NSUInteger index = 0; index < self.menuItems.count; index++){
        dispatch_group_enter(group);
        VWWAnnotationFanoutItem *item = self.menuItems[index];
        [self animateFanLinesOutForItem:item];
        [UIView animateWithDuration:VWWAnimationTime delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.backgroundColor = [UIColor clearColor];
            item.menuImageView.frame = item.originalView.frame;
            [self animateFanLinesOutForItem:item];
        } completion:^(BOOL finished) {
            dispatch_group_leave(group);
        }];
    }
    
    dispatch_group_notify(group, queue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            for(NSUInteger index = 0; index < self.menuItems.count; index++){
                VWWAnnotationFanoutItem *item = self.menuItems[index];
                item.originalView.alpha = 1.0;
                [item.menuImageView removeFromSuperview];
            }
            [self removeFromSuperview];
        });
    });
    
}

-(UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    for(NSUInteger index = 0; index < self.menuItems.count; index++){
        VWWAnnotationFanoutItem *item = self.menuItems[index];
        if(CGRectContainsPoint(item.menuImageView.frame, point)){
            if(_completionBlock){
                _completionBlock(index);
            }
            [self hideMenu];
            return item.menuImageView;
        }
    }
    
    [self hideMenu];
    return self;
}
@end
