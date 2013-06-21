//
//  MDCreateActivityViewController.h
//  MaiDuo
//
//  Created by 魏琮举 on 13-5-18.
//  Copyright (c) 2013年 魏琮举. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDHTTPAPI.h"
#import "MaiDuo.h"
#import "MDCreateActivityView.h"
#import "MDLatestViewController.h"
#import "MDAppDelegate.h"
#import "MDCreateActivityDelegate.h"

typedef void(^DidCreateActivityBlock)(MDActivity *anActivity);
typedef void(^DidReceiveFailureBlock)(NSError *aError);

@interface MDCreateActivityViewController : UIViewController {
    MDCreateActivityView *_createActivityView;
}

@property (nonatomic, weak) id<MDCreateActivityDelegate> createActivityDelegate;
@end
