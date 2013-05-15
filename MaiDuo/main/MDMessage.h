//
//  Activity.h
//  MaiDuo
//
//  Created by 魏琮举 on 13-4-20.
//  Copyright (c) 2013年 魏琮举. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MDItem.h"

enum {
    ImageMessage,
    VideoMessage,
    TextMessage
} typedef MessageType;

@interface MDMessage : MDItem {
    
}

@property(nonatomic, assign) NSInteger messageId;
@property(nonatomic, strong) NSString* body;
@property(nonatomic, assign) MessageType type;

-(NSMutableDictionary *)valueDictionary;

+(MDMessage *)messageWithJSON:(id)JSON;
+(NSArray *)messagesWithJSON:(id)JSON;

/** 创建消息对象
 
 这个方法是为使用[MDHTTPAPI sendMessage:success:failure:]所使用的消息对象提供了工厂方法
 
 @param body 消息内容
 @return MDMessage对象
 @see [MDHTTPAPI sendMessage:success:failure:]
 */
+(MDMessage *)messageWithBody:(NSString *)body;
@end
