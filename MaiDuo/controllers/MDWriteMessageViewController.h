//
//  SendMessageTableViewController.h
//  MaiDuo
//
//  Created by 魏琮举 on 13-4-26.
//  Copyright (c) 2013年 魏琮举. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDWriteMessageView.h"
#import "MDUser.h"
#import "MDUserManager.h"

@interface MDWriteMessageViewController : UIViewController {
    UIImageView *_avatar;
    UIToolbar *_toolbar;
    NSMutableArray *_assets;
    MDWriteMessageView *_writeMessage;
    MDUser *_user;
}

-(id) initWithUser:(MDUser *)anUser;
@end
