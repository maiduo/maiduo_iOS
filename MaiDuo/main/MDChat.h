//
//  MDChat.h
//  MaiDuo
//
//  Created by 魏琮举 on 13-5-15.
//  Copyright (c) 2013年 魏琮举. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MDActivity.h"
#import "MDUser.h"

@interface MDChat : NSObject

/** 聊天的ID
 */
@property(assign) NSInteger id;

/** 活动
 */
@property(nonatomic, strong) MDActivity *activity;

/** 用户
 */
@property(nonatomic, strong) MDUser *user;

/** 内容
 */
@property(copy) NSString *text;
/** 创建的日期
 */
@property(nonatomic, strong) NSDate *createAt;

/** 把对象存储的内容转换为字典 - 失效
 
 
 @return [NSMutableDictionary]
 @see dictionaryForAPIWithAccessToken:
 @see [MDHTTPAPI sendChat:activity:user:]
 */
-(NSMutableDictionary *)dictionaryValue;


/** 为[MDHTTPAPI sendMessage:activity:user]提供序列化MDChat的方法
 
 @param accessToken 访问Token
 @return NSDictionary
 @see [MDHTTPAPI sendMessage:activity:user]
 */
-(NSDictionary *)dictionaryForAPIWithAccessToken:(NSString *)accessToken;

/** 构造MDChat聊天对象 － 该工厂方法用于在请求HTTP Service前创建MDChat对象
 
 @param text 聊天内容
 @param anActivity [MDActivity]
 @param aUser [MDUser]
 @return [MDChat]
 
 @see [MDUser]
 @see [MDActivity]
 */
+(MDChat *)chatWithText:(NSString *)text
               activity:(MDActivity *)anActivity
                   user:(MDUser *)aUser;


/** 构造MDChat聊天对象 － 该工厂个方法用于在[MDHTTPAPI sendChat:chat:activity:user]内
构造返回对象
 @param JSON NSObject JSON Object
 @return [MDChat]
 
 @see [MDHTTPAPI sendChat:chat:activity:user]
 */
+(MDChat *)chatWithJSON:(id)JSON;
@end
