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
#import "MDContact.h"

@interface ActivityTableViewController ()

@end

@implementation ActivityTableViewController

@synthesize viewState;
@synthesize activities;
@synthesize messages;
@synthesize contacts;
@synthesize data;

@synthesize segmented;
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
        
        self.messages = [[NSMutableArray alloc]initWithCapacity:0];
        self.contacts = [[NSMutableArray alloc]initWithCapacity:0];
        
        [self addPerson];
                         
        self.data = [NSArray arrayWithObjects:activities, messages, contacts, nil];
        
        segmented = [[UISegmentedControl alloc]
                     initWithItems:@[@"消息", @"聊天", @"通讯录"]];
        segmented.segmentedControlStyle = UISegmentedControlSegmentCenter;
        segmented.selectedSegmentIndex = 0;
        [segmented addTarget:self
                      action:@selector(segmentedChanged:forEvent:)
            forControlEvents:UIControlEventValueChanged];
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    self.navigationController.toolbarHidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
//    self.navigationController.toolbarHidden = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    viewState = ACTIVITY;
    self.navigationItem.rightBarButtonItem = [self createButton];
    self.navigationItem.titleView = segmented;
    
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
    temporaryBarButtonItem.title = @"返回";
    self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
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
    inviteViewController = [[InviteTableViewController alloc] init];
    
    [self.navigationController pushViewController:
     inviteViewController animated:YES];
}

- (void)addActivity
{
}

- (void)addPerson
{
    NSArray * phones = @[@"123"];
    MDContact * aPerson = [[MDContact alloc]initWithFirstName:@"a"
                                                     lastName:@"w"
                                                   middleName:@""
                                                       phones:phones];
    [self.contacts addObject:aPerson];
}

//改变tableview数据data
- (void)changeTableviewData
{
    if (self.viewState == CONTACT) {
//        MDContact * bPerson = [[MDContact alloc]initWithFirstName:@"b"
//                                                         lastName:@"w"
//                                                       middleName:@""
//                                                           phones:phones];
//        MDContact * bPerson2 = [[MDContact alloc]initWithFirstName:@"bz"
//                                                         lastName:@"w"
//                                                       middleName:@""
//                                                           phones:phones];

        //测试用
//        NSArray *paths = NSSearchPathForDirectoriesInDomains
//                            (NSDocumentDirectory,NSUserDomainMask,YES);
//        NSString *path = [paths objectAtIndex:0];
//        NSLog(@"path = %@",path);
//        NSString *filename = [path stringByAppendingPathComponent:@"contacts.plist"];
//        NSFileManager* fm = [NSFileManager defaultManager];
//        [fm createFileAtPath:filename contents:nil attributes:nil];
//        
//        NSMutableArray *Astart = [[NSMutableArray alloc]initWithObjects:aPerson, nil];
//        NSMutableArray *Bstart = [[NSMutableArray alloc]initWithObjects:bPerson, bPerson2, nil];
//        //创建一个dic，写到plist文件里
//        NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:
//                             Astart, @"A", Bstart, @"B", nil];
//        [dic writeToFile:filename atomically:YES];
//        
//        NSDictionary* dic2 = [NSDictionary dictionaryWithContentsOfFile:filename];
//        NSLog(@"dic is:%@",dic2);
        
//        self.tableView.showsVerticalScrollIndicator = YES;
    }
}

- (void)changeTitle
{
    switch (self.viewState) {
        case CONTACT:
            [self setTitle:@"所有联系人"];
            break;
            
        default:
            break;
    }
}

- (void)segmentedChanged:(id)sender forEvent:(UIEvent *)event
{
//    NSLog(@"Segmented selected %d", segmented.selectedSegmentIndex);
//    NSLog(@"ACTIVITY %d", ACTIVITY);
//    NSLog(@"MESSAGE %d", MESSAGE);
//    NSLog(@"CONTACT %d", CONTACT);

    self.viewState = segmented.selectedSegmentIndex;
    
    self.navigationItem.rightBarButtonItem = [self createButton];
    
    [self changeTableviewData];
    
    [self changeTitle];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.viewState == CONTACT) {
//        return [keys count];
        return 1;
    }
    return 1;
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
