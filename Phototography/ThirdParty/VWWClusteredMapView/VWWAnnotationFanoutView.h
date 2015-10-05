//
//  VWWContextOverlayView.h
//  VWWContextMenu
//
//  Created by Tapasya on 27/01/14.
//  Copyright (c) 2014 Tapasya. All rights reserved.
//

#import <UIKit/UIKit.h>
@import MapKit;

typedef void(^VWWAnnotationFanoutViewUIntegerBlock)(NSUInteger index);

@interface VWWAnnotationFanoutView : UIView

-(void)showContextForMapView:(MKMapView*)mapView
                     atPoint:(CGPoint)point
                   menuViews:(NSArray*)menuViews
             completionBlock:(VWWAnnotationFanoutViewUIntegerBlock)completionBlock;

@end
