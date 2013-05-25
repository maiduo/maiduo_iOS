//
//  YMessage.h
//  MaiDuo
//
//  Created by 魏琮举 on 13-5-5.
//  Copyright (c) 2013年 魏琮举. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YPlainContact.h>

@interface YMessage : NSObject
@property (nonatomic, strong) NSString *body;
@property (nonatomic, strong) NSMutableArray *contacts;
-(void)addContact:(YPlainContact *)contact;
@end
