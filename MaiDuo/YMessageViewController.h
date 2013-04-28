//
//  YMessageViewController.h
//  MaiDuo
//
//  Created by 魏琮举 on 13-4-27.
//  Copyright (c) 2013年 魏琮举. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TITokenField/TITokenField.h>
#import <YaabUser.h>

@interface YMessageViewController : UIViewController <TITokenFieldDelegate, UITextViewDelegate> {
    
    TITokenFieldView * tokenFieldView;
    UITextView * messageView;
    YaabUser *user;

CGFloat keyboardHeight;
}
@end
