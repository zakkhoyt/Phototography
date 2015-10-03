//
//  NSURLRequest+AFCurlRequest.h
//  AFCurlRequest
//
//  Created by Alan Francis on 21/12/2012.
//  Copyright (c) 2012 Alan Francis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURLRequest (AFCurlRequest)
- (NSString*)af_curlRequest;
- (NSString*)af_curlRequestWithVerbose:(BOOL)verbose;
@end
