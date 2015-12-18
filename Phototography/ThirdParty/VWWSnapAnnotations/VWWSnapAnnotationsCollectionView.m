//
//  VWWSnapAnnotationsCollectionView.m
//  VWWClusteredMapView
//
//  Created by Zakk Hoyt on 3/28/15.
//  Copyright (c) 2015 Zakk Hoyt. All rights reserved.


#import "VWWSnapAnnotationsCollectionView.h"

@implementation VWWSnapAnnotationsCollectionView

// Intercept touches on cells only. All others fall through to background controls
-(UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    NSArray *indexPaths = [self indexPathsForVisibleItems];
    for(NSIndexPath *indexPath in indexPaths.reverseObjectEnumerator){
        UICollectionViewCell *cell = [self cellForItemAtIndexPath:indexPath];
        if(CGRectContainsPoint(cell.frame, point)){
            return cell;
        }
    }
    return nil;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    return NO;
}

@end
