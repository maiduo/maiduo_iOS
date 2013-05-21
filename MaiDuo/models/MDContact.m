//
//  Address.m
//  MaiDuo
//
//  Created by 魏琮举 on 13-4-21.
//  Copyright (c) 2013年 魏琮举. All rights reserved.
//

#import "MDContact.h"

@implementation MDContact

@synthesize firstName;
@synthesize middleName;
@synthesize lastName;
@synthesize phones;

- (id)initWithFirstName:(NSString *)_firstName
               lastName:(NSString *)_lastName
             middleName:(NSString *)_middleName
                 phones:(NSArray  *)_phones
{
    self = [self init];
    if (self) {
        self.firstName = _firstName;
        self.lastName  = _lastName;
        self.middleName = _middleName;
        self.phones    = _phones;
    }
    
    return self;
}
@end
