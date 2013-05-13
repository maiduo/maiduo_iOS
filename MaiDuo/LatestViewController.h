//
//  LatestViewController.h
//  MaiDuo
//
//  Created by 魏琮举 on 13-4-19.
//  Copyright (c) 2013年 魏琮举. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"

@interface LatestViewController : UIViewController<UITableViewDataSource,
UITableViewDelegate> {
    NSArray* activities;
    
    EGORefreshTableHeaderView *refreshHeaderView;
    BOOL reloading;
}
@end
