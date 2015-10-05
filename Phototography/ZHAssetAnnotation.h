//
//  ZHAssetAnnotation.h
//  Peck
//
//  Created by Zakk Hoyt on 10/4/15.
//  Copyright © 2015 Zakk Hoyt. All rights reserved.
//

@import MapKit;
@class PHAsset;

@interface ZHAssetAnnotation : NSObject <MKAnnotation>
-(instancetype)initWithAsset:(PHAsset*)asset;

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly, copy) NSString *title;
@property (nonatomic, readonly, copy) NSString *subtitle;

@property (nonatomic, strong, readonly) PHAsset *asset;

@end
