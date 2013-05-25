//
// LatestViewController.m
// MaiDuo
//
// Created by 魏琮举 on 13-4-19.
// Copyright (c) 2013年 魏琮举. All rights reserved.
//


#import "EGOTableView.h"
#import "MDLatestViewController.h"
#import "MDActivityTableViewController.h"
#import "MDSendMessageViewController.h"
#import "AsyncImageView.h"
#import <QuartzCore/QuartzCore.h>
#import <AFNetworking/AFNetworking.h>
#import "MDCreateActivityViewController.h"

@interface MDLatestViewController ()

@property (nonatomic,strong) EGOTableView *tableView;
@end

@implementation MDLatestViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"latest view controller did load.");
    
    [[self navigationItem] setTitle: @"最新活动"];
    
    UIBarButtonItem* btnAdd;
    btnAdd = [[UIBarButtonItem alloc]
              initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
              target:self action:@selector(addActivity)];
    
    [[self navigationItem] setRightBarButtonItem: btnAdd];
    [[self navigationItem] setHidesBackButton:YES];
    
    //箭头的返回
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
    temporaryBarButtonItem.title = @"返回";
    self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
                                             initWithTitle:@"个人中心"
                                             style:UIBarButtonItemStylePlain
                                             target:self
                                             action:@selector(detailAction)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(logoutAction:)
                                                 name:USER_LOGOUT
                                               object:nil];
    
    _api = [[YaabUser sharedInstance] api];
    

    self.tableView=[[EGOTableView alloc] initWithFrame:(CGRect){CGPointZero,self.view.bounds.size}];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    [self.view addSubview: self.tableView];
}

-(void) viewDidAppear:(BOOL)animated
{
    if(activities.count==0){
        [_tableView autoLoadData];
    }
    [super viewDidAppear:animated];
}

- (void)addActivity
{
    MDCreateActivityViewController *createActivity;
    createActivity = [[MDCreateActivityViewController alloc] init];
    createActivity.createActivityDelegate = self;
    
    [self.navigationController pushViewController:createActivity
                                         animated:YES];
}

- (void)detailAction
{
    MDPersonDetailViewController *controller;
    controller = [[MDPersonDetailViewController alloc]
                  initWithStyle:UITableViewStyleGrouped];
    [self.navigationController
     presentModalViewController:[[UINavigationController alloc]
                                 initWithRootViewController:controller]
     animated:YES];
}

- (void)logoutAction:(id)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        [self.navigationController popViewControllerAnimated:NO];
        
        MDLoginViewController *loginViewController;
        loginViewController = [[MDLoginViewController alloc] init];
        
        [self.navigationController
         presentModalViewController:[[UINavigationController alloc]
                                     initWithRootViewController:loginViewController]
         animated:YES];
        
        [[MDUserManager sharedInstance] logout];
    }];
}

-(void)refresh
{
    [self.tableView autoLoadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Create activity delegate

-(void)didCreateActivity:(MDActivity *)anActivity
{
    [activities insertObject:anActivity atIndex:0];
    [self.tableView reloadData];
}

-(void)didReceiveFailure:(NSError *)aError
{
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [activities count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"%ld",
                                (long)[indexPath row]];
    UITableViewCell *cell = [tableView
                             dequeueReusableCellWithIdentifier:CellIdentifier];
    
    UIImageView* imageView;

    MDActivity* activity = (MDActivity *)[activities
                                          objectAtIndex:[indexPath row]];
#define IMAGE_VIEW_TAG 99
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle: UITableViewCellStyleSubtitle
                reuseIdentifier: CellIdentifier];
        
        imageView = [[AsyncImageView alloc]
                     initWithFrame: CGRectMake(0.0f, 0.0f, 80.0f, 80.0f)];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        imageView.tag = IMAGE_VIEW_TAG;
        
        [cell addSubview: imageView];
        
        // cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
//        cell.detailTextLabel.text = detail;
        cell.detailTextLabel.numberOfLines = 2;
        cell.indentationLevel = 1;
        cell.indentationWidth = 80;
    }
    
    imageView = (AsyncImageView *)[cell viewWithTag: IMAGE_VIEW_TAG];
    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:imageView];
    
    if (nil != activity.owner.avatar) {
        [imageView setImageWithURL:[NSURL URLWithString:activity.owner.avatar]];
     } else {
//         [imageView setImageWithURL:
//          [NSURL URLWithString:[[NSBundle mainBundle]
//                                pathForResource:@"default_avatar"
//                                ofType:@"png"]]];
         [imageView setImage:[UIImage imageNamed:@"default_avatar"]];
     }
    
    cell.textLabel.text = activity.subject;
    
    NSLog(@"%d %@", activity.id, activity.subject);
    return cell;
}

- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MDActivityTableViewController* activityViewController;
    MDActivity* activity = (MDActivity *)[activities
                                          objectAtIndex:[indexPath row]];
    activityViewController = [[MDActivityTableViewController alloc]
                              initWithActivity:activity];
//    activityViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width,
//                                                   self.view.frame.size.height);
    [self.navigationController pushViewController:activityViewController animated:YES];
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.tableView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView
                  willDecelerate:(BOOL)decelerate
{
    [self.tableView egoRefreshScrollViewDidEndDragging:scrollView];
}

#pragma mark -
#pragma mark EGOTableViewDelegate Methods

- (void)startLoadData:(id)sender
{
    [_api activitiesSuccess:^(NSArray *anActivies) {
        activities = anActivies;
        [self.tableView refreshTableView];
    } failure:^(NSError *error) {
        NSLog(@"Error");
    }];
}
@end
