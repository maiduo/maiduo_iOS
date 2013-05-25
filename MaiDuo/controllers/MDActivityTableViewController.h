//
//  SkeletonViewController.h
//  MaiDuo
//
//  Created by 魏琮举 on 13-4-20.
//  Copyright (c) 2013年 魏琮举. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDActivity.h"
#import "MDUserManager.h"

#define VIEW_STATE_ACTIVITY 0
#define VIEW_STATE_MESSAGE  1
#define VIEW_STATE_CONTACT  2

#define CELL_IMAGE_VIEW 100

typedef enum MDActivityViewState {
    MDActivityViewStateMessage,
    MDActivityViewStateChat,
    MDActivityViewStateContact
} MDActivityViewState;

@interface MDActivityTableViewController : UIViewController {
    MDUser *_user;
}

@property (strong) MDActivity *activity;

-(id)initWithActivity:(MDActivity *)anActivity;

@end
