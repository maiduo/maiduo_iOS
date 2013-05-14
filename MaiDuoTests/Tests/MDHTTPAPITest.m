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
    
    MDUser *user = [[MDUser alloc] initWithUsername:@"13000000000"
                                           password:@"13000000000"];
    [MDHTTPAPI login:user success:^(MDUser *user, MDHTTPAPI *api) {
        operationSuccessed = YES;
        
        [condition lock];
        [condition signal];
        [condition unlock];
    } failure:^(NSError *error) {
        operationSuccessed = NO;
        
        [condition lock];
        [condition signal];
        [condition unlock];
    }];
    
    [condition lock];
    [condition wait];
    [condition unlock];
    
    GHAssertTrue(operationSuccessed, @"");
}

-(void)testSendMessage
{
    MDMessage *message = [[MDMessage alloc] init];
    [api sendMessage:message success:^(MDMessage *aMessage) {
        operationSuccessed = YES;
        
        [condition lock];
        [condition signal];
        [condition unlock];
    } failure:^(NSError *error) {
        operationSuccessed = NO;
        
        [condition lock];
        [condition signal];
        [condition unlock];
    }];
    
    [condition lock];
    [condition wait];
    [condition unlock];
    
    GHAssertTrue(operationSuccessed, @"");
}
@end
