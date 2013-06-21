//
//  PersonDetailViewController.h
//  MaiDuo
//
//  Created by yzf on 13-5-9.
//  Copyright (c) 2013年 魏琮举. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"
#import "MDUser.h"
#import "MDHTTPAPI.h"
#import "MaiDuo.h"

#define USER_LOGOUT @"user_logout"

@interface MDPersonDetailViewController : UITableViewController {
    MDHTTPAPI *_api;
    MaiDuo *_maiduo;
    MDUser *_user;
}

- (id)initWithUser:(MDUser *)anUser;

@end

@class MDEditViewController;

@protocol MDEditViewControllerDelegate <NSObject>

- (void)editViewControllerDidEdit:(MDEditViewController *)controller text:(NSString *)text;

@end

@interface MDEditViewController : UIViewController <UITextFieldDelegate> {
    UITextField *_textField;
}

@property (nonatomic, strong) NSString *key;
@property (nonatomic, strong) NSString *value;
@property (nonatomic, strong) NSString *hint;
@property (nonatomic, assign) id<MDEditViewControllerDelegate> delegate;

@end