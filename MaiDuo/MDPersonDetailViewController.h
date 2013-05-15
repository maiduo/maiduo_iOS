//
//  PersonDetailViewController.h
//  MaiDuo
//
//  Created by yzf on 13-5-9.
//  Copyright (c) 2013年 魏琮举. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView/AsyncImageView.h"

@interface MDPersonDetailViewController : UIViewController
{
    UIImageView *bgImageView;     //头像背景图片
    AsyncImageView *headerImageView;   //头像
    UILabel *nameLabel;         //姓名
    UILabel *phoneLable;        //电话
}

@property (nonatomic, retain) NSArray *activity;

@end
