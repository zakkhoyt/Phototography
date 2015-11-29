//
//  ClusteredMapView+Private.h
//  VWWClusteredMapView
//
//  Created by Zakk Hoyt on 3/28/15.
//  Copyright (c) 2015 Zakk Hoyt. All rights reserved.
//

#import "VWWClusteredMapView.h"
#import "VWWClusteredAnnotationView.h"
#import "VWWAnnotationFanoutView.h"
typedef void(^VWWClusteredMapViewEmptyBlock)(void);

@interface VWWClusteredMapView (Private)
-(void)refreshClusterableAnnotations;
-(void)updateViewsBasedOnMapRegion:(CADisplayLink *)link;
-(void)setAnimationPointsForAnnotationView:(VWWClusteredAnnotationView*)annotationView;
-(void)removeAnnotations:(NSArray*)annotations completionBlock:(VWWClusteredMapViewEmptyBlock)completionBlock;
-(NSSet*)annotationViewsOverlappingWithAnnotationView:(VWWClusteredAnnotationView*)view;
@end
