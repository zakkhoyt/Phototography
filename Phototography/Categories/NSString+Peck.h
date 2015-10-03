//
//  NSString+Peck.h
//  Peck
//
//  Created by Zakk Hoyt on 5/4/15.
//  Copyright (c) 2015 Zakk Hoyt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Peck)
-(NSString*)paddedString;
-(NSString*)padWithSpaces:(NSUInteger)count;
@end
