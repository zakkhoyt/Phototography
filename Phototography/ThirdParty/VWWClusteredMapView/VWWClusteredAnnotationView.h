//
//  VWWClusteredAnnotationView.h
//  VWWClusteredMapViewExample
//
//  Created by Zakk Hoyt on 4/17/15.
//  Copyright (c) 2015 Zakk Hoyt. All rights reserved.
//

#import <MapKit/MapKit.h>

typedef NS_ENUM(NSInteger, VWWClusteredMapViewAnnotationAddAnimation) {
    VWWClusteredMapViewAnnotationAddAnimationNone = 0,
    VWWClusteredMapViewAnnotationAddAnimationFade = 1,
    VWWClusteredMapViewAnnotationAddAnimationFadeStaggered = 2,
    VWWClusteredMapViewAnnotationAddAnimationGrow = 3,
    VWWClusteredMapViewAnnotationAddAnimationGrowStaggered = 4,
    VWWClusteredMapViewAnnotationAddAnimationRain = 5,
    VWWClusteredMapViewAnnotationAddAnimationRainStaggered = 6,
    VWWClusteredMapViewAnnotationAddAnimationAutomatic = 100,
};

typedef NS_ENUM(NSInteger, VWWClusteredMapViewAnnotationRemoveAnimation) {
    VWWClusteredMapViewAnnotationRemoveAnimationNone = 0,
    VWWClusteredMapViewAnnotationRemoveAnimationShrink = 1,
    VWWClusteredMapViewAnnotationRemoveAnimationGravity = 2,
    VWWClusteredMapViewAnnotationRemoveAnimationAutomatic = 100,
};


@interface VWWClusteredAnnotationView : MKAnnotationView

// These properties are not meant to be set by the end user.
@property (nonatomic) BOOL animateReclusting;
@property (nonatomic) CGPoint splitFromPoint; // initial position
@property (nonatomic) CGPoint point;
@property (nonatomic) CGPoint mergeToPoint; // final position
@property (nonatomic) VWWClusteredMapViewAnnotationAddAnimation animationType;
@property (nonatomic) NSTimeInterval addAnnotationAnimationDuration;
@end
