//
//  MDHTTPAPIFactory.h
//  MaiDuo
//
//  Created by 魏琮举 on 13-5-16.
//  Copyright (c) 2013年 魏琮举. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MDMessage.h"
#import "MDChat.h"
#import "MDUser.h"
#import "MDActivity.h"

/** MDHTTPAPIFactory - 为序列化发送数据构建的工厂对象
 
 充血模型构造`NSDictionary`，工厂对象为模型序列化的`NSDictionary`提供HTTP Rest接口需要的
数据。
 */

@interface MDHTTPAPIFactory : NSObject

/** OAuth2 access token
 */
@property (copy) NSString *accessToken;

/** Apple push notification server
 
 dev or production
 */
@property (copy) NSString *service;

/** factoryWithAccessToken:service: 构造工厂对象的工厂方法
 
 @param anAccessToken OAuth2 access token
 @param aService APNS
 @return [MDHTTPAPIFactory]
 */
+(MDHTTPAPIFactory *)factoryWithAccessToken:(NSString *)anAccessToken
                                    service:(NSString *)aService;

-(NSDictionary *)dictionaryForCreateActivity:(MDActivity *)anActivity;
-(NSDictionary *)dictionaryForSendMessage:(MDMessage *)aMessage;
-(NSDictionary *)dictionaryForSendChat:(MDChat *)aChat;
@end
