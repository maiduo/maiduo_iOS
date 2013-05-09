//
//  PersonDetailViewController.m
//  MaiDuo
//
//  Created by yzf on 13-5-9.
//  Copyright (c) 2013年 魏琮举. All rights reserved.
//

#import "PersonDetailViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface PersonDetailViewController ()

@end

@implementation PersonDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"个人资料";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
                                             initWithTitle:@"返回"
                                             style:UIBarButtonItemStylePlain
                                             target:self
                                             action:@selector(backView)];
    NSLog(@"%@",_activity);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self initSubView];
}

//初始化控件
- (void)initSubView
{
    NSString *uid = [_activity objectAtIndex:0];
    NSString *name = (NSString *)[_activity objectAtIndex:1];
    bgImageView = [[UIImageView alloc]
                                initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
    headerImageView = [[AsyncImageView alloc]
                                    initWithFrame:CGRectMake(100, 40, 120, 100)];
    headerImageView.contentMode = UIViewContentModeScaleAspectFill;
    headerImageView.clipsToBounds = YES;
    nameLabel = [[UILabel alloc]
                 initWithFrame:CGRectMake(100, 140, 120, 20)];
    [nameLabel setText:name];
    [nameLabel setTextAlignment:UITextAlignmentCenter];
    [nameLabel setBackgroundColor:[UIColor clearColor]];
    [bgImageView addSubview:headerImageView];
    [self.view addSubview:bgImageView];
    [self.view addSubview:nameLabel];
//    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:headerImageView];
    static NSString* image_url;
    image_url = @"http://oss.aliyuncs.com/maiduo/%@.jpg";
    headerImageView.imageURL = [NSURL URLWithString:
                                [NSString stringWithFormat:image_url, uid]];
    
    UIView *phoneView = [[UIView alloc]
                         initWithFrame:CGRectMake(10, 220, 300, 40)];
    UILabel *lable = [[UILabel alloc]
                      initWithFrame:CGRectMake(0, 0, 80, 40)];
    [lable setText:@"电话"];
    phoneLable = [[UILabel alloc]
                  initWithFrame:CGRectMake(40, 0, 220, 40)];
    [phoneLable setText:@"18600050804"];
    [phoneLable setTextAlignment:UITextAlignmentCenter];
    [phoneView addSubview:lable];
    [phoneView addSubview:phoneLable];
    [self.view addSubview:phoneView];
}


- (void)backView
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
