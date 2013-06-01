//
//  Activity.h
//  MaiDuo
//
//  Created by 魏琮举 on 13-4-20.
//  Copyright (c) 2013年 魏琮举. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MDActivity.h"
#import "MDUser.h"

enum {
    ImageMessage,
    VideoMessage,
    TextMessage
} typedef MessageType;

@interface MDMessage : NSObject {
    
}

@property(nonatomic, assign) NSInteger id;
@property(strong) MDActivity *activity;
@property(strong) MDUser *user;
@property(assign) BOOL stash;
@property(nonatomic, strong) NSString* body;
@property(nonatomic, assign) MessageType type;
@property(strong) NSMutableArray *addons;

+(MDMessage *)messageWithJSON:(id)JSON;
+(NSArray *)messagesWithJSON:(id)JSON;

+(MDMessage *)messageWithID:(NSInteger)aID
                       body:(NSString *)aBody
                   activity:(MDActivity *)anActivity
                       user:(MDUser *)aUser
                       type:(MessageType)aType;

/** 创建消息对象
 
 这个方法是为使用[MDHTTPAPI sendMessage:success:failure:]所使用的消息对象提供了工厂方法
 
 @param body 消息内容
 @return MDMessage对象
 @see [MDHTTPAPI sendMessage:success:failure:]
 */
+(MDMessage *)messageWithActivity:(MDActivity *)anActivity
                             body:(NSString *)aBody;
@end
