//
//  NSError+Peck.h
//  Peck
//
//  Created by Zakk Hoyt on 4/27/15.
//  Copyright (c) 2015 Zakk Hoyt. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *NSErrorPeckDomain = @"Peck";

typedef enum  {
    NSErrorPeckCodeGeneral = -10001,
    NSErrorPeckCodeUserCancelled = -10002,
    NSErrorPeckCodeInvalidSelection = -10003,
    NSErrorPeckCodeStackShareFailed = -10004,
    NSErrorPeckCodeAssetUploadFailed = -10005,
    
    NSErrorPeckCodeContactAccess = -11000,
    
    NSErrorPeckCodeAuthenticaion = -12000,
    
    NSErrorPeckCodePreviouslyUploaded = 0x1000,
    NSErrorPeckCodeError = 0xFFFF,
    NSErrorPeckCodeNotImplemented = -20000,
} NSErrorPeckCode;


@interface NSError (Peck)

+(NSError*)peckError;
+(NSError*)peckErrorWithCode:(NSErrorPeckCode)code;
+(NSError*)peckErrorWithCode:(NSErrorPeckCode)code localizedFailureReason:(NSString*)localizedFailureReason;
+(NSError*)peckErrorWithCode:(NSErrorPeckCode)code userInfo:(NSDictionary*)userInfo;




@end
