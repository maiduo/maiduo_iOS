//
//  SendMessageTableViewController.m
//  MaiDuo
//
//  Created by 魏琮举 on 13-4-26.
//  Copyright (c) 2013年 魏琮举. All rights reserved.
//

#import "SendMessageTableViewController.h"

@interface SendMessageTableViewController ()

@end

@implementation SendMessageTableViewController

@synthesize sendMode;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (id)initWithMode:(SendMode)mode
{
    self = [self initWithStyle:UITableViewStylePlain];
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
                             style:UIBarButtonItemStyleDone
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.sendMode == ACTIVITY_MODE ? 3 : 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"%d-%d",
                                [indexPath section], [indexPath row]];
    UITableViewCell *cell = [tableView
                             dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (nil == cell) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:CellIdentifier];
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

@end
