//
//  VWWCoordinateQuadTree.h
//  VWWClusteredMapView
//
//  Created by Zakk Hoyt on 3/28/15.
//  Copyright (c) 2015 Zakk Hoyt. All rights reserved.

#import <Foundation/Foundation.h>
#import "VWWQuadTree.h"





@interface VWWCoordinateQuadTree : NSObject

@property (nonatomic, strong) VWWQuadTreeNode *root;
@property (nonatomic, strong) MKMapView *mapView;

-(instancetype)init;
-(void)buildTreeWithItems:(NSArray*)data;
-(NSArray*)clusteredAnnotationsWithinMapRect:(MKMapRect)rect withZoomScale:(double)zoomScale;
-(void)setClusterDensity:(NSUInteger)density;
-(NSUInteger)clusterDensity;

-(NSUInteger)leafCount;
-(NSUInteger)treeHeight;


@end
