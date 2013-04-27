//
//  InviteTableViewController.m
//  MaiDuo
//
//  Created by 魏琮举 on 13-4-21.
//  Copyright (c) 2013年 魏琮举. All rights reserved.
//

#import "InviteTableViewController.h"
#import "AddressBook/AddressBook.h"
#import "MDContact.h"
#import "pinyin.h"
#import "ctype.h"

// TODO 仅仅做了一个样子，还需要完成对通讯录的上传和其他处理，把查询的代码逻辑转移到专门到
// MDContact做一个充血的领域模型

@interface InviteTableViewController ()
@end
@implementation InviteTableViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem* buttonInvite;
    buttonInvite = [[UIBarButtonItem alloc]
                    initWithTitle:@"邀请"
                    style:UIBarButtonItemStyleDone
                    target:self
                    action:@selector(didInvited)];
    self.navigationItem.rightBarButtonItem = buttonInvite;
    self.navigationItem.title = @"邀请好友";
    self.navigationItem.backBarButtonItem.title = @"返回";
    
    self.tableView.allowsMultipleSelection = YES;
    [self.tableView setEditing:YES animated:YES];
}

- (void) didInvited
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
@end
