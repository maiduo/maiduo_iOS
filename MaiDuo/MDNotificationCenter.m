//
//  MDNotificationCenter.m
//  MaiDuo
//
//  Created by 魏琮举 on 13-5-17.
//  Copyright (c) 2013年 魏琮举. All rights reserved.
//

#import "MDNotificationCenter.h"

@implementation MDNotificationCenter
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

-(void)send:(NSDictionary *)userInfo
{
    NSString *type = [userInfo objectForKey:@"type"];
    if ([@"message" isEqualToString:type]) {
        MDMessage *message;
        [self.delegate didReceiveMessage:message];
    }
    
    if ([@"activity" isEqualToString:type]) {
        
    }
    
    if ([@"chat" isEqualToString:type]) {
        MDChat *chat;
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
