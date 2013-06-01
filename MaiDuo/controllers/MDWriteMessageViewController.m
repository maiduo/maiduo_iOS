//
//  SendMessageTableViewController.m
//  MaiDuo
//
//  Created by 魏琮举 on 13-4-26.
//  Copyright (c) 2013年 魏琮举. All rights reserved.
//

#import "MDWriteMessageViewController.h"
#import "MDAddonViewController.h"
#import <UIImageView+AFNetworking.h>
#import <QuartzCore/QuartzCore.h>

#define TOOL_BAR_HEIGHT 44
#define TOOL_BAR_NORMAL_FRAME CGRectMake(0, 156, 320, TOOL_BAR_HEIGHT)


@interface MDWriteMessageViewController () {
}
@end
@implementation MDWriteMessageViewController

- (id)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithUser:(MDUser *)anUser
{
    self = [self init];
    return self;
}

- (void)setup
{
    self.navigationItem.title = @"新消息";
    
    UIBarButtonItem *send = [[UIBarButtonItem alloc]
                             initWithTitle:@"发布"
                             style:UIBarButtonItemStyleBordered
                             target:self
                             action:@selector(didTapPublish:)];
    UIBarButtonItem *close = [[UIBarButtonItem alloc]
                              initWithTitle:@"取消"
                              style:UIBarButtonItemStyleBordered
                              target:self
                              action:@selector(didTapClose:)];
    
    self.navigationItem.rightBarButtonItem = send;
    self.navigationItem.leftBarButtonItem = close;
    
    CGFloat edge = 10.0f;
    CGFloat avatar_width = 60.0f;
    CGFloat avatar_height = 60.0f;
    CGFloat text_field_x = edge + avatar_width;
    CGFloat view_width = self.view.bounds.size.width;
    CGFloat view_height = self.view.bounds.size.height;
    CGFloat text_field_width = view_width - text_field_x;
    CGFloat text_field_height = view_height - TOOL_BAR_HEIGHT - edge;
    
    
    _user = [[MDUserManager sharedInstance] getUserSession];
    _avatar = [[UIImageView alloc] initWithFrame:CGRectMake(edge, edge,
                                                            avatar_width,
                                                            avatar_height)];
    [_avatar setImageWithURL:[NSURL URLWithString:[_user avatar]]
            placeholderImage:[UIImage imageNamed:@"default_avatar"]];
    
    [self.view addSubview:_avatar];
    
    _textField = [[MDUITextView alloc]
                     initWithFrame:CGRectMake(text_field_x, edge,
                                              text_field_width,
                                              text_field_height)];
    _textField.font = [UIFont systemFontOfSize:16.0f];
    [self.view addSubview: _textField];
    _textField.placeholder = @"想说点什么呢？";
    
    id center = [NSNotificationCenter defaultCenter];
	[center addObserver:self
               selector:@selector(keyboardWillShow:)
                   name:UIKeyboardWillShowNotification
                 object:nil];
	[center addObserver:self
               selector:@selector(keyboardWillHide:)
                   name:UIKeyboardWillHideNotification
                 object:nil];
    // 键盘切换事件
    [center addObserver:self selector:@selector(keyboardWillShow:)
                   name:UIKeyboardWillShowNotification object:nil];
    
    
    // Toolbar
#define TOOLBAR_Y view_height - TOOL_BAR_HEIGHT - 44
    _toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, TOOLBAR_Y,
                                                           view_width,
                                                           TOOL_BAR_HEIGHT)];
    [self.view addSubview: _toolbar];
    
    UIBarButtonItem *camera;
    camera = [[UIBarButtonItem alloc]
              initWithBarButtonSystemItem:UIBarButtonSystemItemCamera
              target:self
              action:@selector(photo:)];
    UIBarButtonItem *flexItem=[[UIBarButtonItem alloc]
                               initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                               target:nil
                               action:nil];
    _toolbar.items = @[camera,flexItem,];
    
    // 导航栏进度条
    static NSString *uploading = @"正在上传中...";
    static NSInteger padding = 5;
    UIFont *font = [UIFont systemFontOfSize:13];
    CGSize size = [uploading sizeWithFont:font];
    _navigationProgressBar = [[UIView alloc]
                              initWithFrame:CGRectMake(0, padding, 160,44)];
    _navigationProgressBar.center = self.navigationController.view.center;
    _navigationProgressLabel = [[UILabel alloc]
                                initWithFrame:CGRectMake((_navigationProgressBar.width - size.width)/2, padding, size.width, size.height)];
    _navigationProgressLabel.backgroundColor = [UIColor clearColor];
    _navigationProgressLabel.font = font;
    _navigationProgressLabel.textColor = [UIColor whiteColor];
    _navigationProgressLabel.shadowColor = [UIColor colorWithWhite:0.1
                                                             alpha:0.7];

    _navigationProgressLabel.text = uploading;
    
    [_navigationProgressBar addSubview: _navigationProgressLabel];
    
    _navigationProgress = [[UIProgressView alloc]
                           initWithProgressViewStyle:UIProgressViewStyleBar];
    CGRect progress_frame = _navigationProgress.frame;
    _navigationProgress.frame = CGRectMake(0, _navigationProgressLabel.frame.origin.y + _navigationProgressLabel.frame.size.height + padding, progress_frame.size.width, progress_frame.size.height);
    [_navigationProgressBar addSubview:_navigationProgress];
    
    NSString *photos_text = @"13";
    CGSize photo_text_size = [photos_text sizeWithFont:[UIFont systemFontOfSize:14]];
    
    _photos = [[UILabel alloc] initWithFrame:CGRectMake(30, _toolbar.frame.origin.y, photo_text_size.width + 12, 20)];
    _photos.backgroundColor=[UIColor colorWithRed:170/255
                                            green:176/255
                                             blue:198/255
                                            alpha:0.7];
    _photos.textColor=[UIColor whiteColor];
    _photos.font=[UIFont systemFontOfSize:14.0f];
    _photos.text = photos_text;
    _photos.textAlignment=NSTextAlignmentCenter;
    _photos.layer.shadowColor=[UIColor blackColor].CGColor;
    _photos.layer.shadowOffset=CGSizeMake(5, 5);
    _photos.layer.cornerRadius=10.0f;
    
    [self.view addSubview:_photos];
//    CGRect camera_rect = camera
}

- (void) keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *info = [notification userInfo];
    CGFloat kbHeight = [[info objectForKey:UIKeyboardFrameEndUserInfoKey]
                        CGRectValue].size.height;
    
    NSInteger navigationBarHeight = self.navigationController.navigationBar.height;
    CGRect newRect = _textField.frame;
    newRect.size.height = self.view.frame.size.height - kbHeight - 10
                          - navigationBarHeight;
    
    _textField.frame = newRect;
    
    [UIView animateWithDuration:0.25 animations:^{
        CGPoint center = _toolbar.center;
        center.y = self.view.frame.size.height - 22 - kbHeight;
        _toolbar.center = center;
    }];
}

- (void) keyboardWillHide:(NSNotification *)notification
{
    NSDictionary *info = [notification userInfo];
    CGFloat kbHeight = [[info objectForKey:UIKeyboardFrameEndUserInfoKey]
                        CGRectValue].size.height;
}

- (void)enableNavigationProgress
{
    
}

- (void)disableNavigationProgress
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController
     pushViewController:[[MDAddonViewController alloc] init] animated:YES];
}

- (void)didTapClose:(id)sender
{
}

- (void)didTapPublish:(id)sender
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end;