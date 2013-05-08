//
//  Activity.h
//  MaiDuo
//
//  Created by 魏琮举 on 13-4-20.
//  Copyright (c) 2013年 魏琮举. All rights reserved.
//

#import <Foundation/Foundation.h>

enum {
    ImageMessage,
    VideoMessage,
    TextMessage
} typedef MessageType;

@interface MDMessage : NSObject {
    
}

@property(nonatomic, assign) NSInteger messageId;
@property(nonatomic, strong) NSString* body;
@property(nonatomic, assign) MessageType type;

- (id) initWithBody:(NSString *)_body
       messageForId:(NSInteger)_messageId
     messageForType:(MessageType)_type;
@end