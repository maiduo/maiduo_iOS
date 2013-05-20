//
//  MDNotificationCenter.m
//  MaiDuo
//
//  Created by 魏琮举 on 13-5-17.
//  Copyright (c) 2013年 魏琮举. All rights reserved.
//

#import "MDNotificationCenter.h"

@implementation MDNotificationCenter

-(id)init
{
    self = [super init];
    if (self) {
        _cache = [MDCache sharedInstance];
    }
    
    return self;
}

-(id)initNotificationCenterWithUser:(MDUser *)aUser
                           delegate:(id<MDNotificationCenterDelegate>)aDelegate
{
    self = [self init];
    if (self)
    {
        MDNotificationCenter *center = [[MDNotificationCenter alloc]init];
        center.delegate = aDelegate;
        center.user = aUser;
    }
    return self;
}

-(void)post:(NSDictionary *)userInfo
{
    NSString *type = [userInfo objectForKey:@"type"];
    MDActivity *activity;
    MDUser *user;
    NSInteger user_id;
    NSInteger chat_id;
    NSInteger activity_id;
    NSInteger message_id;
    NSString *chat_text;
    NSString *message_body;
    NSString *string_message_type;
    MessageType message_type;
    NSDictionary *aUserInfo;
    
    if ([@"message" isEqualToString:type]) {
        MDMessage *message;
        
        user_id = [[userInfo objectForKey:@"user_id"] intValue];
        activity_id = [[userInfo objectForKey:@"activity_id"] intValue];
        message_id = [[userInfo objectForKey:@"message_id"] intValue];
        message_body = [userInfo objectForKey:@"message_body"];
        string_message_type = [userInfo objectForKey:@"message_type"];
        
        activity = [_cache activity:activity_id];
        user = [_cache user:user_id];
        
        if ([@"T" isEqualToString: string_message_type]) {
            message_type = TextMessage;
        } else if ([@"V" isEqualToString: string_message_type]) {
            message_type = VideoMessage;
        } else {
            message_type = ImageMessage;
        }
        
        message = [MDMessage messageWithID:message_id
                                      body:message_body
                                  activity:activity
                                      user:user
                                      type:message_type];
        aUserInfo = [NSDictionary dictionaryWithObjectsAndKeys:message,
                     @"object", nil];
        [[NSNotificationCenter defaultCenter]
         postNotificationName:kDidReceiveMessage
         object:self
         userInfo:aUserInfo];
    }
    
    if ([@"activity" isEqualToString:type]) {
        
    }
    
    if ([@"chat" isEqualToString:type]) {
        MDChat *chat;
        
        user_id = [[userInfo objectForKey:@"user_id"] intValue];
        activity_id = [[userInfo objectForKey:@"activity_id"] intValue];
        chat_id = [[userInfo objectForKey:@"chat_id"] intValue];
        chat_text = [userInfo objectForKey:@"chat_text"];
        
        activity = [_cache activity:activity_id];
        user = [_cache user:user_id];
        
        chat = [MDChat chatWithID:chat_id
                             text:chat_text
                         activity:activity
                             user:user];
        
        aUserInfo = [NSDictionary dictionaryWithObjectsAndKeys:chat,
                     @"object", nil];
        
        [[NSNotificationCenter defaultCenter]
         postNotificationName:kDidReceiveChat
         object:self
         userInfo:aUserInfo];
    }
}

-(MDMessage *)messageWithPayload:(NSDictionary *)userInfo
{
    
}

+(MDNotificationCenter *)
notificationCenterWithUser:(MDUser *)aUser
delegate:(id<MDNotificationCenterDelegate>)aDelegate;
{
    return [[MDNotificationCenter alloc]
            initNotificationCenterWithUser:aUser
            delegate:aDelegate];
}

@end
