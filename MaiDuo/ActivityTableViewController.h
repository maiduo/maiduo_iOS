//
//  SkeletonViewController.h
//  MaiDuo
//
//  Created by 魏琮举 on 13-4-20.
//  Copyright (c) 2013年 魏琮举. All rights reserved.
//

#import <UIKit/UIKit.h>

#define VIEW_STATE_ACTIVITY 0
#define VIEW_STATE_MESSAGE  1
#define VIEW_STATE_CONTACT  2

#define CELL_IMAGE_VIEW 100

typedef enum viewState {
    ACTIVITY,
    MESSAGE,
    CONTACT
    } ViewState;

@interface ActivityTableViewController : UITableViewController {
    NSMutableArray* activities;
    NSMutableArray* messages;
    NSMutableArray* contacts;
    NSArray* data;
    NSArray* keys;
    
    NSInteger viewState;
    
    UISegmentedControl* segmented;
    UIBarButtonItem* compose;
    UIBarButtonItem* add;
}
@property (assign, nonatomic) NSInteger viewState;
@property (strong, nonatomic) NSMutableArray* activities;
@property (strong, nonatomic) NSMutableArray* messages;
@property (strong, nonatomic) NSMutableArray* contacts;
@property (strong, nonatomic) NSArray* data;

@property (strong, nonatomic) UISegmentedControl* segmented;
@property (strong, nonatomic) UIBarButtonItem* compose;
@property (strong, nonatomic) UIBarButtonItem* add;
@end
