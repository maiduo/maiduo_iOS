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
    
    UIBarButtonItem *back;
    back = [[UIBarButtonItem alloc]
            initWithTitle:@"返回"
            style:UIBarButtonItemStyleBordered
            target:self
            action:@selector(didBack)];
    self.navigationItem.leftBarButtonItem = back;
    
    self.tableView.allowsMultipleSelection = YES;
    [self.tableView setEditing:YES animated:YES];
}

-(void) didBack
{
    [self.navigationController popViewControllerAnimated:YES];
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
