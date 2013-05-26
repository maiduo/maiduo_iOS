//
//  MDNotificationCenterTest.m
//  MaiDuo
//
//  Created by Indvane Mini on 13-5-20.
//  Copyright (c) 2013年 魏琮举. All rights reserved.
//

#import "MaiDuoTests.h"
#import "MDNotificationCenter.h"

@interface MDNotificationCenterTest : GHTestCase

@end


@implementation MDNotificationCenterTest

-(void)pullReceiveChat:(id)sender
{
    MDChat *chat = (MDChat *)[[sender userInfo] objectForKey:@"object"];
    if ([@"Hello" isEqualToString:chat.text]) {
        GHAssertEqualStrings(@"YES", @"YES", @"");
        return;
    }
    
    GHAssertEqualStrings(@"YES", @"NO", @"");
}

-(void)testReceiveMessage
{
    MDUser *user = [[MDUser alloc] init];
    user.userId = 1;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(pullReceiveChat:)
                                                 name:kDidReceiveChat
                                               object:nil];
    MDNotificationCenter *center = [[MDNotificationCenter alloc]
                                    initNotificationCenterWithUser:user
                                    delegate:nil];
    
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                              @"1", @"activity_id",
                              @"1", @"user_id",
                              @"1", @"chat_id",
                              @"Hello", @"chat_text",
                              @"chat", @"type", nil];
    [center post:userInfo];
}
@end
