//
//  VWWQuadTree.h
//  VWWClusteredMapView
//
//  Created by Zakk Hoyt on 3/28/15.
//  Copyright (c) 2015 Zakk Hoyt. All rights reserved.

#import <Foundation/Foundation.h>
@import MapKit;

@interface VWWQuadTreeNodeData : NSObject
-(instancetype)initWithAnotation:(id<MKAnnotation>) annotation;
@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong) NSObject *data;
@end

@interface VWWBoundingBox : NSObject
@property (nonatomic) CLLocationDegrees x0;
@property (nonatomic) CLLocationDegrees y0;
@property (nonatomic) CLLocationDegrees xf;
@property (nonatomic) CLLocationDegrees yf;
-(instancetype)initWithX0:(CLLocationDegrees)x0 Y0:(CLLocationDegrees)y0 XF:(CLLocationDegrees)xf YF:(CLLocationDegrees)yf;
+(VWWBoundingBox*)boundingBoxForWorld;
@end

@interface VWWQuadTreeNode : NSObject
@property (nonatomic, strong) VWWQuadTreeNode *northWest;
@property (nonatomic, strong) VWWQuadTreeNode *northEast;
@property (nonatomic, strong) VWWQuadTreeNode *southWest;
@property (nonatomic, strong) VWWQuadTreeNode *southEast;
@property (nonatomic, strong) VWWBoundingBox *boundingBox;
@property (nonatomic) NSInteger bucketCapacity;
@property (nonatomic, strong) NSMutableArray *points; // Contains VWWQuadTreeNodeData*
@property (nonatomic) NSInteger count;
-(instancetype)initWithBoundingBox:(VWWBoundingBox*)boundingBox capacity:(NSInteger)capacity;
@end

typedef void(^VWWQuadTreeTraverseBlock)(VWWQuadTreeNode* currentNode);
typedef void(^VWWDataReturnBlock)(VWWQuadTreeNodeData* data);

@interface VWWQuadTree : NSObject
+(void)freeQuadTreeNode:(VWWQuadTreeNode*)node;
+(BOOL)boundingBox:(VWWBoundingBox*)box containsData:(VWWQuadTreeNodeData*)data;
+(BOOL)boundingBox:(VWWBoundingBox*)box1 intersectsBoundingBox:(VWWBoundingBox*)box2;
+(void)quadTreeTraverse:(VWWQuadTreeNode*)node block:(VWWQuadTreeTraverseBlock)block;
+(void)quadTree:(VWWQuadTreeNode*)node gatherDataInRange:(VWWBoundingBox*)range block:(VWWDataReturnBlock)block;
+(BOOL)quadTree:(VWWQuadTreeNode*)node insertData:(VWWQuadTreeNodeData*)data;
+(VWWQuadTreeNode*)quadTreeBuildWithData:(NSArray*)data count:(NSInteger)count boundingBox:(VWWBoundingBox*)boundingBox capacity:(NSInteger)capacity;

@end