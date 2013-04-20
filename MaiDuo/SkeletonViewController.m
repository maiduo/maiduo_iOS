//
//  SkeletonViewController.m
//  MaiDuo
//
//  Created by 魏琮举 on 13-4-20.
//  Copyright (c) 2013年 魏琮举. All rights reserved.
//

#import "SkeletonViewController.h"

#import "ActivityViewController.h"
#import "MessageViewController.h"
#import "ContactViewController.h"

@interface SkeletonViewController ()

@end

@implementation SkeletonViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (id)initWithActivity:(NSMutableArray *)activity
{
    self = [super init];
    if (self) {
//        self.activity = activity;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//	skeleton = [[UITabBarController alloc] init];
//    [skeleton setViewControllers:
//     [NSArray arrayWithObjects:
//      [[ActivityViewController alloc] init],
//      [[MessageViewController  alloc] init],
//      [[ContactViewController  alloc] init], nil]];
    
//    UISegmentedControl* segment = [[UISegmentedControl alloc]
//                                   initWithItems:@[@"活动", @"消息", @"通讯录"]];
//    segment.segmentedControlStyle = UISegmentedControlSegmentCenter;
//    self.navigationItem.titleView = segment;
//    [self.view addSubview:skeleton.view];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
