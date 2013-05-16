//
//  Activity.m
//  MaiDuo
//
//  Created by 魏琮举 on 13-4-20.
//  Copyright (c) 2013年 魏琮举. All rights reserved.
//

#import "MDMessage.h"

@implementation MDMessage

+(MDMessage *)messageWithJSON:(id)JSON
{
    NSInteger messageID = [[JSON objectForKey:@"id"] intValue];
    MDUser *aUser = [MDUser userWithJSON:[JSON objectForKey:@"user"]];
    MDActivity *anActivity = [MDActivity
                              activityWithJSON:[JSON objectForKey:@"activity"]];
    MDMessage *msg = [MDMessage messageWithID:messageID
                                         body:[JSON objectForKey:@"body"]
                                     activity:anActivity
                                         user:aUser];
    
    return msg;
}

+(NSArray *)messagesWithJSON:(id)JSON
{
    
}

+(MDMessage *)messageWithID:(NSInteger)aID
                       body:(NSString *)aBody
                   activity:(MDActivity *)anActivity
                       user:(MDUser *)aUser
{
    MDMessage *msg = [[MDMessage alloc] init];
    msg.id = aID;
    msg.body = aBody;
    msg.activity = anActivity;
    msg.user = aUser;
    
    return msg;
}

+(MDMessage *)messageWithActivity:(MDActivity *)anActivity
                             body:(NSString *)aBody
{
    MDMessage *message = [[MDMessage alloc] init];
    message.body = aBody;
    message.activity = anActivity;
    message.type = TextMessage;
    
    return message;
}
@end
