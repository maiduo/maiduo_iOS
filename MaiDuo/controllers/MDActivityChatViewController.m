//
//  MDActivityMesViewController.m
//  MaiDuo
//
//  Created by 高 欣 on 13-5-15.
//  Copyright (c) 2013年 魏琮举. All rights reserved.
//

#import "MDActivityChatViewController.h"
#import "MDChat.h"
#import "MDHTTPAPI.h"
#import "MaiDuo.h"
#import "MDAppDelegate.h"

#define chatIDKey @"chat_id"
#define chatTextKey @"text"
#define timeStampsKey @"created_at"
#define kPageSize 10
#define kDidReceiveChat @"didReceiveChat"

@interface MDActivityChatViewController (){
    NSUInteger _currentPageIndex;
    BOOL _loading;
    BOOL _noMore;
    UIActivityIndicatorView *_indicatorView;
}

@property (strong,nonatomic) NSMutableArray *arrayChats;
@property (strong,nonatomic) NSMutableDictionary *dicAccessoryView;
@end

@implementation MDActivityChatViewController
#pragma mark - Initialization
- (UIButton *)sendButton
{
    // Override to use a custom send button
    // The button's frame is set automatically for you
    return [UIButton defaultSendButton];
}

- (id)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    _maiduo = [MaiDuo sharedInstance];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.delegate = self;
    self.dataSource = self;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveChat:) name:kDidReceiveChat object:nil];
    
    
    _currentPageIndex=1;//页数从1开始
    self.title = @"Messages";
    
    self.arrayChats=[NSMutableArray array];
    self.dicAccessoryView=[NSMutableDictionary dictionary];
    MDAppDelegate *appDelegate=(MDAppDelegate*)[UIApplication sharedApplication].delegate;
    [appDelegate showHUDWithLabel:@"正在获取聊天..."];
    [_maiduo.api chatsWithActivity:self.activity
                                                  page:_currentPageIndex
                                              pageSize:kPageSize
                                               success:^(NSArray *chats) {
                                                   [appDelegate hideHUD];
                                                   [self.arrayChats addObjectsFromArray:chats];
                                                   [self.tableView reloadData];
                                                   if(self.arrayChats.count>0){
                                                       NSIndexPath * ndxPath= [NSIndexPath indexPathForRow:self.arrayChats.count-1 inSection:0];
                                                       [self.tableView scrollToRowAtIndexPath:ndxPath atScrollPosition:UITableViewScrollPositionTop  animated:NO];
                                                   }
                                                   
                                               } failure:^(NSError *error) {
                                                   [appDelegate hideHUD];
                                               }];
    
}

-(void) viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kDidReceiveChat object:nil];
    [super viewDidUnload];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayChats.count;
}

#pragma mark - Messages view delegate
- (void)sendPressed:(UIButton *)sender withText:(NSString *)text
{
    MDChat *chat=[MDChat chatWithText:text
                             activity:self.activity
                                 user:_maiduo.user];
    [JSMessageSoundEffect playMessageSentSound];
    [self.arrayChats addObject:chat];
    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicatorView.frame = CGRectMake(0.0f,  0.0f, 20.0f, 20.0f);
    [indicatorView startAnimating];
    NSString *key=[NSString stringWithFormat:@"%d",self.arrayChats.count-1];
    [self.dicAccessoryView setObject:indicatorView forKey:key];
    [self finishSend];
    
    //MDAppDelegate *appDelegate=(MDAppDelegate*)[UIApplication sharedApplication].delegate;
    //[appDelegate showHUDWithLabel:@"正在发送..."];
    [_maiduo.api sendChat:chat success:^(MDChat *chat) {
        //[appDelegate hideHUD];
        [indicatorView stopAnimating];
        [indicatorView removeFromSuperview];
        [self.dicAccessoryView removeObjectForKey:key];
        
    } failure:^(NSError *error) {
        //[appDelegate hideHUD];
        [indicatorView stopAnimating];
        [indicatorView removeFromSuperview];
        [self.dicAccessoryView removeObjectForKey:key];
        NSLog(@"fail send chat");
    }];
}

- (JSBubbleMessageStyle)messageStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MDChat *chat=self.arrayChats[indexPath.row];
    if ([chat.user equal:_maiduo.user]) {
        return JSBubbleMessageStyleOutgoingDefault;
    } else {
        return JSBubbleMessageStyleIncomingDefault;
    }
    //return (indexPath.row % 2) ? JSBubbleMessageStyleIncomingDefault : JSBubbleMessageStyleOutgoingDefault;
    //return JSBubbleMessageStyleIncomingDefault;
}

- (JSMessagesViewTimestampPolicy)timestampPolicyForMessagesView
{
    return JSMessagesViewTimestampPolicyAll;
}

- (BOOL)hasTimestampForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // custom implementation here, if using `JSMessagesViewTimestampPolicyCustom`
    return [self shouldHaveTimestampForRowAtIndexPath:indexPath];
}

#pragma mark - Messages view data source
- (NSString *)textForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"index:%d",indexPath.row);
    MDChat *chat=self.arrayChats[indexPath.row];
    return chat.text;
    //return [self.messages objectAtIndex:indexPath.row];
}
- (NSString *)photoForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MDChat *chat=self.arrayChats[indexPath.row];
    NSString *photoUrl=chat.user.avatar?chat.user.avatar:@"";
    return photoUrl;
}

-(UIView*) accessoryViewForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *key=[NSString stringWithFormat:@"%d",indexPath.row];
    UIView *accessoryView=[self.dicAccessoryView objectForKey:key];
    return accessoryView;
}

- (NSDate *)timestampForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MDChat *chat=self.arrayChats[indexPath.row];
    return chat.createAt;
    //return [self.timestamps objectAtIndex:indexPath.row];
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods
// 页面滚动时回调
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //NSLog(@"scrollViewDidScroll");
    if(scrollView.contentOffset.y < -30.0f && !_loading&&!_noMore){
        _loading=YES;
        if(!_indicatorView){
            _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            _indicatorView.frame = CGRectMake(0.0f,  0.0f, 20.0f, 20.0f);
            _indicatorView.center=CGPointMake(self.view.center.x, -15.0f);
        }
		[self.tableView addSubview:_indicatorView];
        [_indicatorView startAnimating];
        
        _currentPageIndex++;
        scrollView.contentInset=(UIEdgeInsets){35,0,0,0};
        [_maiduo.api chatsWithActivity:self.activity
                                                      page:_currentPageIndex
                                                  pageSize:kPageSize
                                                   success:^(NSArray *chats) {
                                                       _loading=NO;
                                                       if(chats.count==0){
                                                           _noMore=YES;
                                                           _currentPageIndex--;
                                                           
                                                       }else{
                                                           NSRange range = NSMakeRange(0, [chats count]);
                                                           NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
                                                           
                                                           
                                                           [self.arrayChats insertObjects:chats atIndexes:indexSet];
                                                           [self.tableView reloadData];
                                                           
                                                           NSUInteger scrollToIndex=MIN(kPageSize, chats.count);
                                                           NSIndexPath * ndxPath= [NSIndexPath indexPathForRow:scrollToIndex inSection:0];
                                                           [self.tableView scrollToRowAtIndexPath:ndxPath atScrollPosition:UITableViewScrollPositionTop  animated:NO];
                                                       }
                                                       [_indicatorView stopAnimating];
                                                       [_indicatorView removeFromSuperview];
                                                       scrollView.contentInset=UIEdgeInsetsZero;
                                                       
                                                   } failure:^(NSError *error) {
                                                       _currentPageIndex--;
                                                       [_indicatorView stopAnimating];
                                                       [_indicatorView removeFromSuperview];
                                                       _loading=NO;
                                                       scrollView.contentInset=UIEdgeInsetsZero;
                                                   }];
        
    }
    
}

// 滚动结束时回调
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    //NSLog(@"scrollViewDidEndDragging");
    
    
}
#pragma mark -
#pragma mark Customer Methods
-(void) receiveChat:(NSNotification *)note
{
    NSDictionary *dicInfo = note.userInfo;
    MDChat *chat = (MDChat *)[dicInfo objectForKey:@"object"];
    if(chat.activity.id==self.activity.id){
        [self.arrayChats addObject:chat];
        //[self.tableView reloadData];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.arrayChats.count-1 inSection:0];
        [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom  animated:NO];
    }
    //[self.tableView reloadData];
    
}


@end
