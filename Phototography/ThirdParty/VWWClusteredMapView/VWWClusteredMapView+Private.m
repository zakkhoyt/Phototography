//
//  ClusteredMapView+Private.m
//  VWWClusteredMapView
//
//  Created by Zakk Hoyt on 3/28/15.
//  Copyright (c) 2015 Zakk Hoyt. All rights reserved.
//

#import "VWWClusteredMapView+Private.h"
#import "VWWClusteredMapView+ClassExtension.h"
#import "VWWClusteredAnnotation.h"
#import "VWWClusteredAnnotationView.h"



@implementation VWWClusteredMapView (Private)

-(void)refreshClusterableAnnotations{
    // A quick way to see if the class's dataSource and delegate have been setup
    if(self.quadTrees == nil){
        return;
    }
    
    
    if([self.lock tryLock] == YES){
    
//        self.lastClusteredAnnotations = self.clusteredAnnotations;
        
        double scale = self.bounds.size.width / self.visibleMapRect.size.width;
        
        NSMutableSet *toAddFromAllSections = [[NSMutableSet alloc]init];
        NSMutableSet *toRemoveFromAllSections = [[NSMutableSet alloc]init];
        
        NSUInteger sectionCount = [self.dataSource numberOfSectionsInMapView:self];
        
        for(NSUInteger sectionIndex = 0; sectionIndex < sectionCount; sectionIndex++){
            if([self.hiddenSections containsObject:@(sectionIndex)]){
                continue;
            }
            VWWCoordinateQuadTree *quadTree = self.quadTrees[sectionIndex];
            NSArray *clusteredAnnotations = [quadTree clusteredAnnotationsWithinMapRect:self.visibleMapRect withZoomScale:scale];
            NSMutableSet *before = self.clusteredAnnotations[sectionIndex];
            [before removeObject:[self userLocation]];
            NSSet *after = [NSSet setWithArray:clusteredAnnotations];
            NSMutableSet *toKeep = [NSMutableSet setWithSet:before];
            [toKeep intersectSet:after];
            NSMutableSet *toAdd = [NSMutableSet setWithSet:after];
            [toAdd minusSet:toKeep];
            NSMutableSet *toRemove = [NSMutableSet setWithSet:before];
            [toRemove minusSet:after];
            
            
            NSMutableArray *nextCA = [[self.clusteredAnnotations[sectionIndex] allObjects]mutableCopy];
            [nextCA addObjectsFromArray:[toAdd allObjects]];
            [nextCA removeObjectsInArray:[toRemove allObjects]];
            self.clusteredAnnotations[sectionIndex] = [NSMutableSet setWithArray:nextCA];
            [toAddFromAllSections unionSet:toAdd];
            [toRemoveFromAllSections unionSet:toRemove];
        }
        
        //    NSLog(@"toRemoveFromAllSections.count: %lu", toRemoveFromAllSections.count);
        //    NSLog(@"toAddFromAllSections.coutn: %lu", toAddFromAllSections.count);
        [self removeAnnotations:[toRemoveFromAllSections allObjects] completionBlock:^{
            [self.mapView addAnnotations:[toAddFromAllSections allObjects]];
            NSTimeInterval interval = self.addAnnotationAnimationDuration + 0.25; // animation + max possible stagger delay
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(interval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.lock unlock];
            });
        }];
        
//        NSLog(@"self.mapView.annotations.count: %lu", (unsigned long) self.mapView.annotations.count);
    }
}

- (void)removeAnnotations:(NSArray*)annotations completionBlock:(VWWClusteredMapViewEmptyBlock)completionBlock{

    if(annotations.count == 0){
        if(completionBlock){
            completionBlock();
        }
        return;
    }
    if(self.addAnimationType == VWWClusteredMapViewAnnotationAddAnimationNone){
        [self.mapView removeAnnotations:annotations];
        if(completionBlock){
            completionBlock();
        }
        return;

    }
    
    if(self.removeAnimationType == VWWClusteredMapViewAnnotationRemoveAnimationGravity){
        // Gravity remove animation
        //    http://www.raywenderlich.com/50197/uikit-dynamics-tutorial
        [annotations enumerateObjectsUsingBlock:^(id<MKAnnotation> annotation, NSUInteger idx, BOOL *stop) {
            MKAnnotationView *annotationView = [self.mapView viewForAnnotation:annotation];
            if(annotationView){
                [self.gravity addItem:annotationView];
            }
        }];
        
        [self.animator addBehavior:self.gravity];
        
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.animator removeBehavior:self.gravity];
            completionBlock();
        });
        
    } else {
        __block NSUInteger count = 0;
        [annotations enumerateObjectsUsingBlock:^(id<MKAnnotation> annotation, NSUInteger idx, BOOL *stop) {
            MKAnnotationView *annotationView = [self.mapView viewForAnnotation:annotation];
            [UIView animateWithDuration:self.removeAnnotationAnimationDuration animations:^(void){
                annotationView.transform = CGAffineTransformMakeScale(0.01, 0.01);
            } completion:^(BOOL finished) {
                [self.mapView removeAnnotation:annotation];
                annotationView.transform = CGAffineTransformIdentity;
                count++;
                if(count == annotations.count){
                    if(completionBlock){
                        completionBlock();
                    }
                }
            }];
        }];
        
    }

  
    
    
    
}

-(void)setAnimationPointsForAnnotationView:(VWWClusteredAnnotationView*)annotationView{
    
//    VWWClusteredAnnotation *annotation = annotationView.annotation;
//    if([annotation isKindOfClass:[VWWClusteredAnnotation class]] == NO){
//        // TODO: Assert
//        return;
//    }
//    
//    NSSet *annotationStacks = [NSSet setWithArray:annotation.annotations];
//    // Find splits
//    for(VWWClusteredAnnotation *lastAnnotation in self.lastClusteredAnnotations){
//        NSSet *lastClusteredAnnotationstacks = [NSSet setWithArray:lastAnnotation.annotations];
//        if([annotationStacks isSubsetOfSet:lastClusteredAnnotationstacks]){
//            CGPoint fromPoint = [self.mapView convertCoordinate:lastAnnotation.coordinate toPointToView:self];
//            annotationView.splitFromPoint = fromPoint;
//            break;
//        }
//    }
//    [self.lastClusteredAnnotations enumerateObjectsUsingBlock:^(NSSet* _Nonnull lastSet, NSUInteger idx, BOOL * _Nonnull stop) {
//        [lastSet enumerateObjectsUsingBlock:^(VWWClusteredAnnotation*  _Nonnull lastAnnotation, BOOL * _Nonnull stop) {
//            NSLog(@"");
//        }];
//    }];
    
//    // Find merges
//    for(VWWClusteredAnnotation *lastAnnotation in self.lastClusteredAnnotations){
//        NSSet *lastClusteredAnnotationstacks = [NSSet setWithArray:lastAnnotation.annotations];
//        if([lastClusteredAnnotationstacks isSubsetOfSet:annotationStacks]){
//            CGPoint toPoint = [self.mapView convertCoordinate:annotation.coordinate toPointToView:self];
//            annotationView.mergeToPoint = toPoint;
//            break;
//        }
//    }
    
}

//-(void)refreshAnnotations{
//    [self.mapView removeAnnotations:self.annotations];
//    [self refreshClusterableAnnotations];
//}




- (void)updateViewsBasedOnMapRegion:(CADisplayLink *)link{
    // Only re-render the layover if region has changed
    if(self.lastRegion.center.latitude != self.mapView.region.center.latitude ||
       self.lastRegion.center.longitude != self.mapView.region.center.longitude ||
       self.lastRegion.span.latitudeDelta != self.mapView.region.span.latitudeDelta  ||
       self.lastRegion.span.longitudeDelta != self.mapView.region.span.longitudeDelta){
        @synchronized(self){
            self.lastRegion = self.mapView.region;
        }
    }
}

-(NSSet*)annotationViewsOverlappingWithAnnotationView:(VWWClusteredAnnotationView*)view{
    
    id<MKAnnotation> annotation = view.annotation;
    // Get point from view.annotation
    MKMapPoint point = MKMapPointForCoordinate(annotation.coordinate);
    
    // Get size
    CGFloat widthRatio = view.bounds.size.width / self.mapView.bounds.size.width; // 0..1
    CGFloat width = self.mapView.visibleMapRect.size.width * widthRatio;

    CGFloat heightRatio = view.bounds.size.height / self.mapView.bounds.size.height; // 0..1
    CGFloat height = self.mapView.visibleMapRect.size.height * heightRatio;

    MKMapSize size = MKMapSizeMake(width, height);
    
    // Make rect
    const CGFloat kFactor = 1.5;
    width *= kFactor;
    height *= kFactor;
    MKMapRect rect = MKMapRectMake(point.x - width/2.0, point.y - height/2.0, size.width, size.height);
    
    //    // Check the rect by printing out human readable terms
    NSLog(@"\n");
    NSLog(@"width: %.1f height: %.1f", width, height);
    NSLog(@"view.class: %@", NSStringFromClass([view class]));
    
    // Get other annotations
    NSSet *overlappingAnnotations = [self.mapView annotationsInMapRect:rect];
    NSMutableSet *set = [[NSMutableSet alloc]initWithCapacity:overlappingAnnotations.count];
    // Fast enumeration on an NSMutableSet seems to be asynchronous
    for(id<MKAnnotation> annotation in overlappingAnnotations.allObjects){
        id overlappingView = [self.mapView viewForAnnotation:annotation];
        
        // Print out human debug stuff
        NSLog(@"overlapping view.class: %@", NSStringFromClass([overlappingView class]));
        
        [set addObject:overlappingView];
    }
    return set;
    
}
@end
