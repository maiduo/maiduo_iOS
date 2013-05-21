//
//  MDActivityActView.h
//  MaiDuo
//
//  Created by WangPeng on 5/12/13.
//  Copyright (c) 2013 魏琮举. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDActivityContentView.h"

@interface MDActivityActView : MDActivityContentView <UITableViewDataSource, UITableViewDelegate> {
    UITableView *_tableView;
    NSMutableArray *_source;
}

@end
