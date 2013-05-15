//
//  MDActivity.h
//  MaiDuo
//
//  Created by 魏琮举 on 13-5-12.
//  Copyright (c) 2013年 魏琮举. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MDUser.h"

@interface MDActivity : NSObject

@property (nonatomic, assign) NSInteger id;
@property (nonatomic, strong) NSString *subject;
@property (nonatomic, strong) MDUser *owner;
@property (nonatomic, strong) NSArray *users;
@property (nonatomic, strong) NSMutableArray *invitation;

-(MDUser *)invite:(MDUser *)user;
-(void)removeAllInvitations;

/** @name 为MDHTTPAPI提供的工厂方法 */

/** 创建和返回MDActivity对象 *该方法是为新建对象提供的工厂方法*
 *
 * @param aSubject 活动标题，限制在255字以内。
 * @return 只包含标题的活动对象
 * @see activityWithSubject:description:
 */
+(MDActivity *)activityWithSubject:(NSString *)aSubject;

/** 创建和返回MDActivity对象 *该方法是为新建对象提供的工厂方法*
 *
 * @param aSubject 活动标题，限制在255字以内。
 * @param aDescription 活动简介，同样限制255字以内。
 * @return 包含标题和简介的活动对象
 * @see activityWithSubject:
 */
+(MDActivity *)activityWithSubject:(NSString *)aSubject
                       description:(NSString *)aDescription;

/** @name 为HTTPAPI内部通过JSON重建对象的工厂方法 */

+(NSArray *)activitiesWithJSON:(id)JSON;
+(MDActivity *)activityWithJSON:(id)JSON;

/** @name 实例化对象的工厂方法 */

+(MDActivity *)activityWithID:(NSInteger)aID
                      subject:(NSString *)aSubject
                        owner:(MDUser *)aOwner
                        users:(NSArray *)aUsers;
@end
