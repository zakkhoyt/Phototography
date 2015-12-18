//
//  VWWSnapAnnotationCollectionViewCell.h
//  VWWClusteredMapView
//
//  Created by Zakk Hoyt on 3/28/15.
//  Copyright (c) 2015 Zakk Hoyt. All rights reserved.

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

static NSString *VWWSnapAnnotationCollectionViewCellKey = @"VWWSnapAnnotationCollectionViewCell";
@interface VWWSnapAnnotationCollectionViewCell : UICollectionViewCell
@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong) MKAnnotationView *annotationView;
@end
