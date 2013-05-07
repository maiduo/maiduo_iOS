//
//  YSelectedContact.h
//  MaiDuo
//
//  Created by 魏琮举 on 13-5-5.
//  Copyright (c) 2013年 魏琮举. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RHAddressBook/AddressBook.h>

@interface YPlainContact : NSObject
@property (nonatomic,strong) RHPerson *person;
@property (nonatomic,assign) ABPropertyID property;
@property (nonatomic,assign) ABMultiValueIdentifier identifier;

-(id) initWithPerson:(RHPerson *)person
              property:(ABPropertyID)property
            identifier:(ABMultiValueIdentifier) identifier;
@end
