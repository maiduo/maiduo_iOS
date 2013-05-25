//
//  MDUser.m
//  MaiDuo
//
//  Created by 魏琮举 on 13-5-10.
//  Copyright (c) 2013年 魏琮举. All rights reserved.
//

#import "MDUser.h"

@implementation MDUser

-(id) init
{
    self = [super init];
    if (self) {
        self.isActive = YES;
    }
    
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    MDUser *user = [[MDUser alloc] init];
    user.userId = _userId;
    user.username = _username;
    user.phone = _phone;
    user.password = _password;
    user.name = _name;
    user.isActive = _isActive;
    user.avatar = _avatar;
    user.deviceToken = _deviceToken;
    user.accessToken = _accessToken;
    user.refreshToken = _refreshToken;
    return user;
}

-(id)initWithUsername:(NSString *)anUsername password:(NSString *)aPassword
{
    self = [self init];
    if (self) {
        self.username = anUsername;
        self.password = aPassword;
        
        self.isActive = YES;
    }
    
    return self;
}

-(NSDictionary *)dictionaryValue
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            [NSString stringWithFormat:@"%d", self.userId], @"id",
            self.username, @"username",
            self.accessToken, @"accessToken",
            self.deviceToken, @"deviceToken",
            self.name, @"first_name", nil];
}

-(BOOL)equal:(MDUser *)aUser
{
    if(self.userId == aUser.userId)
        return YES;
    else
        return NO;
}

+(MDUser *)userWithDictionary:(NSDictionary *)aDictionary
{
    MDUser *user = [[MDUser alloc]init];
    if (nil != [aDictionary objectForKey:@"id"]) {
        user.userId = [[aDictionary objectForKey:@"id"] intValue];
    }
    user.username = [aDictionary objectForKey:@"username"];
    user.accessToken = [aDictionary objectForKey:@"accessToken"];
    user.deviceToken = [aDictionary objectForKey:@"deviceToken"];
    user.name = [aDictionary objectForKey:@"first_name"];
    
    return user;
}

+(MDUser *)userWithInvite:(NSString *)anUsername name:(NSString *)aName
{
    MDUser *user = [[MDUser alloc] init];
    user.username = anUsername;
    user.name = aName;
    user.isActive = NO;
    return user;
}

+(MDUser *)userWithRHPerson:(RHPerson *)aPerson
                   property:(ABPropertyID)property
                 identifier:(ABMultiValueIdentifier)identifier
{
    NSString *mobile = [[aPerson getMultiValueForPropertyID:property]
                        valueAtIndex:identifier];
    
    mobile = [[[[mobile stringByReplacingOccurrencesOfString:@")" withString:@""]
              stringByReplacingOccurrencesOfString:@"(" withString:@""]
              stringByReplacingOccurrencesOfString:@"-" withString:@""]
              stringByReplacingOccurrencesOfString:@" " withString:@""];
    return [MDUser userWithInvite:mobile name:[aPerson getFullName]];
}

+(MDUser *)userWithJSON:(id)JSON
{
    NSInteger userID = [[JSON objectForKey:@"id"] intValue];
    NSString *username = [JSON objectForKey:@"username"];
    NSString *name = [JSON objectForKey:@"first_name"];
    
    MDUser *user = [[MDUser alloc] init];
    user.username = username;
    user.name = name;
    user.userId = userID;
    user.avatar = [JSON objectForKey:@"avatar"];
    
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
