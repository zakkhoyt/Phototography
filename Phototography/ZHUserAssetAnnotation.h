//
//  ZHUserAssetAnnotation.h
//  Phototography
//
//  Created by Zakk Hoyt on 12/1/15.
//  Copyright © 2015 Zakk Hoyt. All rights reserved.
//

@import MapKit;
@class PHAsset;
@class ZHUser;

@interface ZHUserAssetAnnotation : NSObject <MKAnnotation>
-(instancetype)initWithAsset:(PHAsset*)asset userUUID:(NSString*)userUUID;

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly, copy) NSString *title;
@property (nonatomic, readonly, copy) NSString *subtitle;

@property (nonatomic, strong, readonly) PHAsset *asset;
@property (nonatomic, strong, readonly) NSString *userUUID;
@end
