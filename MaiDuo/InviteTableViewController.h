//
//  InviteTableViewController.h
//  MaiDuo
//
//  Created by 魏琮举 on 13-4-21.
//  Copyright (c) 2013年 魏琮举. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InviteTableViewController : UITableViewController {
    NSMutableArray* group;
    NSArray* letters;
}

@property (nonatomic, strong) NSArray* addresses;

@end
