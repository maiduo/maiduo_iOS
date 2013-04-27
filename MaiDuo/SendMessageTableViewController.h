//
//  SendMessageTableViewController.h
//  MaiDuo
//
//  Created by 魏琮举 on 13-4-26.
//  Copyright (c) 2013年 魏琮举. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    ACTIVITY_MODE,
    MESSAGE_MODE
} SendMode;

@interface SendMessageTableViewController : UITableViewController {
    SendMode sendMode;
}

@property (nonatomic, assign) SendMode sendMode;

- (id)initWithMode:(SendMode)mode;
@end
