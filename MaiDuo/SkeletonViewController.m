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
        segmentedViews = [NSArray arrayWithObjects:
                          [[ActivityViewController alloc]
                           initWithStyle: UITableViewStylePlain],
                          [[MessageViewController  alloc]
                           initWithStyle: UITableViewStylePlain],
                          [[ContactViewController  alloc]
                           initWithStyle: UITableViewStylePlain], nil];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem* btnAddActivity;
    btnAddActivity = [[UIBarButtonItem alloc]
                      initWithTitle:@"新增活动"
                      style:UIBarButtonItemStyleBordered
                      target:self
                      action:@selector(addActivity)];
    
    UISegmentedControl* segment = [[UISegmentedControl alloc]
                                   initWithItems:@[@"活动", @"消息", @"通讯录"]];
    segment.segmentedControlStyle = UISegmentedControlSegmentCenter;
    segment.selectedSegmentIndex = 0;
    [segment addTarget:self
                action:@selector(segmentedChanged:forEvent:)
             forControlEvents:UIControlEventValueChanged];

    self.navigationItem.titleView = segment;
    self.navigationItem.rightBarButtonItem = btnAddActivity;
    
    UITableViewController* viewController = [self findViewController:0];
}

- (void)addActivity
{
    
}

- (UITableViewController *)findViewController:(NSInteger)index
{
    UITableViewController* segmentViewController;
    segmentViewController = (UITableViewController *)[segmentedViews
                                                      objectAtIndex: index];
    
    return segmentViewController;
}

- (void)segmentedChanged:(id)sender forEvent:(UIEvent *)event
{
    UISegmentedControl* segmented = (UISegmentedControl *)sender;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
