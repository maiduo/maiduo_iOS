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

@interface MDLatestViewController ()

@property (nonatomic,strong) EGOTableView *tableView;
@end

@implementation MDLatestViewController

//- (id)initWithStyle:(UITableViewStyle)style
//{
// self = [super initWithStyle:style];
// if (self) {
// }
// return self;
//}

//-(id)

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[self navigationItem] setTitle: @"最新活动"];
    UIBarButtonItem* btnAdd;
    btnAdd = [[UIBarButtonItem alloc]
              initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
              target:self action:@selector(addActivity)];
    
    [[self navigationItem] setRightBarButtonItem: btnAdd];
    // [btnAdd release];
    
    //箭头的返回
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
    temporaryBarButtonItem.title = @"返回";
    self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
    
    activities = [[NSArray alloc] initWithObjects:
                  [NSArray arrayWithObjects: @"1", @"CJ", @"CJ和他的朋友门。",
                   @"各位请主意，聚会改为晚上8点。", nil],
                  [NSArray arrayWithObjects: @"2", @"KiKi", @"KiKi最爱的2B",
                   @"可怜的2B嘴巴一直好不鸟。", nil],
                  [NSArray arrayWithObjects: @"3", @"沈江", @"江总的婚礼现场",
                   @"请大家用热烈的掌声欢迎新人", nil],
                  [NSArray arrayWithObjects: @"4", @"王文彪", @"已婚老男人俱乐部",
                   @"王文彪作为已婚老男人先锋，以发表长篇博文《我是已婚老疙瘩》。", nil],
                  nil];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    //self.tableView=nil;
    self.tableView=[[EGOTableView alloc] initWithFrame:(CGRect){CGPointZero,self.view.bounds.size}];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    [self.view addSubview: self.tableView];
    
    
}
-(void) viewDidAppear:(BOOL)animated
{
    if(activities.count==0){
//        [_tableView autoLoadData];
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
    
    AsyncImageView* imageView;
    NSArray* item = (NSArray *)[activities objectAtIndex: [indexPath row]];
    NSString* uid = (NSString *)[item objectAtIndex: 0];
    NSString* title = (NSString *)[item objectAtIndex: 2];
    NSString* detail = (NSString *)[item objectAtIndex: 3];
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
        cell.textLabel.text = title;
        cell.detailTextLabel.text = detail;
        cell.detailTextLabel.numberOfLines = 2;
        cell.indentationLevel = 1;
        cell.indentationWidth = 80;
    }
    
    imageView = (AsyncImageView *)[cell viewWithTag: IMAGE_VIEW_TAG];
    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:imageView];
    
    static NSString* image_url;
    image_url = @"http://oss.aliyuncs.com/maiduo/%@.jpg";
    imageView.imageURL = [NSURL URLWithString:
                          [NSString stringWithFormat:image_url, uid]];
    
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
    activityViewController = [[MDActivityTableViewController alloc] init];
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
    [self.tableView refreshTableView];
}

@end
