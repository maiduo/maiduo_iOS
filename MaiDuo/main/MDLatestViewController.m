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
#import "MDPersonDetailViewController.h"
#import <AFNetworking/AFNetworking.h>

@interface MDLatestViewController ()

@property (nonatomic,strong) EGOTableView *tableView;
@end

@implementation MDLatestViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"view did load.");
    
    [[self navigationItem] setTitle: @"最新活动"];
    
    UIBarButtonItem* btnAdd;
    btnAdd = [[UIBarButtonItem alloc]
              initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
              target:self action:@selector(addActivity)];
    
    [[self navigationItem] setRightBarButtonItem: btnAdd];
    
    //箭头的返回
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
    temporaryBarButtonItem.title = @"返回";
    self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
    
    _api = [[YaabUser sharedInstance] api];
    

    self.tableView=[[EGOTableView alloc] initWithFrame:(CGRect){CGPointZero,self.view.bounds.size}];
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
    MDSendMessageViewController *sendMessage;
    sendMessage = [[MDSendMessageViewController alloc] initWithMode:ACTIVITY_MODE];
    [self.navigationController pushViewController:sendMessage animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
//        imageView.tag = IMAGE_VIEW_TAG;
        
        [cell addSubview: imageView];
        
        // cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = activity.subject;
//        cell.detailTextLabel.text = detail;
        cell.detailTextLabel.numberOfLines = 2;
        cell.indentationLevel = 1;
        cell.indentationWidth = 80;
    }
    
    imageView = (AsyncImageView *)[cell viewWithTag: IMAGE_VIEW_TAG];
    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:imageView];
    
    static NSString* image_url;
    
    if (nil != activity.owner.avatar) {
        [imageView setImageWithURL:[NSURL URLWithString:activity.owner.avatar]];
     } else {
         [imageView setImageWithURL:
          [NSURL URLWithString:[[NSBundle mainBundle]
                                pathForResource:@"default_avatar.png"
                                ofType:@"png"]]];
     }
    
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

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MDActivityTableViewController* activityViewController;
    MDActivity* activity = (MDActivity *)[activities
                                          objectAtIndex:[indexPath row]];
    activityViewController = [[MDActivityTableViewController alloc]
                              initWithActivity:activity];
    activityViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width,
                                                   self.view.frame.size.height);
    [self.navigationController pushViewController:activityViewController animated:YES];

// Feng999的用户界面的触发代码
// 因为和逻辑不符合，注释掉，并且不触发
    
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    ActivityTableViewController* activityViewController;
//    activityViewController = [[ActivityTableViewController alloc] init];
//    activityViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width,
//                                     self.view.frame.size.height);
//    [self.navigationController pushViewController:activityViewController animated:YES];
//    NSArray *tempArray = [[NSArray alloc] initWithArray:[activities objectAtIndex:indexPath.row]];
//    PersonDetailViewController *personDetailViewController = [[PersonDetailViewController alloc]
//                                                              init];
//    personDetailViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
//    personDetailViewController.activity = tempArray;
//    [self.navigationController pushViewController:personDetailViewController animated:YES];
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods
// 页面滚动时回调
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //NSLog(@"scrollViewDidScroll");
    [self.tableView egoRefreshScrollViewDidScroll:scrollView];
}

// 滚动结束时回调
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    //NSLog(@"scrollViewDidEndDragging");
    [self.tableView egoRefreshScrollViewDidEndDragging:scrollView];
    
}
#pragma mark -
#pragma mark EGOTableViewDelegate Methods
- (void) startLoadData:(id) sender
{
    //[self getAllProduct];
    //请求完后调用，用来使 tableview返回正常状态
    
    [_api activitiesSuccess:^(NSArray *anActivies) {
        activities = anActivies;
        [self.tableView loaded];
    } failure:^(NSError *error) {
        NSLog(@"Error");
    }];
}

@end
