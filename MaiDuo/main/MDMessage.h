//
//  Activity.h
//  MaiDuo
//
//  Created by 魏琮举 on 13-4-20.
//  Copyright (c) 2013年 魏琮举. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MDItem.h"

enum {
    ImageMessage,
    VideoMessage,
    TextMessage
} typedef MessageType;

@interface MDMessage : MDItem {
    
}

@property(nonatomic, assign) NSInteger messageId;
@property(nonatomic, strong) NSString* body;
@property(nonatomic, assign) MessageType type;

@end
