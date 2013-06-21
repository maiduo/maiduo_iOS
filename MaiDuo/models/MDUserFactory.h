//
//  MDUserFactory.h
//  MaiDuo
//
//  Created by Indvane Mini on 13-6-21.
//  Copyright (c) 2013年 魏琮举. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MDUser.h"

@interface MDUserFactory : NSObject

- (MDUser *)userWithDictionary:(NSDictionary *)aDictionary;

@end
