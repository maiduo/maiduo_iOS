//
//  SkeletonViewController.m
//  MaiDuo
//
//  Created by 魏琮举 on 13-4-20.
//  Copyright (c) 2013年 魏琮举. All rights reserved.
//

#import "MDActivityTableViewController.h"
#import "AsyncImageView.h"
#import "MDActivityMessageView.h"
#import "MDActivityContactView.h"
#import "MDActivityChatViewController.h"
#import "MDWriteMessageViewController.h"
#import <QuartzCore/QuartzCore.h>

#define kActNumRect (CGRect){42,2,14,14}
#define kActMesRect (CGRect){124,2,14,14}
#define kChatNumRect (CGRect){176,2,14,14}
#define kDidReceiveMessage @"didReceiveMessage"
#define kDidReceiveChat @"didReceiveChat"
#define kDidReceiveActivity @"didReceiveActivity"
@interface MDActivityTableViewController () {
    MDActivityMessageView *_messageView;
    MDActivityContactView *_contactView;
    UIView *_chatView;
    UIView *_currentContentView;
    
    UILabel *_lblOtherNum;
    UILabel *_lblMesNum;
    UILabel *_lblChatNum;
    
    NSUInteger _otherNum;
    NSUInteger _mesNum;
    NSUInteger _chatNum;
    
}

@property (assign, nonatomic) MDActivityViewState viewState;
@property (strong, nonatomic) UISegmentedControl* segmented;
@property (strong, nonatomic) MDActivityChatViewController *chatViewController;

@end

@implementation MDActivityTableViewController

-(id)initWithActivity:(MDActivity *)anActivity
{
    self = [self init];
    if (self) {
        self.activity = anActivity;
        _user = [[MDUserManager sharedInstance] getUserSession];
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
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addNewActNum:) name:kDidReceiveActivity object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addNewMesNum:) name:kDidReceiveMessage object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addNewChatNum:) name:kDidReceiveChat object:nil];
    
    
    _segmented = [[UISegmentedControl alloc]
                  initWithItems:@[@"消息", @"聊天", @"通讯录"]];
    _segmented.segmentedControlStyle = UISegmentedControlSegmentCenter;
    _segmented.selectedSegmentIndex = 0;
    [_segmented addTarget:self
                   action:@selector(segmentedChanged:forEvent:)
         forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = _segmented;
    
    [self showViewState:MDActivityViewStateMessage];
    
}
-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    UINavigationBar *navBar=self.navigationController.navigationBar;
    if(!_lblOtherNum){
        _lblOtherNum = [[UILabel alloc] initWithFrame:kActNumRect];
        [self initLabel:_lblOtherNum];
        _lblOtherNum.hidden=YES;
    }
    if(!_lblMesNum){
        _lblMesNum = [[UILabel alloc] initWithFrame:kActMesRect];
        [self initLabel:_lblMesNum];
    }
    if(!_lblChatNum){
        _lblChatNum = [[UILabel alloc] initWithFrame:kChatNumRect];
        [self initLabel:_lblChatNum];
    }
    
    [_lblOtherNum sizeToFit];
    [_lblMesNum sizeToFit];
    [_lblChatNum sizeToFit];
    [navBar addSubview:_lblOtherNum];
    [navBar addSubview:_lblMesNum];
    [navBar addSubview:_lblChatNum];
}

//-(void) viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    
//    UINavigationBar *navBar=self.navigationController.navigationBar;
//    if(!_lblOtherNum){
//        _lblOtherNum = [[UILabel alloc] initWithFrame:kActNumRect];
//        [self initLabel:_lblOtherNum];
//    }
//    if(!_lblChatNum){
//        _lblChatNum = [[UILabel alloc] initWithFrame:kChatNumRect];
//        [self initLabel:_lblChatNum];
//    }
//    
//    _lblOtherNum.text=[NSString stringWithFormat:@" %d ",4];
//    _lblChatNum.text=[NSString stringWithFormat:@" %d ",55];
//    [_lblOtherNum sizeToFit];
//    [_lblChatNum sizeToFit];
//    [navBar addSubview:_lblOtherNum];
//    [navBar addSubview:_lblChatNum];
//}
-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_lblOtherNum removeFromSuperview];
    [_lblMesNum removeFromSuperview];
    [_lblChatNum removeFromSuperview];
}
-(void) viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kDidReceiveActivity object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kDidReceiveMessage object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kDidReceiveChat object:nil];
    [super viewDidUnload];
}
#pragma mark -
#pragma mark Customer Methods

//-(void) addNewActNum:(NSNotification*) note
//{
//    [self setLabel:_lblMesNum Num:++_otherNum];
//}


-(void) addNewMesNum:(NSNotification*) note
{
    //如果当前页面不是消息页面才加上消息提示
    NSDictionary *dicInfo = note.userInfo;
    MDMessage *mes = (MDMessage *)[dicInfo objectForKey:@"object"];
    if(mes.activity.id==self.activity.id){
        if(_segmented.selectedSegmentIndex!=MDActivityViewStateMessage){
            [self setLabel:_lblMesNum Num:++_chatNum];
        }
    }else{
        [self setLabel:_lblOtherNum Num:++_otherNum];
    }
}

-(void) addNewChatNum:(NSNotification*) note
{
    //如果当前页面不是聊天页面才加上聊天提示
    NSDictionary *dicInfo = note.userInfo;
    MDChat *chat = (MDChat *)[dicInfo objectForKey:@"object"];
    if(chat.activity.id==self.activity.id){
        if(_segmented.selectedSegmentIndex!=MDActivityViewStateChat){
            [self setLabel:_lblChatNum Num:++_chatNum];
        }
    }else{
         [self setLabel:_lblOtherNum Num:++_otherNum];
    }
}

- (void) setLabel:(UILabel*) label Num:(NSUInteger) num
{
    NSString *text=[NSString stringWithFormat:@" %d ",num];    
    label.hidden=num==0?YES:NO;
    label.text=text;
    [label sizeToFit];
}
- (void) initLabel:(UILabel*) label
{
    label.layer.cornerRadius=7.0f;
    
    //lblNum.backgroundColor=[UIColor redColor];
    label.backgroundColor=[UIColor colorWithRed:230/255.0 green:0 blue:25/255.0 alpha:1.0];
    label.textColor=[UIColor whiteColor];
    label.font=[UIFont systemFontOfSize:14.0f];
    label.textAlignment=NSTextAlignmentCenter;
    
    
    label.layer.shadowColor=[UIColor blackColor].CGColor;
    label.layer.shadowOffset=CGSizeMake(5, 5);
}

- (void)showViewState:(MDActivityViewState)viewState
{
    _viewState = viewState;
    [_currentContentView removeFromSuperview];
    
    CGRect rectangle = self.view.bounds;
    UIViewAutoresizing autoresizing = UIViewAutoresizingFlexibleHeight |
                                      UIViewAutoresizingFlexibleWidth;
    UIBarButtonItem *rightBarButtonItem;
    
    switch (_viewState) {
        case MDActivityViewStateMessage:
            if (_messageView==nil) {
                _messageView = [[MDActivityMessageView alloc] initWithFrame:rectangle];
                _messageView.autoresizingMask = autoresizing;
                _messageView.viewController = self;
                _messageView.activity = self.activity;
            }
            _currentContentView = _messageView;
            rightBarButtonItem = [self barButtonItemMessage:_messageView];
            _mesNum=0;
            _lblMesNum.hidden=YES;
            break;
        case MDActivityViewStateChat:
            if (_chatView==nil) {
                self.chatViewController = [[MDActivityChatViewController alloc] init];
                self.chatViewController.activity=self.activity;
                _chatView=self.chatViewController.view;
                _chatView.autoresizingMask = autoresizing;
            }
            _currentContentView = _chatView;
            rightBarButtonItem = nil;
            _chatNum=0;
            _lblChatNum.hidden=YES;
            
            break;
        case MDActivityViewStateContact:
            if (_contactView==nil) {
                _contactView = [[MDActivityContactView alloc]
                                initWithActivity:self.activity];
                _contactView.frame = rectangle;
                
                _contactView.viewController = self;
            }
            _currentContentView = _contactView;
            
            rightBarButtonItem = [self barButtonItemInvite:_contactView];
        default:
            break;
    }
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    _currentContentView.frame=self.view.bounds;
    [self.view addSubview:_currentContentView];
}

- (UIBarButtonItem *)barButtonItemInvite:(MDActivityContactView *)view
{
    if ([self.activity.owner equal:_user]) {
        return [[UIBarButtonItem alloc]
                initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                target:view
                action:@selector(rightBarAction)];
    } else
        return NO;
}

- (UIBarButtonItem *)barButtonItemMessage:(MDActivityMessageView *)view
{
    return [[UIBarButtonItem alloc]
            initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
            target:self
            action:@selector(didActiveWriteMessage:)];
}

- (void)segmentedChanged:(id)sender forEvent:(UIEvent *)event
{
    [self showViewState:_segmented.selectedSegmentIndex];
}

- (void)didActiveWriteMessage:(id)sender
{
    UINavigationController *naviCtrl;
    MDWriteMessageViewController *msgCtrl;
    msgCtrl = [[MDWriteMessageViewController alloc] init];
    naviCtrl = [[UINavigationController alloc]
                initWithRootViewController:msgCtrl];
    [self presentModalViewController:naviCtrl animated:YES];
}
@end
