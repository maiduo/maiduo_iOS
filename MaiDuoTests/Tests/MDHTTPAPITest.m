//
//  MDHTTPAPITest.m
//  MaiDuo
//
//  Created by 魏琮举 on 13-5-14.
//  Copyright (c) 2013年 魏琮举. All rights reserved.
//

#include "MaiDuoTests.h"

@interface MDHTTPAPITest : GHTestCase {
    NSCondition *condition;
    BOOL operationSuccessed;
    
    MDHTTPAPI *api;
    MDActivity *activity;
}
@end

@implementation MDHTTPAPITest

-(void) setUp
{
    condition = [[NSCondition alloc] init];
    operationSuccessed = NO;
    MDUser *user = [[MDUser alloc] initWithUsername:@"13000000000"
                                          password:nil];
    user.accessToken = @"0acc2d039fc04202bfc6e0a5aed5091f";
    user.id = 2;
    
    activity = [MDActivity activityWithID:2
                                  subject:@"Activity subject"
                                    owner:user
                                    users:@[user]];
    
    api = [MDHTTPAPI MDHTTPAPIWithToken:user];
}

//- (void)testUserRegister
//{
//    MDUser *user = [[MDUser alloc] initWithUsername:@"13000000000"
//                                           password:@"13000000000"];
//    [MDHTTPAPI registerUser:user success:^(MDUser *user, MDHTTPAPI *api) {
//        
//        NSLog(@"Register access token %@", user.accessToken);
//        NSLog(@"Register refresh token %@", user.refreshToken);
//    } failure:^(NSError *error) {
//        NSLog(@"%@", [error.userInfo objectForKey:@"NSLocalizedRecoverySuggestion"]);
//    }];
//    
//
//}
//

- (void)testUserLogin
{
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    MDUser *user = [[MDUser alloc] initWithUsername:@"13000000000"
                                           password:@"13000000000"];
    [MDHTTPAPI login:user success:^(MDUser *user, MDHTTPAPI *api) {
        operationSuccessed = YES;
        dispatch_semaphore_signal(semaphore);
    } failure:^(NSError *error) {
        operationSuccessed = NO;
        dispatch_semaphore_signal(semaphore);
    }];
    
    while (dispatch_semaphore_wait(semaphore, DISPATCH_TIME_NOW)) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:10]];
    }
    
    GHAssertTrue(operationSuccessed, @"");
}

-(void)testActivitiesSuccess
{
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    void (^success)(NSArray *) = ^(NSArray *activies) {
        operationSuccessed = YES;
        dispatch_semaphore_signal(semaphore);
    };
    
    void (^failure)(NSError *) = ^(NSError *error) {
        operationSuccessed = NO;
        dispatch_semaphore_signal(semaphore);
    };
    
    [api activitiesSuccess:success failure:failure];
    while (dispatch_semaphore_wait(semaphore, DISPATCH_TIME_NOW)) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:10]];
    }
    
    GHAssertTrue(operationSuccessed, @"");
}

- (void)testCreateActivity
{
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    MDActivity *anActivity = [MDActivity activityWithSubject:@"Activity subject"];
    
    void (^success)(MDActivity *) = ^(MDActivity *aActivity) {
        operationSuccessed = YES;
        dispatch_semaphore_signal(semaphore);
    };
    
    void (^failure)(NSError *) = ^(NSError *error) {
        operationSuccessed = NO;
        dispatch_semaphore_signal(semaphore);
    };
    
    [api createActivity:anActivity success:success failure:failure];
    while (dispatch_semaphore_wait(semaphore, DISPATCH_TIME_NOW)) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:[NSDate dateWithTimeIntervalSinceNow:10]];
    }
    
    GHAssertTrue(operationSuccessed, @"");
}

-(void)testSendChat
{
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    MDChat *chat = [MDChat chatWithText:@"Hello."
                               activity:activity
                                   user:activity.owner];
    
    [api sendChat:chat
          success:^(MDChat *aChat) {
              operationSuccessed = YES;
              NSLog(@"Chat ID %d text %@", aChat.id, aChat.text);
              dispatch_semaphore_signal(semaphore);
          }
          failure:^(NSError *error) {
              operationSuccessed = NO;
              dispatch_semaphore_signal(semaphore);
          }];
    while (dispatch_semaphore_wait(semaphore, DISPATCH_TIME_NOW)) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:[NSDate dateWithTimeIntervalSinceNow:10]];
    }
    
    GHAssertTrue(operationSuccessed, @"");
}

-(void)testSendTextMessage
{
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    MDMessage *message = [[MDMessage alloc] init];
    [api sendMessage:message success:^(MDMessage *aMessage) {
        operationSuccessed = YES;
        dispatch_semaphore_signal(semaphore);
    } failure:^(NSError *error) {
        operationSuccessed = NO;
        dispatch_semaphore_signal(semaphore);
    }];
    
    while (dispatch_semaphore_wait(semaphore, DISPATCH_TIME_NOW)) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:10]];
    }
    GHAssertTrue(operationSuccessed, @"");
}
@end
