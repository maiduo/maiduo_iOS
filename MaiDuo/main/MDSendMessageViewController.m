//
//  SendMessageTableViewController.m
//  MaiDuo
//
//  Created by 魏琮举 on 13-4-26.
//  Copyright (c) 2013年 魏琮举. All rights reserved.
//

#import "MDSendMessageViewController.h"

@interface MDSendMessageViewController ()
@end
@implementation MDSendMessageViewController

@synthesize sendMode;

- (id)initWithMode:(SendMode)mode
{
    self = [self init];
    if (self) {
        sendMode = mode;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"发布新活动";
    
    UIBarButtonItem *send = [[UIBarButtonItem alloc]
                             initWithTitle:@"发布"
                             style:UIBarButtonItemStyleBordered
                             target:nil
                             action:@selector(publish)];
    
    self.navigationItem.rightBarButtonItem = send;
}

- (void)publish
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end;