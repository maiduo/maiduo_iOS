//
//  MDActivityConCell.h
//  MaiDuo
//
//  Created by WangPeng on 5/12/13.
//  Copyright (c) 2013 魏琮举. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDContact.h"

@interface MDActivityConCell : UITableViewCell

@property (nonatomic, strong) MDContact *item;

+ (CGFloat)heightWithItem:(MDContact *)item;

@end
