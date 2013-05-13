//
//  SendMessageTableViewController.h
//  MaiDuo
//
//  Created by 魏琮举 on 13-4-26.
//  Copyright (c) 2013年 魏琮举. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <YMessageViewController.h>

typedef enum {
    ACTIVITY_MODE,
    MESSAGE_MODE
} SendMode;

@interface MDSendMessageViewController : YMessageViewController {
    SendMode sendMode;
}

@property (nonatomic, assign) SendMode sendMode;

- (id)initWithMode:(SendMode)mode;
@end
