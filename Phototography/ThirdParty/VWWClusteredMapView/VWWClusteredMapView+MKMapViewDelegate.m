//
//  ClusteredMapView+MKMapViewDelegate.m
//  VWWClusteredMapView
//
//  Created by Zakk Hoyt on 3/28/15.
//  Copyright (c) 2015 Zakk Hoyt. All rights reserved.

#import "VWWClusteredMapView.h"
#import "VWWClusteredMapView+MKMapViewDelegate.h"
#import "VWWClusteredMapView+ClassExtension.h"
#import "VWWClusteredMapView+Private.h"

@implementation VWWClusteredMapView (MKMapViewDelegate)


- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated {
    if([self.delegate respondsToSelector:@selector(clusteredMapView:regionWillChangeAnimated:)]) {
        [self.delegate clusteredMapView:self regionWillChangeAnimated:animated];
    }
}
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    [self refreshClusterableAnnotations];
    if([self.delegate respondsToSelector:@selector(clusteredMapView:regionDidChangeAnimated:)]) {
        [self.delegate clusteredMapView:self regionDidChangeAnimated:animated];
    }
}


- (void)mapViewWillStartLoadingMap:(MKMapView *)mapView {
    if([self.delegate respondsToSelector:@selector(clusteredMapViewWillStartLoadingMap:)]) {
        [self.delegate clusteredMapViewWillStartLoadingMap:self];
    }
}


- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView {
    if([self.delegate respondsToSelector:@selector(clusteredMapViewDidFinishLoadingMap:)]) {
        [self.delegate clusteredMapViewDidFinishLoadingMap:self];
    }
}


- (void)mapViewDidFailLoadingMap:(MKMapView *)mapView withError:(NSError *)error {
    if([self.delegate respondsToSelector:@selector(clusteredMapViewDidFailLoadingMap:withError:)]) {
        [self.delegate clusteredMapViewDidFailLoadingMap:self withError:error];
    }
}

- (void)mapViewWillStartRenderingMap:(MKMapView *)mapView NS_AVAILABLE(10_9, 7_0) {
    if([self.delegate respondsToSelector:@selector(clusteredMapViewWillStartRenderingMap:)]) {
        [self.delegate clusteredMapViewWillStartRenderingMap:self];
    }
}

- (void)mapViewDidFinishRenderingMap:(MKMapView *)mapView fullyRendered:(BOOL)fullyRendered NS_AVAILABLE(10_9, 7_0) {
    if([self.delegate respondsToSelector:@selector(clusteredMapViewDidFinishRenderingMap:fullyRendered:)]) {
        [self.delegate clusteredMapViewDidFinishRenderingMap:self fullyRendered:fullyRendered];
    }
}
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {

    
    if([self.delegate respondsToSelector:@selector(clusteredMapView:viewForClusteredAnnotation:)]) {
        VWWClusteredAnnotationView *view = [self.delegate clusteredMapView:self viewForClusteredAnnotation:annotation];
        view.animateReclusting = self.animateReclusting;
        view.animationType = self.addAnimationType;
        view.addAnnotationAnimationDuration = self.addAnnotationAnimationDuration;
        return view;
    }
    
    return nil;
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
    [views enumerateObjectsUsingBlock:^(VWWClusteredAnnotationView *view, NSUInteger idx, BOOL *stop) {
        [self setAnimationPointsForAnnotationView:view];
    }];
    
    if([self.delegate respondsToSelector:@selector(clusteredMapView:didAddAnnotationViews:)]) {
        [self.delegate clusteredMapView:self didAddAnnotationViews:views];
    }
}

#if TARGET_OS_IPHONE
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    if([self.delegate respondsToSelector:@selector(clusteredMapView:annotationView:calloutAccessoryControlTapped:)]) {
        [self.delegate clusteredMapView:self annotationView:view calloutAccessoryControlTapped:control];
    }
}
#endif

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view NS_AVAILABLE(10_9, 4_0) {
    if([NSStringFromClass([view class]) isEqualToString:@"MKModernUserLocationView"]){
        NSLog(@"Interacted with MKModernUserLocationView. Returning");
        return;
    }
    
    if([self.delegate respondsToSelector:@selector(clusteredMapView:didSelectClusteredAnnotationView:)]) {
        if([view isKindOfClass:[VWWClusteredAnnotationView class]] == NO) {
            NSAssert(NO, @"View for clusteredAnnotation must inherit from VWWClusteredAnnotationView");
            return;
        } else {
            NSSet *annotationViews = [self annotationViewsOverlappingWithAnnotationView:(VWWClusteredAnnotationView*)view];
            NSLog(@"Found %ld annotations overlapping: ", (unsigned long)annotationViews.count);
            if(annotationViews.count == 1){
                [self.delegate clusteredMapView:self didSelectClusteredAnnotationView:(VWWClusteredAnnotationView*)view];
            } else {
                CGPoint point = view.center;
                VWWAnnotationFanoutView *contextMenu = [[VWWAnnotationFanoutView alloc]init];
                [contextMenu showContextForMapView:self.mapView
                                           atPoint:point
                                         menuViews:annotationViews.allObjects completionBlock:^(NSUInteger index) {
                                             VWWClusteredAnnotationView *view = annotationViews.allObjects[index];
                                             [self.delegate clusteredMapView:self didSelectClusteredAnnotationView:(VWWClusteredAnnotationView*)view];
                                         }];
            }
        }
    }
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view NS_AVAILABLE(10_9, 4_0) {
    if([NSStringFromClass([view class]) isEqualToString:@"MKModernUserLocationView"]){
        NSLog(@"Interacted with MKModernUserLocationView. Returning");
        return;
    }

    if([self.delegate respondsToSelector:@selector(clusteredMapView:didDeselectClusteredAnnotationView:)]) {
        if([view isKindOfClass:[VWWClusteredAnnotationView class]] == NO) {
            NSAssert(NO, @"View for clusteredAnnotation must inherit from VWWClusteredAnnotationView");
            return;
        } else {
            [self.delegate clusteredMapView:self didDeselectClusteredAnnotationView:(VWWClusteredAnnotationView*)view];
        }
    }
}

- (void)mapViewWillStartLocatingUser:(MKMapView *)mapView NS_AVAILABLE(10_9, 4_0) {
    if([self.delegate respondsToSelector:@selector(clusteredMapViewWillStartLocatingUser:)]) {
        [self.delegate clusteredMapViewWillStartLocatingUser:self];
    }
}

- (void)mapViewDidStopLocatingUser:(MKMapView *)mapView NS_AVAILABLE(10_9, 4_0) {
    if([self.delegate respondsToSelector:@selector(clusteredMapViewDidStopLocatingUser:)]) {
        [self.delegate clusteredMapViewDidStopLocatingUser:self];
    }
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation NS_AVAILABLE(10_9, 4_0) {
    if([self.delegate respondsToSelector:@selector(clusteredMapView:didUpdateUserLocation:)]) {
        [self.delegate clusteredMapView:self didUpdateUserLocation:userLocation];
    }
}
- (void)mapView:(MKMapView *)mapView didFailToLocateUserWithError:(NSError *)error NS_AVAILABLE(10_9, 4_0) {
    if([self.delegate respondsToSelector:@selector(clusteredMapView:didFailToLocateUserWithError:)]) {
        [self.delegate clusteredMapView:self didFailToLocateUserWithError:error];
    }
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState NS_AVAILABLE(10_9, 4_0) {
    if([self.delegate respondsToSelector:@selector(clusteredMapView:annotationView:didChangeDragState:fromOldState:)]) {
        [self.delegate clusteredMapView:self annotationView:view didChangeDragState:newState fromOldState:oldState];
    }
}


#if TARGET_OS_IPHONE
- (void)mapView:(MKMapView *)mapView didChangeUserTrackingMode:(MKUserTrackingMode)mode animated:(BOOL)animated NS_AVAILABLE(NA, 5_0) {
    if([self.delegate respondsToSelector:@selector(clusteredMapView:didChangeUserTrackingMode:animated:)]) {
        [self.delegate clusteredMapView:self didChangeUserTrackingMode:mode animated:animated];
    }
}
#endif

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id <MKOverlay>)overlay NS_AVAILABLE(10_9, 7_0) {
    if([self.delegate respondsToSelector:@selector(clusteredMapView:rendererForOverlay:)]) {
        return [self.delegate clusteredMapView:self rendererForOverlay:overlay];
    }
    return nil;
}
- (void)mapView:(MKMapView *)mapView didAddOverlayRenderers:(NSArray *)renderers NS_AVAILABLE(10_9, 7_0) {
    if([self.delegate respondsToSelector:@selector(clusteredMapView:didAddOverlayRenderers:)]) {
        [self.delegate clusteredMapView:self didAddOverlayRenderers:renderers];
    }
}

#if TARGET_OS_IPHONE
- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay NS_DEPRECATED_IOS(4_0, 7_0) {
    if([self.delegate respondsToSelector:@selector(clusteredMapView:viewForOverlay:)]) {
        return [self.delegate clusteredMapView:self viewForOverlay:overlay];
    }
    return nil;
    
}

- (void)mapView:(MKMapView *)mapView didAddOverlayViews:(NSArray *)overlayViews NS_DEPRECATED_IOS(4_0, 7_0) {
    if([self.delegate respondsToSelector:@selector(clusteredMapView:didAddOverlayViews:)]) {
        [self.delegate clusteredMapView:self didAddOverlayViews:overlayViews];
    }
}
#endif




@end
