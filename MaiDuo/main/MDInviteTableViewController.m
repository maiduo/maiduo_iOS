//
//  InviteTableViewController.m
//  MaiDuo
//
//  Created by 魏琮举 on 13-4-21.
//  Copyright (c) 2013年 魏琮举. All rights reserved.
//

#import "MDInviteTableViewController.h"
#import "AddressBook/AddressBook.h"
#import "MDContact.h"
#import "pinyin.h"
#import "ctype.h"

@interface MDInviteTableViewController ()
@end
@implementation MDInviteTableViewController
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
