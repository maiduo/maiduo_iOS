//
//  MDUserAssembly.h
//  MaiDuo
//
//  Created by Indvane Mini on 13-6-21.
//  Copyright (c) 2013年 魏琮举. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RHAddressBook/RHAddressBook.h>
#import "RHPerson+RHPersonCategory.h"
#import "MDUser.h"

/** 从RHPerson对象装配User对象
 * 
 * Objective-C++代码影响xCode的重构功能，所以单独放在一个装配器里面
 */
@interface MDUserAssembler : NSObject
-(MDUser *)userWithRHPerson:(RHPerson *)aPerson
                   property:(ABPropertyID)property
                 identifier:(ABMultiValueIdentifier)identifier;
@end
