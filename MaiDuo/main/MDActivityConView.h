//
//  MDActivityConView.h
//  MaiDuo
//
//  Created by WangPeng on 5/12/13.
//  Copyright (c) 2013 魏琮举. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDActivityContentView.h"

@interface MDActivityConView : MDActivityContentView <UITableViewDelegate, UITableViewDataSource> {
    UITableView *_tableView;
    NSMutableArray *_source;
}

@end
