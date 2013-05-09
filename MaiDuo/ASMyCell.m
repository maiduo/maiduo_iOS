//
//  ASMyCell.m
//  ASFastWashing
//
//  Created by D on 12-12-12.
//  Copyright (c) 2012年 SSD. All rights reserved.
//

#import "ASMyCell.h"

@implementation ASMyCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    rect_screen = [[UIScreen mainScreen]bounds];
    CGRect bounds = self.bounds;
//    568 480
    self.textLabel.adjustsFontSizeToFitWidth = YES;

    self.textLabel.font = [UIFont boldSystemFontOfSize:20];
    self.detailTextLabel.font = [UIFont systemFontOfSize:12];
    [self.detailTextLabel setFrame:CGRectMake(8, 40, 320, 24)];
    if (rect_screen.size.height == 480) {
        [self.textLabel setFrame:CGRectMake(8, 0, 268, bounds.size.height / 2)];
    } else {
        [self.textLabel setFrame:CGRectMake(8, 0, 268, bounds.size.height / 2)];
    }
    
    self.detailTextLabel.textColor = [UIColor darkGrayColor];
    self.detailTextLabel.textAlignment = NSTextAlignmentLeft;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
//    [super setHighlighted:highlighted animated:animated];
//    if (highlighted) {
//        self.detailTextLabel.backgroundColor = [UIColor clearColor];
//    } else {
//        self.detailTextLabel.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.618];
//    }
}

@end
