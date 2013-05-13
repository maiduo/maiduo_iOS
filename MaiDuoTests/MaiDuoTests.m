//
//  MaiDuoTests.m
//  MaiDuoTests
//
//  Created by 魏琮举 on 13-4-19.
//  Copyright (c) 2013年 魏琮举. All rights reserved.
//

#import "MaiDuoTests.h"
#import "MDHTTPAPI.h"

@implementation MaiDuoTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testUserRegister
{
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    MDUser *user = [[MDUser alloc] initWithUsername:@"13000000000"
                                           password:@"13000000000"];
    [MDHTTPAPI registerUser:user success:^(MDUser *user, MDHTTPAPI *api) {
        NSLog(@"Register access token %@", user.accessToken);
        NSLog(@"Register refresh token %@", user.refreshToken);
    } failure:^(NSError *error) {
        NSLog(@"%@", [error.userInfo objectForKey:@"NSLocalizedRecoverySuggestion"]);
    }];
    while (dispatch_semaphore_wait(semaphore, DISPATCH_TIME_NOW))
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:[NSDate dateWithTimeIntervalSinceNow:10]];
    dispatch_release(semaphore);
}

- (void)testUserLogin
{
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    MDUser *user = [[MDUser alloc] initWithUsername:@"13000000000"
                                           password:@"13000000000"];
    [MDHTTPAPI login:user success:^(MDUser *user, MDHTTPAPI *api) {
        NSLog(@"Access token %@", user.accessToken);
        NSLog(@"Refresh token %@", user.refreshToken);
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
    while (dispatch_semaphore_wait(semaphore, DISPATCH_TIME_NOW))
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:[NSDate dateWithTimeIntervalSinceNow:10]];
    dispatch_release(semaphore);
}

@end
