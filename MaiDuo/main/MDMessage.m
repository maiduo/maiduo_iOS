//
//  Activity.m
//  MaiDuo
//
//  Created by 魏琮举 on 13-4-20.
//  Copyright (c) 2013年 魏琮举. All rights reserved.
//

#import "MDMessage.h"

@implementation MDMessage

-(NSMutableDictionary *)dictionaryValue
{
    return nil;
}

-(NSDictionary *)dictionaryForAPIWithAccessToken:(NSString *)token
{
    
}

+(MDMessage *)messageWithJSON:(id)JSON
{
    
}

+(NSArray *)messagesWithJSON:(id)JSON
{
    
}

+(MDMessage *)messageWithBody:(NSString *)body
{
    MDMessage *message = [[MDMessage alloc] init];
    message.body = body;
    message.type = TextMessage;
    
    return message;
}
@end
