//
//  ZHLocationUpdate.m
//  Phototography
//
//  Created by Zakk Hoyt on 11/28/15.
//  Copyright © 2015 Zakk Hoyt. All rights reserved.
//

#import "ZHLocationUpdate.h"

@interface ZHLocationUpdate ()

@end



@implementation ZHLocationUpdate


@end

@implementation ZHLocationUpdate (NSSecureCoding)

+ (BOOL)supportsSecureCoding{
    return YES;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.location forKey:@"location"];
    [aCoder encodeObject:self.date forKey:@"date"];
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if(self){
        self.location = [aDecoder decodeObjectForKey:@"location"];
        self.date = [aDecoder decodeObjectForKey:@"date"];
    }
    return self;
}


@end