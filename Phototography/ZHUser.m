//
//  ZHUser.m
//  Phototography
//
//  Created by Zakk Hoyt on 11/26/15.
//  Copyright © 2015 Zakk Hoyt. All rights reserved.
//

#import "ZHUser.h"

@implementation ZHUser
- (instancetype)initWithRecord:(CKRecord*)record database:(CKDatabase*)database {
    self = [super init];
    if (self) {
        self.firstName = [record objectForKey:@"FirstName"];
        self.lastName = [record objectForKey:@"LastName"];
        self.email = [record objectForKey:@"Email"];
        self.phone = [record objectForKey:@"Phone"];
        self.uuid = [record objectForKey:@"uuid"];
        self.friends = [record objectForKey:@"Friends"];
    }
    return self;
}
@end
