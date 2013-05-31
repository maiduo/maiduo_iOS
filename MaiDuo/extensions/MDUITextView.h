//
//  MDUITextView.h
//  MaiDuo
//
//  Created by 魏琮举 on 13-5-28.
//  Copyright (c) 2013年 魏琮举. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MDUITextView : UITextView

@property (copy) NSString *placeholder;
@property (strong) UIColor *placeholderColor;

-(void)textChanged:(NSNotification*)notification;
@end
