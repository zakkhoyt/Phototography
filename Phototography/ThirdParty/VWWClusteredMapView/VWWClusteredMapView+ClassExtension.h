//
//  ClusteredMapView+ClassExtension.h
//  VWWClusteredMapView
//
//  Created by Zakk Hoyt on 3/27/15.
//  Copyright (c) 2015 Zakk Hoyt. All rights reserved.
//

#import "VWWClusteredMapView.h"
#import "VWWCoordinateQuadTree.h"


@interface VWWClusteredMapView () 
@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) NSMutableArray *clusteredAnnotations;
@property (nonatomic, strong) NSMutableSet *hiddenSections;
@property (nonatomic, strong) NSMutableArray *lastClusteredAnnotations;

//@property (nonatomic, strong) VWWCoordinateQuadTree *coordinateQuadTree;
@property (nonatomic, strong) NSMutableArray *quadTrees;


@property (nonatomic) MKCoordinateRegion lastRegion;

@property (nonatomic, strong) UIDynamicAnimator* animator;
@property (nonatomic, strong) UIGravityBehavior* gravity;


@end
