//
//  MDHTTPAPIFactory.m
//  MaiDuo
//
//  Created by 魏琮举 on 13-5-16.
//  Copyright (c) 2013年 魏琮举. All rights reserved.
//

#import "MDHTTPAPIFactory.h"

@implementation MDHTTPAPIFactory

+(MDHTTPAPIFactory *)factoryWithAccessToken:(NSString *)anAccessToken
                                    service:(NSString *)aService
{
    MDHTTPAPIFactory *factory = [[MDHTTPAPIFactory alloc] init];
    factory.accessToken = anAccessToken;
    factory.service = aService;
    
    return factory;
}

-(NSDictionary *)dictionaryWithDictionary:(NSMutableDictionary *)aDictionary
{
    [aDictionary setObject:self.accessToken forKey:@"access_token"];
    [aDictionary setObject:self.service forKey:@"service"];
    
    return aDictionary;
}

-(NSDictionary *)dictionaryForAccessToken
{
    return [self dictionaryWithDictionary:[NSMutableDictionary dictionary]];
}

-(NSDictionary *)dictionaryForCreateActivity:(MDActivity *)anActivity
{
    NSMutableDictionary *dictionary;
    dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                  anActivity.subject, @"subject",
                  [anActivity.invitation componentsJoinedByString:@","],
                  @"invitation",
                  nil];
    
    return [self dictionaryWithDictionary:dictionary];
}

-(NSDictionary *)dictionaryForDeleteActivity:(MDActivity *)anActivity
{
    NSMutableDictionary *dictionary;
    dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                  [NSString stringWithFormat:@"%d", anActivity.id], @"activity_id",
                  nil];
    
    return [self dictionaryWithDictionary:dictionary];
}

-(NSDictionary *)dictionaryForInvite:(MDActivity *)anActivity
                                user:(MDUser *)anUser
{
    NSString *activity_id = [NSString stringWithFormat:@"%d", anActivity.id];
    NSMutableDictionary *dictionary;
    dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                  activity_id, @"activity_id", anUser.username, @"username",
                  anUser.name, @"name", nil];
    
    return [self dictionaryWithDictionary:dictionary];
}

-(NSDictionary *)dictionaryForUploadAvatar
{
    return [self dictionaryWithDictionary:[NSMutableDictionary dictionary]];
}

-(NSDictionary *)dictionaryForSendMessage:(MDMessage *)aMessage
{
    NSMutableDictionary *dictionary;
    NSString *activity_id;
    activity_id = [NSString stringWithFormat:@"%d", aMessage.activity.id];
    dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                  activity_id, @"activity_id",
                  aMessage.body, @"body", nil];
    return [self dictionaryWithDictionary:dictionary];
}

-(NSDictionary *)dictionaryForUpdateStashOfMessage:(MDMessage *)aMessage
{
    NSMutableDictionary *dictionary;
    NSString *stash;
    if (aMessage.stash)
        stash = @"1";
    else
        stash = @"0";
    dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                  [NSString stringWithFormat:@"%d", aMessage.id], @"message_id",
                  stash, @"stash", nil];
    return [self dictionaryWithDictionary:dictionary];
}

-(NSDictionary *)dictionaryForSendChat:(MDChat *)aChat
{
    NSMutableDictionary *dictionary;
    NSString *activity_id;
    activity_id = [NSString stringWithFormat:@"%d", aChat.activity.id];
    dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                  aChat.text, @"text",
                  activity_id, @"activity_id", nil];
    return [self dictionaryWithDictionary:dictionary];
}

-(NSDictionary *)dictionaryForMessagesWithActivity:(MDActivity *)anActivity
                                              page:(NSInteger)aPage
{
    NSMutableDictionary *dictionary;
    NSString *activity_id;
    activity_id = [NSString stringWithFormat:@"%d", anActivity.id];
    dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                  activity_id, @"activity_id",
                  [NSString stringWithFormat:@"%d", aPage], @"page", nil];
    
    return [self dictionaryWithDictionary:dictionary];
}

-(NSDictionary *)dictionaryForChatsWithActivity:(MDActivity *)anActivity
                                           page:(NSInteger)aPage
                                       pageSize:(NSInteger)aPageSize;
{
    NSMutableDictionary *dictionary;
    NSString *activity_id;
    activity_id = [NSString stringWithFormat:@"%d", anActivity.id];
    dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                  activity_id, @"activity_id",
                  [NSString stringWithFormat:@"%d", aPage], @"page",
                  [NSString stringWithFormat:@"%d", aPageSize], @"page_size",
                  nil];
    
    return [self dictionaryWithDictionary:dictionary];
}

-(NSDictionary *)dictionaryForChatsWithActivity:(MDActivity *)anActivity
                                           page:(NSInteger)aPage
{
    return [self dictionaryForChatsWithActivity:anActivity
                                           page:aPage
                                       pageSize:0];
}

-(NSDictionary *)dictionaryForLogoutWithUser:(MDUser *)user
{
    NSMutableArray *dictionary;
//    dictionary = [NSMutableDictionary diction]
}

@end
