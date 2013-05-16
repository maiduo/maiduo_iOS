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
    NSString *jsonMessageType = [JSON objectForKey:@"message_type"];
    MessageType messageType;
    if ([@"T" isEqualToString:jsonMessageType]) {
        messageType = TextMessage;
    } else if ([@"I" isEqualToString:jsonMessageType]) {
        messageType = ImageMessage;
    } else {
        messageType = VideoMessage;
    }
    
    MDMessage *msg = [MDMessage messageWithID:messageID
                                         body:[JSON objectForKey:@"body"]
                                     activity:anActivity
                                         user:aUser
                                         type:messageType];
    
    return msg;
}

+(NSArray *)messagesWithJSON:(id)JSON
{
    NSArray *jsonMessages = (NSArray *)JSON;
    NSMutableArray *messages = [NSMutableArray
                                arrayWithCapacity:jsonMessages.count];
    NSInteger size = [jsonMessages count];
    for (NSInteger i=0; i < size; i++) {
        messages[i] = [MDMessage
                       messageWithJSON:[jsonMessages objectAtIndex:i]];
    }
    
    return messages;
}

+(MDMessage *)messageWithID:(NSInteger)aID
                       body:(NSString *)aBody
                   activity:(MDActivity *)anActivity
                       user:(MDUser *)aUser
                       type:(MessageType)aType
{
    MDMessage *msg = [[MDMessage alloc] init];
    msg.id = aID;
    msg.body = aBody;
    msg.activity = anActivity;
    msg.user = aUser;
    msg.type = aType;
    
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
