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
    
    NSLog(@"%f", text_field_height);
    
    _textField = [[MDUITextView alloc]
                     initWithFrame:CGRectMake(text_field_x, edge,
                                              text_field_width,
                                              text_field_height)];
    [self.view addSubview: _textField];
    _textField.placeholder = @"想说点什么呢？";
//    _textField.text = @"Hi\n\n\n\n\n\nend.";
    
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
    _toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, view_height - TOOL_BAR_HEIGHT - 44, view_width, TOOL_BAR_HEIGHT)];
    [self.view addSubview: _toolbar];
    NSLog(@"toolbar %f %f %f %f",  _toolbar.frame.origin.x, _toolbar.frame.origin.y,
          _toolbar.frame.size.width, _toolbar.frame.size.height);
    
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