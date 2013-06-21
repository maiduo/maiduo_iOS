//
//  MDUserFactory.m
//  MaiDuo
//
//  Created by Indvane Mini on 13-6-21.
//  Copyright (c) 2013年 魏琮举. All rights reserved.
//

#import "MDUserFactory.h"

@implementation MDUserFactory

- (MDUser *)userWithDictionary:(NSDictionary *)aDictionary
{
    MDUser *user = [[MDUser alloc] init];
    if (nil != [aDictionary objectForKey:@"id"]) {
        user.userId = [[aDictionary objectForKey:@"id"] intValue];
    }
    user.username = [aDictionary objectForKey:@"username"];
    user.accessToken = [aDictionary objectForKey:@"accessToken"];
    user.deviceToken = [aDictionary objectForKey:@"deviceToken"];
    user.name = [aDictionary objectForKey:@"first_name"];
    
    return user;
}

@end
