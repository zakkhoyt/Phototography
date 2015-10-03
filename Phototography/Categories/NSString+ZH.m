//
//  NSString+ZH.m
//  ZH
//
//  Created by Zakk Hoyt on 5/4/15.
//  Copyright (c) 2015 Zakk Hoyt. All rights reserved.
//

#import "NSString+ZH.h"

@implementation NSString (ZH)
-(NSString*)paddedString{
//    return [NSString stringWithFormat:@"  %@  ", self];
        return [NSString stringWithFormat:@"\t%@\t", self];
}

-(NSString*)padWithSpaces:(NSUInteger)count{
    NSMutableString *pad = [NSMutableString new];
    for(NSUInteger index = 0; index < count; index++){
        [pad appendString:@" "];
    }
    
    return [NSString stringWithFormat:@"%@%@%@", pad, self, pad];
}
@end
