//
//  UIViewFrameCategory.m
//  MaiDuo
//
//  Created by WangPeng on 5/25/13.
//  Copyright (c) 2013 魏琮举. All rights reserved.
//

#import "UIViewFrameCategory.h"

@implementation UIView (frame)

- (void)setWidth:(float)width
{
    CGRect rect = self.frame;
    rect.size.width = width;
    self.frame = rect;
}

- (float)width
{
    return self.frame.size.width;
}

- (void)setHeight:(float)height
{
    CGRect rect = self.frame;
    rect.size.height = height;
    self.frame = rect;
}

- (float)height
{
    return self.frame.size.height;
}

- (void)setLeft:(float)left
{
    CGRect rect = self.frame;
    rect.origin.x = left;
    self.frame = rect;
}

- (float)left
{
    return self.frame.origin.x;
}

- (void)setRight:(float)right
{
    CGRect rect = self.frame;
    rect.origin.x = right-rect.size.width;
    self.frame = rect;
}

- (float)right
{
    return self.frame.origin.x+self.frame.size.width;
}

- (void)setTop:(float)top
{
    CGRect rect = self.frame;
    rect.origin.y = top;
    self.frame = rect;
}

- (float)top
{
    return self.frame.origin.y;
}

- (void)setBottom:(float)bottom
{
    CGRect rect = self.frame;
    rect.origin.y = bottom-rect.size.height;
    self.frame = rect;
}

- (float)bottom
{
    return self.frame.origin.y+self.frame.size.height;
}

@end
