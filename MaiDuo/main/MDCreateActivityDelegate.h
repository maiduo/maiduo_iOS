//
//  MDCreateActivityDelegate.h
//  MaiDuo
//
//  Created by 魏琮举 on 13-5-19.
//  Copyright (c) 2013年 魏琮举. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MDActivity.h"

@protocol MDCreateActivityDelegate <NSObject>
-(void)didCreateActivity:(MDActivity *)anActivity;
-(void)didReceiveFailure:(NSError *)aError;
@end
