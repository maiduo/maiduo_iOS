//
//  RegisterViewController.h
//  MaiDuo
//
//  Created by D on 13-5-10.
//  Copyright (c) 2013年 魏琮举. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MDRegisterViewController : UIViewController
                                    <UITableViewDataSource,
                                    UITableViewDelegate,
                                    UITextFieldDelegate>

@property (nonatomic, retain) UITableView *myTableView;
@property (nonatomic, retain) NSArray *myPlaceHolder;
@end
