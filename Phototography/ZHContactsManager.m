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

////    NSPredicate *predicate = [NSPredicate predicateWithFormat:@""];
////    NSArray *keys = @[CNContactGivenNameKey, CNContactFamilyNameKey, CNContactEmailAddressesKey, CNContactBirthdayKey, CNContactImageDataKey];
//        NSArray *keys = @[CNContactGivenNameKey, CNContactFamilyNameKey];
//    NSError *error;
//
//    
//    NSPredicate *predicate = [CNContact predicateForContactsMatchingName:@".com"];
////    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"emailAddresses.count > 0"];
//    NSArray<CNContact*> *contacts = [self.contactStore unifiedContactsMatchingPredicate:predicate keysToFetch:keys error:&error];
//    if(contacts.count > 0){
//        [contacts enumerateObjectsUsingBlock:^(CNContact * _Nonnull contact, NSUInteger idx, BOOL * _Nonnull stop) {
//            NSLog(@"%lu: %@", (unsigned long)idx, contact.description);
//        }];
//        
//    } else {
//        NSLog(@"0 contacts found");
//    }
    
    NSArray *keys = @[CNContactGivenNameKey, CNContactFamilyNameKey, CNContactEmailAddressesKey, CNContactBirthdayKey, CNContactImageDataKey];
    CNContactFetchRequest *fetchRequest = [[CNContactFetchRequest alloc]initWithKeysToFetch:keys];
    NSError *error;
    NSMutableArray *contacts = [[NSMutableArray alloc]init];
    [self.contactStore enumerateContactsWithFetchRequest:fetchRequest error:&error usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
        if(contact.emailAddresses.count > 0) {
            [contacts addObject:contact];
        }
    }];
    
    if(error != nil) {
        completionBlock(nil, error);
    } else {
        completionBlock(contacts, nil);
    }
}

@end
