//
//  YMessage.m
//  MaiDuo
//
//  Created by 魏琮举 on 13-5-5.
//  Copyright (c) 2013年 魏琮举. All rights reserved.
//

#import "YMessage.h"

@implementation YMessage
@synthesize body;
@synthesize contacts;
-(id) init
{
    self = [super init];
    if (self) {
        contacts = [NSMutableArray array];
    }
    
    return self;
}

-(void)addContact:(YPlainContact *)contact
{
    [contacts addObject: contact];
}
@end
