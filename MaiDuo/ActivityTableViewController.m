//
//  SkeletonViewController.m
//  MaiDuo
//
//  Created by 魏琮举 on 13-4-20.
//  Copyright (c) 2013年 魏琮举. All rights reserved.
//

#import "ActivityTableViewController.h"
#import "InviteTableViewController.h"
#import "AsyncImageView/AsyncImageView.h"
#import "MDMessage.h"

@interface ActivityTableViewController ()

@end

@implementation ActivityTableViewController

@synthesize viewState;
@synthesize activities;
@synthesize messages;
@synthesize contacts;
@synthesize data;

@synthesize compose;
@synthesize add;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.activities = [NSMutableArray arrayWithObjects:
                           [[MDMessage alloc]
                            initWithBody:@""
                            messageForId:5
                            messageForType:VideoMessage],
                           [[MDMessage alloc]
                            initWithBody:@""
                            messageForId:6
                            messageForType:ImageMessage],
                           [[MDMessage alloc]
                            initWithBody:@"牙疼。。。"
                            messageForId:7
                            messageForType:TextMessage],nil];
        
        self.data = [NSArray arrayWithObjects: activities, nil];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
                                             initWithTitle:@"返回"
                                             style:UIBarButtonItemStylePlain
                                             target:self
                                             action:@selector(back)];
    
    UISegmentedControl* segment = [[UISegmentedControl alloc]
                                   initWithItems:@[@"活动", @"消息", @"通讯录"]];
    segment.segmentedControlStyle = UISegmentedControlSegmentCenter;
    segment.selectedSegmentIndex = 0;
    viewState = ACTIVITY;
    
    [segment addTarget:self
             action:@selector(segmentedChanged:forEvent:)
             forControlEvents:UIControlEventValueChanged];

    self.navigationItem.titleView = segment;
    self.navigationItem.rightBarButtonItem = [self createButton];
}

- (UIBarButtonItem *)createButton
{
    switch (viewState) {
    case ACTIVITY:
        if (nil == compose) {
            self.compose = [[UIBarButtonItem alloc]
                       initWithBarButtonSystemItem:UIBarButtonSystemItemCompose
                       target:self
                       action:@selector(back)];
        }
        return self.compose;
    case CONTACT:
        if (nil == add) {
            self.add = [[UIBarButtonItem alloc]
                   initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                   target:self
                   action:@selector(invite)];
        }
        return self.add;
    default:
        break;
    }
    
    return nil;
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)invite
{
    UITableViewController* inviteViewController;
    inviteViewController = [[InviteTableViewController alloc]
                            initWithStyle: UITableViewStylePlain];
    
    [self.navigationController pushViewController:
     inviteViewController animated:YES];
}

- (void)addActivity
{
}

- (void)segmentedChanged:(id)sender forEvent:(UIEvent *)event
{
    UISegmentedControl* segmented = (UISegmentedControl *)sender;
//    NSLog(@"Segmented selected %d", segmented.selectedSegmentIndex);
//    NSLog(@"ACTIVITY %d", ACTIVITY);
//    NSLog(@"MESSAGE %d", MESSAGE);
//    NSLog(@"CONTACT %d", CONTACT);
    self.viewState = segmented.selectedSegmentIndex;
    self.navigationItem.rightBarButtonItem = [self createButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
numberOfRowsInSection:(NSInteger)section
{
    NSMutableArray* list = (NSMutableArray *)[self.data objectAtIndex:self.viewState];
    return [list count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray* list = (NSMutableArray *)[data objectAtIndex:self.viewState];
    MDMessage* msg = (MDMessage *)[list objectAtIndex:[indexPath row]];
    return [self createCell:msg
            tableView:tableView
            cellForRowAtIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray* list = (NSMutableArray *)[data objectAtIndex:self.viewState];
    MDMessage* msg = (MDMessage *)[list objectAtIndex:[indexPath row]];
    NSInteger height;
    switch(viewState) {
        case ACTIVITY:
            switch (msg.type) {
                case ImageMessage:
                    height = 300.0f;
                    break;
                case VideoMessage:
                    height = 169.0f;
                    break;
                case TextMessage:
                    height = 70.0f;
                    break;
                default:
                    break;
            }
            break;
    }
    return height + 20.0f;
}

- (UITableViewCell *)createCell:(MDMessage *)message
tableView:(UITableView *)tableView
cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell;
    switch (message.type) {
        case TextMessage:
            cell = [self createCellWithText:message tableView: tableView
                    cellForRowAtIndexPath:indexPath];
            break;
        case ImageMessage:
            cell = [self createCellWithImage:message tableView: tableView
                    cellForRowAtIndexPath:indexPath];
            break;
        case VideoMessage:
            cell = [self createCellWithVideo:message tableView: tableView
                    cellForRowAtIndexPath:indexPath];
            break;
        default:
            break;
    }
    
    return cell;
}

- (UITableViewCell *)createCellWithVideo:(MDMessage *)message
tableView:(UITableView *)tableView
cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"%ld",
                                (long)[indexPath row]];
    UITableViewCell *cell = [tableView
                             dequeueReusableCellWithIdentifier:CellIdentifier];
    
    AsyncImageView* imageView;    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle: UITableViewCellStyleSubtitle
                reuseIdentifier: CellIdentifier];
        
        cell.indentationWidth = 10;
        cell.indentationLevel = 1;

        
        imageView = [[AsyncImageView alloc]
                     initWithFrame: CGRectMake(10.0f, 10.0f, 300.0f, 169.0f)];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        imageView.tag = CELL_IMAGE_VIEW;
        
        [cell addSubview: imageView];
    }
    
    imageView = (AsyncImageView *)[cell viewWithTag: CELL_IMAGE_VIEW];
    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:imageView];
    
    static NSString* image_url;
    image_url = @"http://192.168.4.106:8000/%d.png";
    imageView.imageURL = [NSURL URLWithString:
                          [NSString stringWithFormat:image_url,
                           message.messageId]];
    
    return cell;
}

- (UITableViewCell *)createCellWithImage:(MDMessage *)message
tableView:(UITableView *)tableView
cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"%ld",
                                (long)[indexPath row]];
    UITableViewCell *cell = [tableView
                             dequeueReusableCellWithIdentifier:CellIdentifier];
    
    AsyncImageView* imageView;
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle: UITableViewCellStyleSubtitle
                reuseIdentifier: CellIdentifier];
        cell.indentationWidth = 10;
        cell.indentationLevel = 1;
        imageView = [[AsyncImageView alloc]
                     initWithFrame: CGRectMake(10.0f, 10.0f, 300.0f, 300.0f)];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        imageView.tag = CELL_IMAGE_VIEW;
        
        [cell addSubview: imageView];
    }
    
    imageView = (AsyncImageView *)[cell viewWithTag: CELL_IMAGE_VIEW];
    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:imageView];
    
    static NSString* image_url;
    image_url = @"http://192.168.4.106:8000/%d.png";
    imageView.imageURL = [NSURL URLWithString:
                          [NSString stringWithFormat:image_url,
                           message.messageId]];
    
    return cell;
}

- (UITableViewCell *)createCellWithText:(MDMessage *)message
tableView:(UITableView *)tableView
cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"%ld",
                                (long)[indexPath row]];
    UITableViewCell *cell = [tableView
                             dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle: UITableViewCellStyleSubtitle
                reuseIdentifier: CellIdentifier];
        cell.indentationWidth = 10;
        cell.indentationLevel = 1;

        cell.textLabel.text = message.body;
    }
    
    return cell;
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
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}


@end
