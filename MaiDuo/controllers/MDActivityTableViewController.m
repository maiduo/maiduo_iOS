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

@interface MDActivityTableViewController () {
    MDActivityMessageView *_messageView;
    MDActivityContactView *_contactView;
    UIView *_chatView;
    UIView *_currentContentView;
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
            }
            _currentContentView = _messageView;
            rightBarButtonItem = [self barButtonItemMessage:_messageView];
            break;
        case MDActivityViewStateChat:
            if (_chatView==nil) {
                self.chatViewController = [[MDActivityChatViewController alloc] init];
                _mesVC.activity=self.activity;
                _chatView=_mesVC.view;
                _chatView.autoresizingMask = autoresizing;
            }
            _currentContentView = _chatView;
            rightBarButtonItem = nil;
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
            target:view
            action:@selector(rightBarAction)];
}

- (void)segmentedChanged:(id)sender forEvent:(UIEvent *)event
{
    [self showViewState:_segmented.selectedSegmentIndex];
}
@end
