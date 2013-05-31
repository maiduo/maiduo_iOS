//
//  SendMessageTableViewController.h
//  MaiDuo
//
//  Created by 魏琮举 on 13-4-26.
//  Copyright (c) 2013年 魏琮举. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDUITextView.h"
#import "MDUser.h"
#import "MDUserManager.h"

@interface MDWriteMessageViewController : UIViewController {
    UIImageView *_avatar;
    UIToolbar *_toolbar;
    MDUITextView *_textField;
    MDUser *_user;
    
    UIView *_navigationTitle;
    UIProgressView *_navigationProgress;
    UIView *_navigationProgressBar;
    UILabel *_navigationProgressLabel;
}

-(id) initWithUser:(MDUser *)anUser;
@end
