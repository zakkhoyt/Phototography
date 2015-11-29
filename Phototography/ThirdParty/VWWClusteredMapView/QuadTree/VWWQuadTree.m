//
//  VWWQuadTree.m
//  VWWClusteredMapView
//
//  Created by Zakk Hoyt on 3/28/15.
//  Copyright (c) 2015 Zakk Hoyt. All rights reserved.

#import "VWWQuadTree.h"


@interface VWWQuadTreeNodeData (){
    NSInteger _height;
}

@end
@implementation VWWQuadTreeNodeData

-(instancetype)initWithAnotation:(id<MKAnnotation>)annotation{
    self = [super init];
    if(self){
        _coordinate = annotation.coordinate;
        _data = annotation;
    }
    return self;
}
@end


@implementation VWWBoundingBox
-(instancetype)initWithX0:(CLLocationDegrees)x0 Y0:(CLLocationDegrees)y0 XF:(CLLocationDegrees)xf YF:(CLLocationDegrees)yf{
    self = [super init];
    if(self){
        _x0 = x0;
        _y0 = y0;
        _xf = xf;
        _yf = yf;
    }
    return self;
}
-(NSString*)description{
    return [NSString stringWithFormat:@"x0:%f xf:%f y0:%f yf:%f", _x0, _xf, _y0, _yf];
}

+(VWWBoundingBox*)boundingBoxForWorld{
    return [[VWWBoundingBox alloc]initWithX0:-90 Y0:-180 XF:90 YF:180];
}; 

@end


@implementation VWWQuadTreeNode

-(instancetype)initWithBoundingBox:(VWWBoundingBox*)boundingBox capacity:(NSInteger)capacity{
    self = [super init];
    if(self){
        self.northWest = nil;
        self.northEast = nil;
        self.southWest = nil;
        self.southEast = nil;
        self.boundingBox = boundingBox;
        self.bucketCapacity = capacity;
        self.count = 0;
        self.points = [[NSMutableArray alloc]initWithCapacity:capacity];
    }
    return self;
}

-(NSString*)description{
    return [NSString stringWithFormat:@"\nnorthWest: %@"
            @"\nnorthEast: %@"
            @"\nsouthWest: %@"
            @"\nsouthEast: %@"
            @"\nboundingBox: %@"
            @"\nbucketCapacity: %ld"
            @"\ncount: %ld"
            @"\npoints.size: %ld",
            self.northWest.description,
            self.northEast.description,
            self.southWest.description,
            self.southEast.description,
            self.boundingBox.description,
            (long)self.bucketCapacity,
            (long)self.count,
            (long)self.points.count];
}


//-(NSUInteger)heightFromNode:(VWWQuadTreeNode*)node height:(NSUInteger)height{
//    
//    // Base case
//    
//    
//    // Recursion
//    if(node.northWest){
//        [self heightFromNode:node.northWest height:height];
//    }
//    if(node.northEast){
//        [self heightFromNode:node.northWest height:height];
//    }
//    if(node.southWest){
//        [self heightFromNode:node.northWest height:height];
//    }
//    if(node.southEast){
//        [self heightFromNode:node.northWest height:height];
//    }
//    return 0;
//}


@end

@implementation VWWQuadTree

#pragma mark Public methods

+(void)freeQuadTreeNode:(VWWQuadTreeNode*)node{
    if(node.northWest != nil) [VWWQuadTree freeQuadTreeNode:node.northWest];
    if(node.northEast != nil) [VWWQuadTree freeQuadTreeNode:node.northEast];
    if(node.southWest != nil) [VWWQuadTree freeQuadTreeNode:node.southWest];
    if(node.southEast != nil) [VWWQuadTree freeQuadTreeNode:node.southEast];

    [node.points removeAllObjects];

    node = nil;
}

+(BOOL)boundingBox:(VWWBoundingBox*)box containsData:(VWWQuadTreeNodeData*)data{
    bool containsX = box.x0 <= data.coordinate.latitude && data.coordinate.latitude <= box.xf;
    bool containsY = box.y0 <= data.coordinate.longitude && data.coordinate.longitude <= box.yf;
    return containsX && containsY;
}

+(BOOL)boundingBox:(VWWBoundingBox*)box1 intersectsBoundingBox:(VWWBoundingBox*)box2{
    return (box1.x0 <= box2.xf &&
            box1.xf >= box2.x0 &&
            box1.y0 <= box2.yf &&
            box1.yf >= box2.y0);
}

+(void)quadTreeTraverse:(VWWQuadTreeNode*)node block:(VWWQuadTreeTraverseBlock)block{
    block(node);
    
    if(node.northWest == nil){
        return;
    }
    
    [VWWQuadTree quadTreeTraverse:node.northWest block:block];
    [VWWQuadTree quadTreeTraverse:node.northEast block:block];
    [VWWQuadTree quadTreeTraverse:node.southWest block:block];
    [VWWQuadTree quadTreeTraverse:node.southEast block:block];
}


+(void)quadTree:(VWWQuadTreeNode*)node gatherDataInRange:(VWWBoundingBox*)range block:(VWWDataReturnBlock)block{
    if([VWWQuadTree boundingBox:node.boundingBox intersectsBoundingBox:range] == NO){
        return;
    }
    
    for(NSUInteger index = 0; index < node.count; index++){
        if([VWWQuadTree boundingBox:range containsData:node.points[index]]){
            block(node.points[index]);
        }
    }
    
    if(node.northWest == nil){
        return;
    }
    
    [VWWQuadTree quadTree:node.northWest gatherDataInRange:range block:block];
    [VWWQuadTree quadTree:node.northEast gatherDataInRange:range block:block];
    [VWWQuadTree quadTree:node.southWest gatherDataInRange:range block:block];
    [VWWQuadTree quadTree:node.southEast gatherDataInRange:range block:block];
}

+(BOOL)quadTree:(VWWQuadTreeNode*)node insertData:(VWWQuadTreeNodeData*)data{
    static NSUInteger callCounter = 0;
    callCounter++;

    if([VWWQuadTree boundingBox:node.boundingBox containsData:data] == NO){
        return NO;
    }
    
    if(node.count < node.bucketCapacity){
        node.points[node.count++] = data;
        return YES;
    }
    
    if(node.northWest == nil){
        [VWWQuadTree quadTreeNodeSubdivide:node];
    }
    
    if([VWWQuadTree quadTree:node.northWest insertData:data]){
        return YES;
    }
    if([VWWQuadTree quadTree:node.northEast insertData:data]){
        return YES;
    }
    if([VWWQuadTree quadTree:node.southWest insertData:data]){
        return YES;
    }
    if([VWWQuadTree quadTree:node.southEast insertData:data]){
        return YES;
    }
    
    return NO;
}

+(VWWQuadTreeNode*)quadTreeBuildWithData:(NSArray*)data
                                   count:(NSInteger)count
                             boundingBox:(VWWBoundingBox*)boundingBox
                                capacity:(NSInteger)capacity{
    VWWQuadTreeNode *root = [[VWWQuadTreeNode alloc]initWithBoundingBox:boundingBox capacity:capacity];
    for(NSUInteger index = 0; index < count; index++){
        [VWWQuadTree quadTree:root insertData:data[index]];
    }
    return root;
}


#pragma mark Private methods
+(void)quadTreeNodeSubdivide:(VWWQuadTreeNode*)node {
    VWWBoundingBox *box = node.boundingBox;
    double latitudeMid = (box.xf + box.x0) / 2.0;
    double longitudeMid = (box.yf + box.y0) / 2.0;
    
    VWWBoundingBox *northWest = [[VWWBoundingBox alloc]initWithX0:box.x0 Y0:box.y0 XF:latitudeMid YF:longitudeMid];
    node.northWest = [[VWWQuadTreeNode alloc]initWithBoundingBox:northWest capacity:node.bucketCapacity];

    VWWBoundingBox *northEast = [[VWWBoundingBox alloc]initWithX0:latitudeMid Y0:box.y0 XF:box.xf YF:longitudeMid];
    node.northEast = [[VWWQuadTreeNode alloc]initWithBoundingBox:northEast capacity:node.bucketCapacity];

    VWWBoundingBox *southWest = [[VWWBoundingBox alloc]initWithX0:box.x0 Y0:longitudeMid XF:latitudeMid YF:box.yf];
    node.southWest = [[VWWQuadTreeNode alloc]initWithBoundingBox:southWest capacity:node.bucketCapacity];

    VWWBoundingBox *southEast = [[VWWBoundingBox alloc]initWithX0:latitudeMid Y0:longitudeMid XF:box.xf YF:box.yf];
    node.southEast = [[VWWQuadTreeNode alloc]initWithBoundingBox:southEast capacity:node.bucketCapacity];

}

@end
