//
//  VWWSnapAnnotationsCollectionViewLayout.m
//  VWWClusteredMapView
//
//  Created by Zakk Hoyt on 3/28/15.
//  Copyright (c) 2015 Zakk Hoyt. All rights reserved.

#import "VWWSnapAnnotationsCollectionViewLayout.h"


@interface VWWSnapAnnotationsCollectionViewLayout ()
@property (nonatomic, strong) NSArray *updateItems;
@property (nonatomic, strong) NSMutableArray *deleteIndexPaths;
@property (nonatomic, strong) NSMutableArray *insertIndexPaths;
@property (nonatomic, strong) NSMutableArray *moveIndexPaths;

@end



@implementation VWWSnapAnnotationsCollectionViewLayout
#pragma mark UICollectionViewLayout stuff

- (instancetype)init{
    self = [super init];
    if (self) {

    }
    return self;
}

-(void)prepareLayout{
    [super prepareLayout];
}

-(CGSize) collectionViewContentSize{
    return [self collectionView].frame.size;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return YES;
}

- (void)prepareForCollectionViewUpdates:(NSArray *)updateItems{

    // Keep track of insert and delete index paths
    [super prepareForCollectionViewUpdates:updateItems];
    
    UICollectionViewUpdateItem *item;
    if(updateItems.count){
        item = updateItems[0];
    }
    
    self.deleteIndexPaths = [NSMutableArray array];
    self.insertIndexPaths = [NSMutableArray array];
    
    for (UICollectionViewUpdateItem *update in updateItems) {
        if (update.updateAction == UICollectionUpdateActionDelete) {
            [self.deleteIndexPaths addObject:update.indexPathBeforeUpdate];
        } else if (update.updateAction == UICollectionUpdateActionInsert) {
            [self.insertIndexPaths addObject:update.indexPathAfterUpdate];
        }
    }
}

- (void)finalizeCollectionViewUpdates{
    [super finalizeCollectionViewUpdates];
    // release the insert and delete index paths
    self.deleteIndexPaths = nil;
    self.insertIndexPaths = nil;

}

-(NSArray*)layoutAttributesForElementsInRect:(CGRect)rect{
    NSMutableArray *attributes = [@[]mutableCopy];
    for(NSInteger s = 0; s < [self.collectionView numberOfSections]; s++){
        for(NSUInteger i = 0; i < [self.collectionView numberOfItemsInSection:s]; i++){
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:s];
            UICollectionViewLayoutAttributes *cellAttributes = [self layoutAttributesForItemAtIndexPath:indexPath];
            if(cellAttributes){
                [attributes addObject:cellAttributes];
            }
        }
    }
    
    return attributes;
}


-(UICollectionViewLayoutAttributes*)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    MKMapView *mapView = [self.delegate mapCollectionViewLayoutMapView:self];
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    CLLocationCoordinate2D coordinate = [self coordinateForIndexPath:indexPath];
    if(coordinate.latitude == 0 & coordinate.longitude == 0){
        NSLog(@"error");
    }

    CGPoint point = [mapView convertCoordinate:coordinate toPointToView:mapView];
    if(CGPointEqualToPoint(CGPointZero, point)){
        NSLog(@"error");
    }

    [self isPointWithinBounds:point indexPath:indexPath completionBlock:^(BOOL withinLayout, CGPoint point, CGAffineTransform transform) {
        attributes.size = [self.delegate mapCollectionViewLayout:self sizeForIndexPath:indexPath];
        attributes.center = point;
        attributes.alpha = 1.0;
        attributes.zIndex = 2;
        attributes.transform = transform;
        if(withinLayout == YES){
            attributes.hidden = YES;
            if([self.delegate mapCollectionViewLayout:self keepIndexPathOnMap:indexPath]){
                attributes.zIndex = 99;
            } else {
                attributes.zIndex = 100;
            }
        } else {
            attributes.hidden = NO;
        }
    }];
    
    return attributes;
}

-(UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)indexPath{
    // Must call super
    UICollectionViewLayoutAttributes *attributes = [super initialLayoutAttributesForAppearingItemAtIndexPath:indexPath];
    // only change attributes on inserted cells
    if ([self.insertIndexPaths containsObject:indexPath]) {
        if (attributes == nil){
            attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
        }
//        MKMapView *mapView = [self.delegate mapCollectionViewLayoutMapView:self];
//        CGPoint point = [mapView convertCoordinate:[self.delegate mapCollectionViewLayout:self initialCoordinateForIndexPath:indexPath] toPointToView:mapView];
//        attributes.center = point;
//        attributes.alpha = 0.5;
        attributes.alpha = 0.0;
    }
    return attributes;
}
-(UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath*)indexPath{
    UICollectionViewLayoutAttributes *attributes = [super finalLayoutAttributesForDisappearingItemAtIndexPath:indexPath];
    // only change attributes on deleted cells
    if ([self.deleteIndexPaths containsObject:indexPath]) {
        if (!attributes){
            attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
        }
//        MKMapView *mapView = [self.delegate mapCollectionViewLayoutMapView:self];
//        CGPoint point = [mapView convertCoordinate:[self.delegate mapCollectionViewLayout:self finalCoordinateForIndexPath:indexPath] toPointToView:mapView];
//        attributes.center = point;
//        attributes.alpha = 0.5;
        attributes.alpha = 0.0;
    }
    return attributes;
}

#pragma mark Private custom methods

-(CLLocationCoordinate2D)coordinateForIndexPath:(NSIndexPath*)indexPath{
    CLLocationCoordinate2D coordinate = [self.delegate mapCollectionViewLayout:self coordinateForIndexPath:indexPath];
    return coordinate;
}

-(void)isPointWithinBounds:(CGPoint)point
                 indexPath:(NSIndexPath*)indexPath
           completionBlock:(SnapBoolPointTransformBlock)completionBlock{
    
    BOOL withinLayout = YES;
    // We will use this to render decorations when an annotation is off of the screen
    UIEdgeInsets contentInset = [self.delegate mapCollectionViewContentInset:self];
    MKMapView *mapView = [self.delegate mapCollectionViewLayoutMapView:self];
    
    
    if(point.x < contentInset.left){
        point.x = contentInset.left;
        withinLayout = NO;
    }
    if(point.x >= mapView.frame.size.width - contentInset.right){
        point.x = mapView.frame.size.width - contentInset.right;
        withinLayout = NO;
    }
    if(point.y < contentInset.top){
        point.y = contentInset.top;
        withinLayout = NO;
    }
    if(point.y >= mapView.frame.size.height - contentInset.bottom){
        point.y = mapView.frame.size.height - contentInset.bottom;
        withinLayout = NO;
    }
    
    // Calculate the angle which to rotate the cell
    CGPoint center = mapView.center;
    float angle = ((atan2((point.x - center.x) , -(point.y - center.y))));
    angle -= M_PI / 2.0;
    
//    float angleVal = (((atan2((point.x - center.x) , (point.y - center.y)))*180)/M_PI);
//    NSLog(@"Angle %.0f", angleVal);
    
    CGAffineTransform transform = CGAffineTransformMakeRotation(angle);
//    CGAffineTransform transform = CGAffineTransformIdentity;
    completionBlock(withinLayout, point, transform);
}

@end
