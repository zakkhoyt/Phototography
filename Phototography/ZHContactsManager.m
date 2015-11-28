//
//  ZHContactsManager.m
//  Phototography
//
//  Created by Zakk Hoyt on 11/27/15.
//  Copyright © 2015 Zakk Hoyt. All rights reserved.
//

#import "ZHContactsManager.h"
#import <Contacts/Contacts.h>


@interface ZHContactsManager ()
@property (nonatomic, strong) CNContactStore *contactStore;
@end

@implementation ZHContactsManager


- (instancetype)init {
    self = [super init];
    if (self) {
        self.contactStore = [[CNContactStore alloc]init];
        
        if([CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts] ==  CNAuthorizationStatusNotDetermined) {
            [self.contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
                
            }];
        }
    }
    return self;
}


-(void)getEmailContactsWithCompletionBlock:(ZHContactsManagerArrayErrorBlock)completionBlock{

//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@""];
    NSArray *keys = @[CNContactGivenNameKey, CNContactFamilyNameKey, CNContactEmailAddressesKey, CNContactBirthdayKey, CNContactImageDataKey];
    NSError *error;

    
    NSPredicate *predicate = [CNContact predicateForContactsMatchingName:@"Hoyt"];
    [[self.contactStore unifiedContactsMatchingPredicate:predicate keysToFetch:keys error:&error] enumerateObjectsUsingBlock:^(CNContact * _Nonnull contact, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"%lu: %@", (unsigned long)idx, contact.description);
    }];
    
}

@end
