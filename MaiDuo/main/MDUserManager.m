//
//  MDUserManager.m
//  MaiDuo
//
//  Created by WangPeng on 5/12/13.
//  Copyright (c) 2013 魏琮举. All rights reserved.
//

#import "MDUserManager.h"

@implementation MDUserManager

- (BOOL)userSessionValid
{
    return _user != nil;
}

+ (MDUserManager *)sharedInstance
{
    static id _instance = nil;
    if (!_instance) {
        _instance = [[MDUserManager alloc] init];
    }
    return _instance;
}

@end
