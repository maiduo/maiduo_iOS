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

-(NSDictionary *)dictionaryWithDictionary:(NSDictionary *)aDictionary
{
    NSMutableDictionary *dictionary = [NSMutableDictionary
                                       dictionaryWithDictionary: aDictionary];
    [dictionary setObject:self.accessToken forKey:@"access_token"];
    [dictionary setObject:self.service forKey:@"service"];
    
    return dictionary;
}

-(NSDictionary *)dictionaryForPostWithActivity:(MDActivity *)anActivity
{
    NSMutableDictionary *dictionary;
    dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                  anActivity.subject, @"subject",
                  [anActivity.invitation componentsJoinedByString:@","],
                  @"invitation",
                  nil];
    
    return [self dictionaryWithDictionary:[anActivity dictionaryValue]];
}

-(NSDictionary *)dictionaryWithMessage:(MDMessage *)aMessage
{
    return [self dictionaryWithDictionary:[aMessage dictionaryValue]];
}

-(NSDictionary *)dictionaryWithChat:(MDChat *)aChat
{
    return [self dictionaryWithDictionary:[aChat dictionaryValue]];
}

@end
