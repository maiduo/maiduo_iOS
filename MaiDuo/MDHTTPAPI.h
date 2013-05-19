//
//  MDHTTPAPI.h
//  MaiDuo
//
//  Created by 魏琮举 on 13-5-10.
//  Copyright (c) 2013年 魏琮举. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MDHTTPAPIFactory.h"
#import "MDUser.h"
#import "MDMessage.h"
#import "MDActivity.h"
#import "MDChat.h"

/** 麦垛服务接口库
 
 这个库包含了所有的麦垛的服务请求，HTTP Rest风格，OAuth2的认证流程。
 
 下面是范例，MDHTTPAPI没有提供伪托的方式编程，使用闭包应用异步开发。
 
 *使用范例：*
 
     [MDHTTPAPI login:user success:^(MDUser *user, MDHTTPAPI *api) {
         NSLog(@"Your name is %@.", user.first_name);
     } failure:^(NSError *error) {
         NSLog(@"I'm sorry.");
     }];
 
 因为是异步，所以不能在单元测试中使用[NSConditionLock]，会锁定线程。
 
 *异步单元测试范例：*
 
     dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);

     [MDHTTPAPI login:user success:^(MDUser *user, MDHTTPAPI *api) {
         NSLog(@"Your name is %@.", user.first_name);
         dispatch_semaphore_signal(semaphore);
     } failure:^(NSError *error) {
         NSLog(@"I'm sorry.");
         dispatch_semaphore_signal(semaphore);
     }];

 
     while (dispatch_semaphore_wait(semaphore, DISPATCH_TIME_NOW)) {
         [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:10]];
     }
 
     NSLog(@"好了，你可以在这里做Assert);
 
 @warning *Note*: 远程接口还在开发和测试阶段，接口名随时可能会更改。
 */

@interface MDHTTPAPI : NSObject
{
    NSString *url;
}

@property(nonatomic, strong) MDUser *user;
@property(copy) NSString *service;
@property(retain) MDHTTPAPIFactory *factory;
-(id) initWithUser:(MDUser *)user;

/** 获得所有的活动列表
 
 按时间降序返回，试验性，之后会加入分页。
 
 @param success 远程服务成功执行后向`success`返回数据。
 
 <dl>
    <dt>activies</dt>
    <dd>活动列表数组。</dd>
 </dl>
 
 @param failure 如果远程服务器不能正确执行，则输入`NSError`。
 
 <dl>
    <dt>error</dt>
    <dd><code>NSError</code>包含原始的请求错误。</dd>
 </dl>
 */
-(void)activitiesSuccess:(void (^)(NSArray *activies))success
                 failure:(void (^)(NSError *error))failure;

/** 创建活动
 
 创建活动的API提供了专用的工厂方法 
 
 - [MDActivity activityWithSubject:]
 - [MDActivity activityWithSubject:description:]

 
 @param activity `MDActivity activityWithSubject:`
 
 @see [MDActivity activityWithSubject:]
 @see [MDActivity activityWithSubject:description:]
 
 */
-(void)createActivity:(MDActivity *)activity
              success:(void (^)(MDActivity *anActivity))success
              failure:(void (^)(NSError *error))failure;

/** 发送消息
 
 在调用发送消息以前，请使用工厂方法[MDMessage messageWithBody:]实例化MDMessage对象。
 
 @param message MDMessage对象
 @param success 远程服务成功执行后向`success`返回数据。
 
 <dl>
 <dt>message</dt>
 <dd>成功保存的MDMessage对象，包含<code>id</code>属性。</dd>
 </dl>
 
 @param failure 如果远程服务器不能正确执行，则输入`NSError`。
 
 <dl>
 <dt>error</dt>
 <dd><code>NSError</code>包含原始的请求错误。</dd>
 </dl>
 
 @see [MDMessage messageWithBody:]
 */
-(void)sendMessage:(MDMessage *)message
           success:(void (^)(MDMessage *))success
           failure:(void (^)(NSError *error))failure;

/** 查询活动下所有的消息
 
 @param activity MDActivity对象必须包含`id`属性。
 @param page 分业
 @param success 远程服务成功执行后向`success`返回数据。
 
 <dl>
 <dt>messages</dt>
 <dd>活动下的所有消息</dd>
 </dl>
 
 @param failure 如果远程服务器不能正确执行，则输入`NSError`。
 
 <dl>
 <dt>error</dt>
 <dd><code>NSError</code>包含原始的请求错误。</dd>
 </dl>
 */
-(void)messagesWithActivity:(MDActivity *)activity
                       page:(NSInteger)page
                    success:(void (^)(NSArray *messages))success
                    failure:(void (^)(NSError *error))failure;


/** 查询聊天纪录
 
 @param activity MDActivity对象必须包含`id`属性。
 @param page 分页
 @param success 远程服务成功执行后向`success`返回数据。
 
 <dl>
 <dt>chats</dt>
 <dd>活动下的所有消息</dd>
 </dl>
 
 @param failure 如果远程服务器不能正确执行，则输入`NSError`。
 
 <dl>
 <dt>error</dt>
 <dd><code>NSError</code>包含原始的请求错误。</dd>
 </dl>
 */
-(void)chatsWithActivity:(MDActivity *)activity
                    page:(NSInteger)page
                 success:(void (^)(NSArray *chats))success
                 failure:(void (^)(NSError *error))failure;

/** 发送聊天
 
 推送的数据：
 
    {
        "user_id": 1,
        "activity_id": 1,
        "chat_id": 1
    }
 
 @param chat [MDChat]
 @param success 远程服务成功执行后向`success`返回数据。
 
 <dl>
 <dt>messages</dt>
 <dd>活动下的所有消息</dd>
 </dl>
 
 @param failure 如果远程服务器不能正确执行，则输入`NSError`。
 
 <dl>
 <dt>error</dt>
 <dd><code>NSError</code>包含原始的请求错误。</dd>
 </dl>
 
 @see [MDChat chatWithText:activity:user:]
 @see [MDChat]
 */
-(void)sendChat:(MDChat *)chat
        success:(void (^)(MDChat *))success
        failure:(void (^)(NSError *error))failure;

/** 注册用户
 
 [MDUser deviceToken] 如果存在，同时登记设备Token。
 
 @param user [MDUser]
 @param success 远程服务成功执行后向`success`返回数据。
 
 <dl>
 <dt>user</dt>
 <dd>MDUser</dd>
 </dl>
 <dl>
    <dt>api</dt>
    <dd>MDHTTPAPI</dd>
 </dl>
 
 @param failure 如果远程服务器不能正确执行，则输入`NSError`。
 
 <dl>
 <dt>error</dt>
 <dd><code>NSError</code>包含原始的请求错误。</dd>
 </dl>
 
 @see MDUser
 */
+(void)registerUser:(MDUser *)user
            success:(void (^)(MDUser *user, MDHTTPAPI *api))success
            failure:(void (^)(NSError *error))failure;

/** 用户登陆
 
 验证并获得用户状态，保存在 [MDUser accessToken].
 
 @param user [MDUser]
 @param success 远程服务成功执行后向`success`返回数据。
 
 <dl>
 <dt>user</dt>
 <dd>MDUser</dd>
 </dl>
 <dl>
 <dt>api</dt>
 <dd>MDHTTPAPI</dd>
 </dl>
 
 @param failure 如果远程服务器不能正确执行，则输入`NSError`。
 
 <dl>
 <dt>error</dt>
 <dd><code>NSError</code>包含原始的请求错误。</dd>
 </dl>
 
 @see MDUser
 */
+(void)login:(MDUser *)user
     success:(void (^)(MDUser *user, MDHTTPAPI *api))success
     failure:(void (^)(NSError *error))failure;

/** MDHTTPAPI
 
 @warning 不推荐使用，这是单元测试使用的。
 
 @param user `MDUser`
 @return `MDHTTPAPI`
 */
+(MDHTTPAPI *)MDHTTPAPIWithToken:(MDUser *)user;
@end
