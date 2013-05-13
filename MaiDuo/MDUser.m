//
//  MDUser.m
//  MaiDuo
//
//  Created by 魏琮举 on 13-5-10.
//  Copyright (c) 2013年 魏琮举. All rights reserved.
//

#import "MDUser.h"

@implementation MDUser

-(id)initWithUsername:(NSString *)username password:(NSString *)password
{
    self = [self init];
    if (self) {
        self.username = username;
        self.password = password;
    }
    
    return self;
}
@end
