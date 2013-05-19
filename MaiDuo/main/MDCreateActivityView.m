//
//  MDCreateActivityViewController.m
//  MaiDuo
//
//  Created by 魏琮举 on 13-5-18.
//  Copyright (c) 2013年 魏琮举. All rights reserved.
//

#import "MDCreateActivityView.h"

#define subjectLabelText @"标题: "
#define fieldHeight 42.0f

@interface MDCreateActivityView ()

@end

@implementation MDCreateActivityView

- (id)init
{
    self = [super init];
    if (self) {
        [self setup];
    }

    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (void)setup
{
    CGFloat w = self.bounds.size.width;
    CGSize sizeLabel = [subjectLabelText
                        sizeWithFont:[UIFont systemFontOfSize:17.0f]];
    CGFloat padding = (fieldHeight - sizeLabel.height) / 2;
    CGRect rectLabel = CGRectMake(padding, padding, sizeLabel.width,
                                  sizeLabel.height);
    
    _label = [[UILabel alloc] initWithFrame:rectLabel];
    _label.text = subjectLabelText;
    _label.textColor = [UIColor colorWithWhite:0.5 alpha:1];
    _label.font = [UIFont systemFontOfSize:17.0f];
    
    _subject = [[UITextField alloc]
                initWithFrame:CGRectMake(padding, padding, w,
                                         fieldHeight - padding * 2)];
    _subject.leftViewMode = UITextFieldViewModeAlways;
    _subject.leftView = _label;
    _subject.text = @"默认活动。";
    [self addSubview: _subject];
    
    _separator = [[UIView alloc] initWithFrame:CGRectMake(0, 43, w, 1)];
    [_separator setBackgroundColor:[UIColor colorWithWhite:0.7 alpha:1]];
    [self addSubview:_separator];
}

-(NSString *)activitySubject
{
    return _subject.text;
}

@end
