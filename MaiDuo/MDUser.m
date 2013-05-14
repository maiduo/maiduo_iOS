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

+(MDUser *)userWithJSON:(id)JSON
{
    NSInteger userID = [[JSON objectForKey:@"id"] intValue];
    NSString *username = [JSON objectForKey:@"username"];
    NSString *name = [JSON objectForKey:@"first_name"];
    
    MDUser *user = [[MDUser alloc] init];
    user.username = username;
    user.name = name;
    user.id = userID;
    
    return user;
}

+(NSArray *)usersWithJSON:(id)JSON
{
    NSArray *json = (NSArray *)JSON;
    NSInteger size = [json count];
    NSMutableArray *users = [NSMutableArray arrayWithCapacity:size];
    
    for (NSInteger i = 0; i < size; i++) {
        users[i] = [MDUser userWithJSON:[json objectAtIndex:i]];
    }
    
    return users;
}
@end
