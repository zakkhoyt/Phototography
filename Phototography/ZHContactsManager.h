//
//  ZHContactsManager.h
//  Phototography
//
//  Created by Zakk Hoyt on 11/27/15.
//  Copyright © 2015 Zakk Hoyt. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ZHContactsManagerArrayErrorBlock)(NSArray *, NSError *error);

@interface ZHContactsManager : NSObject
-(void)getEmailContactsWithCompletionBlock:(ZHContactsManagerArrayErrorBlock)completionBlock;
@end
