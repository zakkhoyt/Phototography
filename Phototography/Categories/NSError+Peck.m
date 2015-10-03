//
//  NSError+Peck.m
//  Peck
//
//  Created by Zakk Hoyt on 4/27/15.
//  Copyright (c) 2015 Zakk Hoyt. All rights reserved.
//

#import "NSError+Peck.h"

@implementation NSError (Peck)
+(NSError*)peckError{
    return [NSError peckErrorWithCode:NSErrorPeckCodeGeneral];
}
+(NSError*)peckErrorWithCode:(NSErrorPeckCode)code{
    return [NSError peckErrorWithCode:code userInfo:nil];
}
+(NSError*)peckErrorWithCode:(NSErrorPeckCode)code userInfo:(NSDictionary*)userInfo{
    return [NSError errorWithDomain:NSErrorPeckDomain code:code userInfo:userInfo];
}
+(NSError*)peckErrorWithCode:(NSErrorPeckCode)code localizedFailureReason:(NSString*)localizedFailureReason{
    return [NSError peckErrorWithCode:code userInfo:@{NSLocalizedDescriptionKey: localizedFailureReason}];
}

+(NSString*)stringFromCode:(NSErrorPeckCode)code{
    switch (code){
        case NSErrorPeckCodeGeneral:
            return @"General error";
        case NSErrorPeckCodeUserCancelled:
            return @"User cancelled";
        case NSErrorPeckCodeInvalidSelection:
            return @"Invalid selection";
        case NSErrorPeckCodeStackShareFailed:
            return @"Share failed";
        case NSErrorPeckCodeNotImplemented:
            return @"Funcionality not implemented (TODO)";
            default:
            return @"Unknown";
            

    }
}
@end
