//
//  MDActivityMesViewController.m
//  MaiDuo
//
//  Created by 高 欣 on 13-5-15.
//  Copyright (c) 2013年 魏琮举. All rights reserved.
//

#import "MDActivityMesViewController.h"
#import "MDChat.h"
#import "MDUserManager.h"
#import "MDHTTPAPI.h"
#import "YaabUser.h"
#import "MDAppDelegate.h"

#define chatIDKey @"chat_id"
#define chatTextKey @"text"
#define timeStampsKey @"created_at"

@interface MDActivityMesViewController (){
    NSUInteger _currentPageIndex;
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
    
    //self.title = @"Messages";
    
//    self.messages = [[NSMutableArray alloc] initWithObjects:
//                     @"Testing some messages here.",
//                     @"This work is based on Sam Soffes' SSMessagesViewController.",
//                     @"This is a complete re-write and refactoring.",
//                     @"It's easy to implement. Sound effects and images included. Animations are smooth and messages can be of arbitrary size!",
//                     nil];
//    
//    self.timestamps = [[NSMutableArray alloc] initWithObjects:
//                       [NSDate distantPast],
//                       [NSDate distantPast],
//                       [NSDate distantPast],
//                       [NSDate date],
//                       nil];
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
    	    [self.tableView scrollToRowAtIndexPath:ndxPath atScrollPosition:UITableViewScrollPositionTop  animated:YES];
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
    return self.arrayChats.count;
}

#pragma mark - Messages view delegate
- (void)sendPressed:(UIButton *)sender withText:(NSString *)text
{
   
    
    [JSMessageSoundEffect playMessageSentSound];
    
    MDChat *chat=[MDChat chatWithText:text activity:self.activity user:[[MDUserManager sharedInstance] getUserSession]];
    
    MDAppDelegate *appDelegate=(MDAppDelegate*)[UIApplication sharedApplication].delegate;
    [appDelegate showHUDWithLabel:@"正在发送..."];
    [[[YaabUser sharedInstance] api] sendChat:chat success:^(MDChat *chat) {
        [appDelegate hideHUD];
        
         
        [self.arrayChats addObject:chat];
        
//        [self.messages addObject:text];
//        [self.timestamps addObject:[NSDate date]];
        [self finishSend];
    } failure:^(NSError *error) {
        [appDelegate hideHUD];
        NSLog(@"fail send chat");
    }];
        
    
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
    MDChat *chat=self.arrayChats[indexPath.row];
    return chat.text;
    //return [self.messages objectAtIndex:indexPath.row];
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
    MDChat *chat=self.arrayChats[indexPath.row];
    return chat.createAt;
    //return [self.timestamps objectAtIndex:indexPath.row];
}
@end
