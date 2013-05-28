//
//  SendMessageTableViewController.m
//  MaiDuo
//
//  Created by 魏琮举 on 13-4-26.
//  Copyright (c) 2013年 魏琮举. All rights reserved.
//

#import "MDWriteMessageViewController.h"

@interface MDWriteMessageViewController ()
@end
@implementation MDWriteMessageViewController

- (id)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.navigationItem.title = @"新消息";
    
    UIBarButtonItem *send = [[UIBarButtonItem alloc]
                             initWithTitle:@"发布"
                             style:UIBarButtonItemStyleBordered
                             target:self
                             action:@selector(didTapPublish:)];
    UIBarButtonItem *close = [[UIBarButtonItem alloc]
                              initWithTitle:@"取消"
                              style:UIBarButtonItemStyleBordered
                              target:self
                              action:@selector(didTapClose:)];
    
    self.navigationItem.rightBarButtonItem = send;
    self.navigationItem.leftBarButtonItem = close;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didTapClose:(id)sender
{
}

- (void)didTapPublish:(id)sender
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end;