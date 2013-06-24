//
//  PHTextView.m
//  MaiDuo
//
//  Created by 高 欣 on 13-6-24.
//  Copyright (c) 2013年 魏琮举. All rights reserved.
//

#import "PHTextView.h"

@implementation PHTextView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    if(self.text.length==0&&self.placehold.length>0){
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGColorRef colorRef;
        if(self.placeholdColor){
            colorRef=self.placeholdColor.CGColor;
        }else{
            colorRef=[UIColor lightGrayColor].CGColor;
        }
        CGContextSetFillColorWithColor(context, colorRef);
        [self.placehold drawAtPoint:CGPointMake(10, 8) withFont:self.font];
    }
    [super drawRect:rect];
}


@end
