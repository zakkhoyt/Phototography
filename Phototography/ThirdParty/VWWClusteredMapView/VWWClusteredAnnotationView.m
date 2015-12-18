//
//  VWWClusteredAnnotationView.m
//  VWWClusteredMapViewExample
//
//  Created by Zakk Hoyt on 4/17/15.
//  Copyright (c) 2015 Zakk Hoyt. All rights reserved.
//

#import "VWWClusteredAnnotationView.h"
#import "VWWClusteredAnnotation.h"

typedef void(^VWWClusteredAnnotationViewEmptyBlock)(void);

@implementation VWWClusteredAnnotationView

-(void)didMoveToSuperview{
    [super didMoveToSuperview];
    
//    if(self.animateReclusting){
    // Coming soon is to merge and join annotatoins as the user zooms (like in the Photos app's map view).
    // This commented out code doesn't quite work correctly.
//    if(CGPointEqualToPoint(self.mergeToPoint, CGPointZero)){
        switch (self.animationType) {
            case VWWClusteredMapViewAnnotationAddAnimationFade:
                [self animateAddFadeStaggered:NO];
                break;
            case VWWClusteredMapViewAnnotationAddAnimationFadeStaggered:
                [self animateAddFadeStaggered:YES];
                break;
                
            case VWWClusteredMapViewAnnotationAddAnimationAutomatic:
            case VWWClusteredMapViewAnnotationAddAnimationGrow:
                [self animateAddGrowStaggered:NO];
                break;
            case VWWClusteredMapViewAnnotationAddAnimationGrowStaggered:
                [self animateAddGrowStaggered:YES];
                break;
            case VWWClusteredMapViewAnnotationAddAnimationRain:
                [self animateAddRainStaggered:NO];
                break;
            case VWWClusteredMapViewAnnotationAddAnimationRainStaggered:
                [self animateAddRainStaggered:YES];
                break;
            case VWWClusteredMapViewAnnotationAddAnimationNone:
                self.alpha = 1.0;
                self.transform = CGAffineTransformIdentity;
            default:
                break;
        }
//    } else {
//        [self animateMergeToWithCompletionBlock:^{
//            [super removeFromSuperview];
//        }];
//    }
//    }
}

//-(void)removeFromSuperview{
//if(self.animateReclusting){
////    if(CGPointEqualToPoint(self.splitFromPoint, CGPointZero)){
//        [self animateRemoveWithCompletionBlock:^{
//            [super removeFromSuperview];
//        }];
////    } else {
////        [self animateSplitWithCompletionBlock:^{
////            [super removeFromSuperview];
////        }];
////    }
//}
//}


#pragma mark Animations for adding


-(void)animateAddFadeStaggered:(BOOL)staggered{
    NSTimeInterval delay = staggered ? [self staggeredDelay] : 0;
    
    self.transform = CGAffineTransformIdentity;
    self.alpha = 0.0;

    [UIView animateWithDuration:self.addAnnotationAnimationDuration delay:delay options:UIViewAnimationOptionLayoutSubviews animations:^{
        self.alpha = 1.0;
    } completion:NULL];

}
-(void)animateAddGrowStaggered:(BOOL)staggered{
    NSTimeInterval delay = staggered ? [self staggeredDelay] : 0;
    self.transform = CGAffineTransformMakeScale(0.01, 0.01);
    [UIView animateWithDuration:self.addAnnotationAnimationDuration
                          delay:delay
         usingSpringWithDamping:0.25
          initialSpringVelocity:5.0
                        options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:NULL];
}

-(void)animateAddRainStaggered:(BOOL)staggered{
    
    NSTimeInterval delay = staggered ? [self staggeredDelay] : 0;
    
    double frameDuration = 1.0/4.0;
    self.transform = CGAffineTransformMakeScale(2.0, 2.0);
    self.alpha = 0.0;
    [UIView animateKeyframesWithDuration:self.addAnnotationAnimationDuration delay:delay options:UIViewKeyframeAnimationOptionCalculationModeCubicPaced animations:^{
        [UIView addKeyframeWithRelativeStartTime:0*frameDuration relativeDuration:frameDuration animations:^{
            self.transform = CGAffineTransformMakeScale(0.7, 0.7);
            self.alpha = 0.1;
        }];
        [UIView addKeyframeWithRelativeStartTime:1*frameDuration relativeDuration:frameDuration animations:^{
            self.transform = CGAffineTransformMakeScale(1.2, 1.2);
            self.alpha = 0.2;
        }];
        [UIView addKeyframeWithRelativeStartTime:2*frameDuration relativeDuration:frameDuration animations:^{
            self.transform = CGAffineTransformMakeScale(0.9, 0.9);
            self.alpha = 0.5;
        }];
        [UIView addKeyframeWithRelativeStartTime:3*frameDuration relativeDuration:frameDuration animations:^{
            self.transform = CGAffineTransformMakeScale(1.0, 1.0);
            self.alpha = 1.0;
        }];
    } completion:nil];

}


-(NSTimeInterval)staggeredDelay{
    NSTimeInterval delay = (arc4random() % 255) / (float)255; // 0-1 second
    delay *= 0.25;
    return delay;
}

-(void)animateSplitWithCompletionBlock:(VWWClusteredAnnotationViewEmptyBlock)completionBlock{

    CGPoint origin = self.frame.origin;
    
    CGPoint splitFromPoint = self.splitFromPoint;
    splitFromPoint.x -= self.frame.size.width / 2.0;
    splitFromPoint.y -= self.frame.size.height / 2.0;
    CGRect startFrame = CGRectMake(splitFromPoint.x, splitFromPoint.y, self.frame.size.width, self.frame.size.height);
    self.frame = startFrame;

    CGRect endFrame = CGRectMake(origin.x, origin.y, self.frame.size.width, self.frame.size.height);
    
    CGFloat duration = 0.5;
    [UIView animateWithDuration:duration animations:^{
        self.frame = endFrame;
    } completion:^(BOOL finished) {
        completionBlock();
    }];
    
}
-(void)animateMergeToWithCompletionBlock:(VWWClusteredAnnotationViewEmptyBlock)completionBlock{
    CGFloat duration = 0.5;
    
    [UIView animateWithDuration:duration animations:^{
        CGPoint origin = self.frame.origin;
        origin.x += 100;
        self.frame = CGRectMake(origin.x, origin.y, self.frame.size.width, self.frame.size.height);
    } completion:^(BOOL finished) {
        completionBlock();
    }];

}

@end
