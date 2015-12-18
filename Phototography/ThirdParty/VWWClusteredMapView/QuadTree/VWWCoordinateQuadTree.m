//
//  VWWCoordinateQuadTree.m
//  VWWClusteredMapView
//
//  Created by Zakk Hoyt on 3/28/15.
//  Copyright (c) 2015 Zakk Hoyt. All rights reserved.

#import "VWWCoordinateQuadTree.h"
#import "VWWClusteredAnnotation.h"

@import Photos; 

@implementation VWWCoordinateQuadTree{
    NSUInteger _clusterDensity;
}

#pragma mark Public methods
-(instancetype)init{
    self = [super init];
    if(self){
        self.clusterDensity = 1;
    }
    return self;
}

-(void)buildTreeWithItems:(NSArray*)data{
    VWWBoundingBox *world = [VWWBoundingBox boundingBoxForWorld];
    self.root = [VWWQuadTree quadTreeBuildWithData:data count:data.count boundingBox:world capacity:4];
}


// If set use average of all child annotations. Else use the first
#define ZH_COORDINATE_QUAD_TREE_CLUSTER_AVERAGE 1
- (NSArray *)clusteredAnnotationsWithinMapRect:(MKMapRect)rect withZoomScale:(double)zoomScale
{
    double cellSize = [self cellSizeForZoomScale:zoomScale];
    double scaleFactor = zoomScale / cellSize;
    
    NSInteger minX = floor(MKMapRectGetMinX(rect) * scaleFactor);
    NSInteger maxX = floor(MKMapRectGetMaxX(rect) * scaleFactor);
    NSInteger minY = floor(MKMapRectGetMinY(rect) * scaleFactor);
    NSInteger maxY = floor(MKMapRectGetMaxY(rect) * scaleFactor);
    
    NSMutableArray *clusteredAnnotations = [[NSMutableArray alloc] init];
    for (NSInteger x = minX; x <= maxX; x++) {
        for (NSInteger y = minY; y <= maxY; y++) {
#if defined(ZH_COORDINATE_QUAD_TREE_CLUSTER_AVERAGE)
            MKMapRect mapRect = MKMapRectMake(x / scaleFactor, y / scaleFactor, 1.0 / scaleFactor, 1.0 / scaleFactor);
            
            __block double totalX = 0;
            __block double totalY = 0;
            __block int count = 0;
            
            NSMutableArray *annotations = [[NSMutableArray alloc]init];
            VWWBoundingBox *boundingBox = [self boundingBoxForMapRect:mapRect];
            [VWWQuadTree quadTree:self.root gatherDataInRange:boundingBox block:^(VWWQuadTreeNodeData *nodeData) {
                count++;
                totalX += nodeData.coordinate.latitude;
                totalY += nodeData.coordinate.longitude;
                
                NSObject* annotation = nodeData.data;
                [annotations addObject:annotation];
            }];
            
            CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(0, 0);
            coordinate = CLLocationCoordinate2DMake(totalX / count, totalY / count);

            VWWClusteredAnnotation *annotation = [[VWWClusteredAnnotation alloc]initWithCoordinate:coordinate annotations:annotations];
            [clusteredAnnotations addObject:annotation];
#else
            MKMapRect mapRect = MKMapRectMake(x / scaleFactor, y / scaleFactor, 1.0 / scaleFactor, 1.0 / scaleFactor);
            
            __block double firstX = 0;
            __block double firstY = 0;
            __block int count = 0;
            
            NSMutableArray *annotations = [[NSMutableArray alloc]init];
            VWWBoundingBox *boundingBox = [self boundingBoxForMapRect:mapRect];
            [VWWQuadTree quadTree:self.root gatherDataInRange:boundingBox block:^(VWWQuadTreeNodeData *nodeData) {
                count++;
                if(firstX == 0) {
                    firstX += nodeData.coordinate.latitude;
                    firstY += nodeData.coordinate.longitude;
                }
                NSObject* annotation = nodeData.data;
                [annotations addObject:annotation];
            }];
            
            CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(firstX, firstY);

            VWWClusteredAnnotation *annotation = [[VWWClusteredAnnotation alloc]initWithCoordinate:coordinate annotations:annotations];
            [clusteredAnnotations addObject:annotation];
#endif
        }
    }
    
    return [NSArray arrayWithArray:clusteredAnnotations];
}


//-(NSUInteger)density{
//    return _density - 1;
//}
//-(NSUInteger)density{
//    return 1;
//}

-(void)setClusterDensity:(NSUInteger)clusterDensity{
    _clusterDensity = clusterDensity + 1;
}

-(NSUInteger)clusterDensity{
    return _clusterDensity - 1;
}


-(NSUInteger)leafCount{
    
//    self.root
    NSUInteger count = 0;
    [self calculateLeafCountFromNode:self.root count:&count];
    return count;
}
-(NSUInteger)treeHeight{
    return 0;
}


#pragma mark Private methods
-(void)calculateLeafCountFromNode:(VWWQuadTreeNode*)node count:(NSUInteger*)count{
    
    // Base case
    if(node == self.root && *count){
        return;
    }
    
    if(node.northWest){
        [self calculateLeafCountFromNode:node.northWest count:count];
    }
    if(node.northEast){
        [self calculateLeafCountFromNode:node.northEast count:count];
    }
    if(node.southWest){
        [self calculateLeafCountFromNode:node.southWest count:count];
    }
    if(node.southEast){
        [self calculateLeafCountFromNode:node.southEast count:count];
    }
    
    // No children.. we have a leaf here.
    (*count)++;
    return;
}

-(float)cellSizeForZoomScale:(MKZoomScale)zoomScale {
    NSInteger zoomLevel = [self zoomScaleToZoomLevel:zoomScale];
    
    switch (zoomLevel) {
            
        case 13:
        case 14:
        case 15:
            return 32 * _clusterDensity;
        case 16:
        case 17:
        case 18:
            
            return 100 * _clusterDensity;
        case 19:
        case 20:
        case 21:
        case 22:
            return 500 * _clusterDensity;
        default:
            return 24 * _clusterDensity;
    }
}

-(NSInteger)zoomScaleToZoomLevel:(MKZoomScale)scale {
    double totalTilesAtMaxZoom = MKMapSizeWorld.width / 256.0;
    NSInteger zoomLevelAtMaxZoom = log2(totalTilesAtMaxZoom);
    NSInteger zoomLevel = MAX(0, zoomLevelAtMaxZoom + floor(log2f(scale) + 0.5));
    return zoomLevel;
}

-(VWWBoundingBox*)boundingBoxForMapRect:(MKMapRect)mapRect {
    CLLocationCoordinate2D topLeft = MKCoordinateForMapPoint(mapRect.origin);
    CLLocationCoordinate2D botRight = MKCoordinateForMapPoint(MKMapPointMake(MKMapRectGetMaxX(mapRect), MKMapRectGetMaxY(mapRect)));
    
    CLLocationDegrees minLat = botRight.latitude;
    CLLocationDegrees maxLat = topLeft.latitude;
    
    CLLocationDegrees minLon = topLeft.longitude;
    CLLocationDegrees maxLon = botRight.longitude;
    return [[VWWBoundingBox alloc]initWithX0:minLat Y0:minLon XF:maxLat YF:maxLon];
    
}

@end
