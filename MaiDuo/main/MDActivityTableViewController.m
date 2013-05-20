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
#import "MDActivityContactView.h"
#import "MDActivityMesView.h"
#import "MDActivityMesViewController.h"

@interface MDActivityTableViewController () {
    MDActivityActView *_actView;
    MDActivityContactView *_conView;
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
    
    CGRect rectangle = self.view.bounds;
    UIViewAutoresizing autoresizing = UIViewAutoresizingFlexibleHeight |
                         UIViewAutoresizingFlexibleWidth;
    
    switch (_viewState) {
        case MDActivityViewStateAct:
            if (_actView==nil) {
                _actView = [[MDActivityActView alloc] initWithFrame:rectangle];
                _actView.autoresizingMask = autoresizing;
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
                _mesView.autoresizingMask = autoresizing;
            }
            _currentContentView = _mesView;
            self.navigationItem.rightBarButtonItem = nil;
            break;
        case MDActivityViewStateCon:
            if (_conView==nil) {
                _conView = [[MDActivityContactView alloc]
                            initWithActivity:self.activity];
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
@end
