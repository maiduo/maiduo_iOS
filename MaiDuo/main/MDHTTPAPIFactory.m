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

@end
