//
//  NSNotificationCenterTest.m
//  MaiDuo
//
//  Created by Indvane Mini on 13-5-20.
//  Copyright (c) 2013年 魏琮举. All rights reserved.
//

#import "MaiDuoTests.h"

@interface NSNotificationCenterTest : GHTestCase

@end

@implementation NSNotificationCenterTest

-(void)observer1:(id)sender
{
    GHAssertEqualStrings([[sender userInfo] objectForKey:@"name"], @"CJ", @"");
}

-(void) testPostNotificationNameObject
{
    NSDictionary *user = [NSDictionary
                          dictionaryWithObjectsAndKeys:
                          @"CJ", @"name", nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(observer1:)
     name:@"notification1"
     object:nil];
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"notification1"
     object:self
     userInfo:user];
}

@end
