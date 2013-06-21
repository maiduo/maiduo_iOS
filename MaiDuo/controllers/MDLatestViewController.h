//
//  LatestViewController.h
//  MaiDuo
//
//  Created by 魏琮举 on 13-4-19.
//  Copyright (c) 2013年 魏琮举. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDHTTPAPI.h"
#import "MaiDuo.h"
#import "EGORefreshTableHeaderView.h"
#import "MDCreateActivityDelegate.h"
#import "MDLoginViewController.h"
#import "MDPersonDetailViewController.h"

@interface MDLatestViewController : UIViewController<UITableViewDataSource,
UITableViewDelegate, MDCreateActivityDelegate> {
    NSMutableArray* activities;
    MDHTTPAPI *_api;
}

- (void)refresh;

@end
