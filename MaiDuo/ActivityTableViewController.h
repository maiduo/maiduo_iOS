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

typedef enum viewState {
    ACTIVITY,
    MESSAGE,
    CONTACT
    } ViewState;

@interface SkeletonViewController : UITableViewController {
    NSMutableArray* activities;
    NSMutableArray* messages;
    NSMutableArray* contacts;
    NSArray* data;
    
    NSInteger viewState;
}

@end
