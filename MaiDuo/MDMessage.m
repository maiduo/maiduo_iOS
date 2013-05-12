//
//  Activity.m
//  MaiDuo
//
//  Created by 魏琮举 on 13-4-20.
//  Copyright (c) 2013年 魏琮举. All rights reserved.
//

#import "MDMessage.h"

@implementation MDMessage

- (id) initWithBody:(NSString *)aBody
       messageForId:(NSInteger)aMessageId
     messageForType:(MessageType)aType
{
    self = [self init];
    if (self) {
        self.body = aBody;
        self.type = aType;
        self.messageId = aMessageId;
    }
    
    return self;
}
@end
