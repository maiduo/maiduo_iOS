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

-(id)initWithUsername:(NSString *)anUsername
                 name:(NSString *)aName
             password:(NSString *)aPassword
{
    self = [self initWithUsername:anUsername password:aPassword];
    self.name = aName;
    
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

- (NSString *)avatar
{
    return [self avatarWithSize:SMALL_AVATAR];
}

- (NSString *)avatarWithSize:(AvatarSize)size
{
    NSString *aSize;
    switch (size) {
        case SMALL_AVATAR:
            aSize = @"100";
            break;
        case MIDDLE_AVATAR:
            aSize = @"200";
            break;
        case BIG_AVATAR:
            aSize = @"400";
            break;
            
        default:
            break;
    }
//    static NSString *noformat = @"http://himaiduo.com/media/user/avatar/%d/%d_%@.jpg";
    NSString *noformat;
    noformat = @"http://maiduo-test.qiniudn.com/%d/%d.jpg?imageView/2/w/%@/h/%@";
    
    NSString *avatarURL = [NSString stringWithFormat:noformat,
                           self.userId % 1000, self.userId, aSize, aSize];
    return avatarURL;
}

- (BOOL)isValid
{
    BOOL valid = YES;
    valid = self != nil;
    valid = self.userId > 0;
    
    return valid;
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



+(MDUser *)userWithJSON:(id)JSON
{
    NSInteger userID = [[JSON objectForKey:@"id"] intValue];
    NSString *username = [JSON objectForKey:@"username"];
    NSString *name = [JSON objectForKey:@"first_name"];
    
    MDUser *user = [[MDUser alloc] init];
    user.username = username;
    user.name = name;
    user.userId = userID;
    
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
