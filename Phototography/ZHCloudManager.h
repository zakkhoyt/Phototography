//
//  ZHCloudManager.h
//  Phototography
//
//  Created by Zakk Hoyt on 11/26/15.
//  Copyright © 2015 Zakk Hoyt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CloudKit/CloudKit.h>
#import "ZHUser.h"

typedef void (^ZHCloudManagerArrayErrorBlock)(NSArray *, NSError *error);
typedef void (^ZHCloudManagerErrorBlock)(NSError *error);

@interface ZHCloudManager : NSObject

-(void)createUser:(ZHUser*)user completionBlock:(ZHCloudManagerErrorBlock)completionBlock;
-(void)getFriendsWithCompletionBlock:(ZHCloudManagerArrayErrorBlock)completionBlock;


@end
