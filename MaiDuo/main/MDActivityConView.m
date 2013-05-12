//
//  MDActivityConView.m
//  MaiDuo
//
//  Created by WangPeng on 5/12/13.
//  Copyright (c) 2013 魏琮举. All rights reserved.
//

#import "MDActivityConView.h"
#import "MDActivityConCell.h"
#import "MDInviteTableViewController.h"

@implementation MDActivityConView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _tableView = [[UITableView alloc] initWithFrame:self.bounds];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self addSubview:_tableView];
        
        MDContact *item1 = [[MDContact alloc] init];
        item1.firstName = @"三";
        item1.lastName = @"张";
        item1.phones = @[@"900022022",@"992828282"];
        MDContact *item2 = [[MDContact alloc] init];
        item2.firstName = @"三";
        item2.lastName = @"张";
        item2.phones = @[@"900022022",@"992828282"];
        MDContact *item3 = [[MDContact alloc] init];
        item3.firstName = @"三";
        item3.lastName = @"张";
        item3.phones = @[@"900022022",@"992828282"];
        _source = [NSMutableArray arrayWithObjects:item1, item2, item3, nil];
    }
    return self;
}

- (void)rightBarAction
{
    MDInviteTableViewController *inviteVC = [[MDInviteTableViewController alloc] initWithStyle:UITableViewStylePlain];
    [self.controller.navigationController pushViewController:inviteVC animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_source count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"MDActivityConCell";
    MDActivityConCell *cell = (MDActivityConCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        cell = [[MDActivityConCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    cell.item = [_source objectAtIndex:indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [MDActivityConCell heightWithItem:[_source objectAtIndex:indexPath.row]];
}

@end
