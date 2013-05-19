//
//  MDActivityMesViewController.m
//  MaiDuo
//
//  Created by 高 欣 on 13-5-15.
//  Copyright (c) 2013年 魏琮举. All rights reserved.
//

#import "MDActivityMesViewController.h"
#import "MDAppDelegate.h"
#import "MDUserManager.h"
@interface MDActivityMesViewController (){
    NSUInteger _currentPageIndex;
    BOOL _loading;
    UIActivityIndicatorView *_indicatorView;
}

@property (strong,nonatomic) NSMutableArray *arrayChats;
@end

@implementation MDActivityMesViewController
#pragma mark - Initialization
- (UIButton *)sendButton
{
    // Override to use a custom send button
    // The button's frame is set automatically for you
    return [UIButton defaultSendButton];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.delegate = self;
    self.dataSource = self;
    
    self.title = @"Messages";
    
    self.arrayChats=[NSMutableArray array];
    MDAppDelegate *appDelegate=(MDAppDelegate*)[UIApplication sharedApplication].delegate;
    [appDelegate showHUDWithLabel:@"正在获取聊天..."];
    [[[YaabUser sharedInstance] api] chatsWithActivity:self.activity
                                                 page:_currentPageIndex+1
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messages.count;
}

#pragma mark - Messages view delegate
- (void)sendPressed:(UIButton *)sender withText:(NSString *)text
{
    [self.messages addObject:text];
    
    [self.timestamps addObject:[NSDate date]];
    
    if((self.messages.count - 1) % 2)
        [JSMessageSoundEffect playMessageSentSound];
    else
        [JSMessageSoundEffect playMessageReceivedSound];
    
    [self finishSend];
}

- (JSBubbleMessageStyle)messageStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MDChat *chat=self.arrayChats[indexPath.row];
    if([chat.user.username isEqualToString:[[MDUserManager sharedInstance] getUserSession].username]){
        return JSBubbleMessageStyleOutgoingDefault;
    }else{
        return JSBubbleMessageStyleIncomingDefault;
    }
    //return (indexPath.row % 2) ? JSBubbleMessageStyleIncomingDefault : JSBubbleMessageStyleOutgoingDefault;
    //return JSBubbleMessageStyleIncomingDefault;
}

- (JSMessagesViewTimestampPolicy)timestampPolicyForMessagesView
{
    return JSMessagesViewTimestampPolicyEveryThree;
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
}
- (NSString *)photoForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *photoUrl=[NSString stringWithFormat:@"photo%d",indexPath.row%2];
    MDChat *chat=self.arrayChats[indexPath.row];
    if([chat.user.username isEqualToString:[[MDUserManager sharedInstance] getUserSession].username]){
        photoUrl=@"photo0";
    }else{
        photoUrl=@"photo1";
    }
    return photoUrl;
}
- (NSDate *)timestampForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.timestamps objectAtIndex:indexPath.row];
}


#pragma mark -
#pragma mark UIScrollViewDelegate Methods
// 页面滚动时回调
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //NSLog(@"scrollViewDidScroll");
    if(scrollView.contentOffset.y < -10.0f && !_loading){
        _loading=YES;
        if(!_indicatorView){
            _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            _indicatorView.frame = CGRectMake(0.0f,  0.0f, 20.0f, 20.0f);
            _indicatorView.center=CGPointMake(self.view.center.x, -15.0f);
        }
		[self.tableView addSubview:_indicatorView];
        [_indicatorView startAnimating];
        
        _currentPageIndex++;
        [[[YaabUser sharedInstance] api] chatsWithActivity:self.activity
                                                      page:_currentPageIndex+1
                                                   success:^(NSArray *chats) {
                                                       
                                                       NSRange range = NSMakeRange(0, [chats count]);
                                                       NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
                                                       
                                                       
                                                       [self.arrayChats insertObjects:chats atIndexes:indexSet];
                                                       [self.tableView reloadData];
                                                       [_indicatorView stopAnimating];
                                                       [_indicatorView removeFromSuperview];
                                                       _loading=NO;
                                                       
                                                   } failure:^(NSError *error) {
                                                       _currentPageIndex--;
                                                       [_indicatorView stopAnimating];
                                                       [_indicatorView removeFromSuperview];
                                                       _loading=NO;
                                                   }];
        
    }
    
}

// 滚动结束时回调
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    //NSLog(@"scrollViewDidEndDragging");
    
    
}
@end
