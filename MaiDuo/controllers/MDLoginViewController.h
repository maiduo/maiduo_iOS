//
//  LoginViewController.h
//  MaiDuo
//
//  Created by 高 欣 on 13-5-10.
//  Copyright (c) 2013年 魏琮举. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MDLoginViewController;

@protocol MDLoginViewControllerDelegate <NSObject>

- (void)loginViewControllerDidLogin:(MDLoginViewController *)loginViewController;

@end

@interface MDLoginViewController : UITableViewController<UITextFieldDelegate>

@property (nonatomic, assign) id<MDLoginViewControllerDelegate> delegate;

@end
