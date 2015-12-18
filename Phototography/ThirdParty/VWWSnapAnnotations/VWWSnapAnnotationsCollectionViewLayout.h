//
//  VWWSnapAnnotationsCollectionViewLayout.h
//  VWWClusteredMapView
//
//  Created by Zakk Hoyt on 3/28/15.
//  Copyright (c) 2015 Zakk Hoyt. All rights reserved.

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>


@class VWWSnapAnnotationsCollectionViewLayout;

typedef void (^SnapBoolPointTransformBlock)(BOOL success, CGPoint point, CGAffineTransform transform);

@protocol VWWSnapAnnotationsCollectionViewLayoutDelegate <NSObject>
-(CGSize)mapCollectionViewLayout:(VWWSnapAnnotationsCollectionViewLayout*)sender sizeForIndexPath:(NSIndexPath*)indexPath;
-(CLLocationCoordinate2D)mapCollectionViewLayout:(VWWSnapAnnotationsCollectionViewLayout*)sender coordinateForIndexPath:(NSIndexPath*)indexPath;
-(MKMapView*)mapCollectionViewLayoutMapView:(VWWSnapAnnotationsCollectionViewLayout*)sender;
-(UIEdgeInsets)mapCollectionViewContentInset:(VWWSnapAnnotationsCollectionViewLayout*)sender;
-(CGRect)mapCollectionViewRectForVisibleCells:(VWWSnapAnnotationsCollectionViewLayout*)sender;
-(BOOL)mapCollectionViewLayout:(VWWSnapAnnotationsCollectionViewLayout*)sender keepIndexPathOnMap:(NSIndexPath*)indexPath;
@end




@interface VWWSnapAnnotationsCollectionViewLayout : UICollectionViewLayout
@property (nonatomic, weak) id <VWWSnapAnnotationsCollectionViewLayoutDelegate> delegate;
//@property (nonatomic) BOOL keepAnnotationsOnMap;
//@property (nonatomic) BOOL busy;
//-(void)isPointWithinBounds:(CGPoint)point
//                 indexPath:(NSIndexPath*)indexPath
//           completionBlock:(SMBoolPointBlock)completionBlock;

@end
