//
//  MDCreateActivityViewController.m
//  MaiDuo
//
//  Created by 魏琮举 on 13-5-18.
//  Copyright (c) 2013年 魏琮举. All rights reserved.
//

#import "MDCreateActivityViewController.h"

@interface MDCreateActivityViewController ()

@end

@implementation MDCreateActivityViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"建立新的活动";
    
    UIBarButtonItem *confirm = [[UIBarButtonItem alloc]
                                initWithTitle:@"建立"
                                style:UIBarButtonItemStyleBordered
                                target:self
                                action:@selector(didClickConfirm:)];
    self.navigationItem.rightBarButtonItem = confirm;
    
    CGRect rect = CGRectMake(0, 0, self.view.bounds.size.width,
                             self.view.bounds.size.height);
    _createActivityView = [[MDCreateActivityView alloc]initWithFrame:rect];
    self.view = _createActivityView;
}

- (void)didClickConfirm:(id)sender
{
    MDActivity *activity;
    activity = [MDActivity
                activityWithSubject:[_createActivityView activitySubject]];

    MDAppDelegate *app = [[UIApplication sharedApplication] delegate];
    [app showHUDWithLabel:@"发送数据 ..."];
    
    MDHTTPAPI *api = [[YaabUser sharedInstance] api];
    [api createActivity:activity success:^(MDActivity *anActivity) {
        [app hideHUD];
        [self.navigationController popViewControllerAnimated:YES];
        if ([self.createActivityDelegate
             respondsToSelector:@selector(didCreateActivity:)]) {
            [self.createActivityDelegate didCreateActivity:anActivity];
        }
        
    } failure:^(NSError *error) {
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
