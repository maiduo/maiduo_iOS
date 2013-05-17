//
//  MDChat.m
//  MaiDuo
//
//  Created by 魏琮举 on 13-5-15.
//  Copyright (c) 2013年 魏琮举. All rights reserved.
//

#import "MDChat.h"


@implementation MDChat

+(MDChat *)chatWithText:(NSString *)text
               activity:(MDActivity *)anActivity
                   user:(MDUser *)aUser
{
    MDChat *chat = [[MDChat alloc] init];
    chat.text = text;
    chat.activity = anActivity;
    chat.user = aUser;
    
    return chat;
}

+(MDChat *)chatWithJSON:(id)JSON
{
    NSInteger chatID = [[JSON objectForKey:@"id"] intValue];
    NSString *text = [JSON objectForKey:@"text"];
    id activity = [JSON objectForKey:@"activity"];
    id anUser = [JSON objectForKey:@"user"];
    
    MDChat *chat = [MDChat chatWithText:text
                               activity:[MDActivity activityWithJSON:activity]
                                   user:anUser];
    chat.id = chatID;
    
    return chat;
}

+(NSArray *)chatsWithJSON:(id)JSON
{
    NSArray *jsonChats = (NSArray *)JSON;
    NSMutableArray *chats = [NSMutableArray
                                arrayWithCapacity:jsonChats.count];
    NSInteger size = [jsonChats count];
    for (NSInteger i=0; i < size; i++) {
        chats[i] = [MDChat chatWithJSON:[jsonChats objectAtIndex:i]];
    }
    
    return chats;
}

@end
