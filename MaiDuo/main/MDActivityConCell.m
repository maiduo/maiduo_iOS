//
//  MDActivityConCell.m
//  MaiDuo
//
//  Created by WangPeng on 5/12/13.
//  Copyright (c) 2013 魏琮举. All rights reserved.
//

#import "MDActivityConCell.h"

@implementation MDActivityConCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.indentationWidth = 10;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}

- (void)setItem:(MDContact *)item
{
    _item = item;

    self.textLabel.text = [NSString stringWithFormat:@"%@%@%@",
                           _item.lastName?_item.lastName:@"",
                           _item.middleName?_item.middleName:@"",
                           _item.firstName?_item.firstName:@""];
    self.detailTextLabel.text =[NSString stringWithFormat:@"电话 %@",
                                [_item.phones count]>0?[_item.phones objectAtIndex:0]:@"无"];
}

+ (CGFloat)heightWithItem:(MDContact *)item
{
    return 44;
}

@end
