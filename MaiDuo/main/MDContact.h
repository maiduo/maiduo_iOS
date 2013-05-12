//
//  Address.h
//  MaiDuo
//
//  Created by 魏琮举 on 13-4-21.
//  Copyright (c) 2013年 魏琮举. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MDItem.h"

@interface MDContact : MDItem

@property (nonatomic, strong) NSString* firstName;
@property (nonatomic, strong) NSString* lastName;
@property (nonatomic, strong) NSString* middleName;
@property (nonatomic, strong) NSArray* phones;

- (id)initWithFirstName:(NSString *)_firstName
               lastName:(NSString *)_lastName
             middleName:(NSString *)_middleName
                 phones:(NSArray  *)_phones;
@end
