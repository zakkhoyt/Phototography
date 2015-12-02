//
//  ZHUserAnnotationView.h
//  Phototography
//
//  Created by Zakk Hoyt on 11/30/15.
//  Copyright © 2015 Zakk Hoyt. All rights reserved.
//

#import "VWWClusteredAnnotationView.h"
@class ZHUser;

@interface ZHUserAssetAnnotationView : VWWClusteredAnnotationView
@property (nonatomic, strong) ZHUser *user;
@property (assign, nonatomic) NSUInteger count;
@end
