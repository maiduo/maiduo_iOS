//
//  Activity.m
//  MaiDuo
//
//  Created by 魏琮举 on 13-4-20.
//  Copyright (c) 2013年 魏琮举. All rights reserved.
//

#import "MDMessage.h"

@implementation MDMessage
@synthesize body;
@synthesize type;
@synthesize messageId;

- (id) initWithBody:(NSString *)_body
       messageForId:(NSInteger)_messageId
     messageForType:(MessageType)_type
{
    self = [self init];
    if (self) {
        self.body = _body;
        self.type = _type;
        self.messageId = _messageId;
    }
    
    return self;
}
@end
