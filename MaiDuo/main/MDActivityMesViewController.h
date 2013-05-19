//
//  MDActivityMesViewController.h
//  MaiDuo
//
//  Created by 高 欣 on 13-5-15.
//  Copyright (c) 2013年 魏琮举. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSMessagesViewController.h"
#import "MDActivity.h"
@interface MDActivityMesViewController : JSMessagesViewController <JSMessagesViewDelegate, JSMessagesViewDataSource>

@property (strong, nonatomic) NSMutableArray *messages;
@property (strong, nonatomic) NSMutableArray *timestamps;
@property (strong, nonatomic) MDActivity *activity;
@end
