//
//  MDActivityMesView.m
//  MaiDuo
//
//  Created by WangPeng on 5/12/13.
//  Copyright (c) 2013 魏琮举. All rights reserved.
//

#import "MDActivityMesView.h"

@interface MDActivityMesView (){
    
}
@property (strong, nonatomic) NSMutableArray *messages;
@property (strong, nonatomic) NSMutableArray *timestamps;
@property (strong, nonatomic) JSMessagesViewController *messageCV;
@end
@implementation MDActivityMesView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.messages = [[NSMutableArray alloc] initWithObjects:
                         @"Testing some messages here.",
                         @"This work is based on Sam Soffes' SSMessagesViewController.",
                         @"This is a complete re-write and refactoring.",
                         @"It's easy to implement. Sound effects and images included. Animations are smooth and messages can be of arbitrary size!",
                         nil];
        
        self.timestamps = [[NSMutableArray alloc] initWithObjects:
                           [NSDate distantPast],
                           [NSDate distantPast],
                           [NSDate distantPast],
                           [NSDate date],
                           nil];
        
        
        
        self.messageCV=[[JSMessagesViewController alloc] init];
        
        _messageCV.dataSource=self;
        _messageCV.delegate=self;
        _messageCV.view.frame=self.bounds;
        [self addSubview:_messageCV.view];
        //[_messageCV setup];
        //[_messageCV.tableView reloadData];
        
    }
    return self;
}

#pragma mark - Initialization
- (UIButton *)sendButton
{
    // Override to use a custom send button
    // The button's frame is set automatically for you
    return [UIButton defaultSendButton];
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
    
    [_messageCV finishSend];
}

- (JSBubbleMessageStyle)messageStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (indexPath.row % 2) ? JSBubbleMessageStyleIncomingDefault : JSBubbleMessageStyleOutgoingDefault;
}

- (JSMessagesViewTimestampPolicy)timestampPolicyForMessagesView
{
    return JSMessagesViewTimestampPolicyEveryThree;
}

- (BOOL)hasTimestampForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // custom implementation here, if using `JSMessagesViewTimestampPolicyCustom`
    return [_messageCV shouldHaveTimestampForRowAtIndexPath:indexPath];
}

#pragma mark - Messages view data source
- (NSString *)textForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.messages objectAtIndex:indexPath.row];
}
- (NSString *)photoForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *photoUrl=[NSString stringWithFormat:@"photo%d",indexPath.row%2];
    
    return photoUrl;
}
- (NSDate *)timestampForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.timestamps objectAtIndex:indexPath.row];
}

- (void)rightBarAction
{
    
}

@end
