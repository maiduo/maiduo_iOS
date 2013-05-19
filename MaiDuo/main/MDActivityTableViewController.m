//
//  SkeletonViewController.m
//  MaiDuo
//
//  Created by 魏琮举 on 13-4-20.
//  Copyright (c) 2013年 魏琮举. All rights reserved.
//

#import "MDActivityTableViewController.h"
#import "AsyncImageView.h"
#import "MDActivityActView.h"
#import "MDActivityConView.h"
#import "MDActivityMesView.h"
#import "MDActivityMesViewController.h"

@interface MDActivityTableViewController () {
    MDActivityActView *_actView;
    MDActivityConView *_conView;
    UIView *_mesView;
    UIView *_currentContentView;
}

@property (assign, nonatomic) MDActivityViewState viewState;
@property (strong, nonatomic) UISegmentedControl* segmented;
@property (strong, nonatomic) MDActivityMesViewController *mesVC;

@end

@implementation MDActivityTableViewController

-(id)initWithActivity:(MDActivity *)anActivity
{
    self = [self init];
    if (self) {
        self.activity = anActivity;
    }
    
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _segmented = [[UISegmentedControl alloc]
                  initWithItems:@[@"消息", @"聊天", @"通讯录"]];
    _segmented.segmentedControlStyle = UISegmentedControlSegmentCenter;
    _segmented.selectedSegmentIndex = 0;
    [_segmented addTarget:self
                   action:@selector(segmentedChanged:forEvent:)
         forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = _segmented;
    
    [self showViewState:MDActivityViewStateAct];
}

- (void)showViewState:(MDActivityViewState)viewState
{
    _viewState = viewState;
    [_currentContentView removeFromSuperview];
    switch (_viewState) {
        case MDActivityViewStateAct:
            if (_actView==nil) {
                _actView = [[MDActivityActView alloc] initWithFrame:self.view.bounds];
                _actView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
                _actView.viewController = self;
            }
            _currentContentView = _actView;
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                                      initWithBarButtonSystemItem:UIBarButtonSystemItemCompose
                                                      target:_currentContentView
                                                      action:@selector(rightBarAction)];
            break;
        case MDActivityViewStateMes:
            if (_mesView==nil) {
                self.mesVC = [[MDActivityMesViewController alloc] init];
                _mesVC.activity=self.activity;
                _mesView=_mesVC.view;
                
                _mesView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
                //_mesView.viewController = self;
            }
            _currentContentView = _mesView;
            self.navigationItem.rightBarButtonItem = nil;
            break;
        case MDActivityViewStateCon:
            if (_conView==nil) {
                _conView = [[MDActivityConView alloc] initWithFrame:self.view.bounds];
                _conView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
                _conView.viewController = self;
            }
            _currentContentView = _conView;
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                                      initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                      target:_currentContentView
                                                      action:@selector(rightBarAction)];
        default:
            break;
    }
    _currentContentView.frame=self.view.bounds;
    [self.view addSubview:_currentContentView];
}

- (void)segmentedChanged:(id)sender forEvent:(UIEvent *)event
{
    [self showViewState:_segmented.selectedSegmentIndex];
}

//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
//    return keys;
//}
//
//- (NSString *)tableView:(UITableView *)tableView
//titleForHeaderInSection:(NSInteger)section
//{
//    NSString *key = [keys objectAtIndex:section];
//    return key;
//}

/*
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"list:%@",self.data);
    NSMutableArray* list = (NSMutableArray *)[self.data objectAtIndex:self.viewState];
    return [list count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%@",self.data);
    NSMutableArray* list = (NSMutableArray *)[self.data objectAtIndex:self.viewState];
    MDMessage* msg = (MDMessage *)[list objectAtIndex:[indexPath row]];
    switch (viewState) {
        case ACTIVITY:
            return [self createCell:msg
                          tableView:tableView
              cellForRowAtIndexPath:indexPath];
        case MESSAGE:
            return [self createCell:msg
                          tableView:tableView
              cellForRowAtIndexPath:indexPath];
        case CONTACT:
            return [self createCellForContactsWithTableView:tableView
                                      cellForRowAtIndexPath:indexPath];
        default:
            return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray* list = (NSMutableArray *)[self.data objectAtIndex:self.viewState];
    MDMessage* msg = (MDMessage *)[list objectAtIndex:[indexPath row]];
    NSInteger height = 0;
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
        case CONTACT:
            height = 50;
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
    image_url = @"http://oss.aliyuncs.com/maiduo/%d.jpg";
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

- (UITableViewCell *)createCellForContactsWithTableView:(UITableView *)tableView
                                  cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"contacts";
    UITableViewCell *cell = [tableView
                             dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle: UITableViewCellStyleSubtitle
                reuseIdentifier: CellIdentifier];
        cell.indentationWidth = 10;
        MDContact * aPerson = [self.contacts objectAtIndex:indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"%@%@%@",
                               aPerson.firstName,
                               aPerson.middleName,
                               aPerson.lastName];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        cell.detailTextLabel.text =[NSString stringWithFormat:@"电话 %@",
                                             [aPerson.phones objectAtIndex:0]];
    }
    
    return cell;
}


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

/*

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];

}

*/

@end
