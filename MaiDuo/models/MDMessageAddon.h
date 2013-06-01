//
//  MDMessageAddon.h
//  MaiDuo
//
//  Created by 魏琮举 on 13-6-1.
//  Copyright (c) 2013年 魏琮举. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MDMessageAddon : NSObject

@property(assign) NSInteger id;
@property(strong) NSString *body;
@property(strong) NSString *extra;
@property(strong) NSDate *createAt;

@end
