//
//  YSelectedContact.m
//  MaiDuo
//
//  Created by 魏琮举 on 13-5-5.
//  Copyright (c) 2013年 魏琮举. All rights reserved.
//

#import "YPlainContact.h"

@implementation YPlainContact
@synthesize person;
@synthesize property;
@synthesize identifier;

-(id) initWithPerson:(RHPerson *)person
              property:(ABPropertyID)property
            identifier:(ABMultiValueIdentifier) identifier
{
    self = [super init];
    if (self) {
        self.person = person;
        self.property = property;
        self.identifier = identifier;
    }
    return self;
}
@end
