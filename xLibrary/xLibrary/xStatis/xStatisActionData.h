//
//  xStatisActionData.h
//  xLibrary
//
//  Created by JSK on 2017/6/29.
//  Copyright © 2017年 xSpace. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface xStatisActionData : NSObject

/**
 系统捕获的最后响应事件的view
 */
@property (nonatomic, strong, readonly) UIView *actionView;

/**
 系统捕获的最后响应事件的view的xPath路径
 */
@property (nonatomic, strong, readonly) NSString *actionViewPath;

/**
 用户设置的事件发生的view（建议不用，直接使用actionView）
 */
@property (nonatomic, strong) UIView *userActionView;

/**
 用户设置的事件位置（如果不设置，也可以直接使用actionViewXPath）
 */
@property (nonatomic, strong) NSArray *actPosArr;

/**
 用户设置的事件文本
 */
@property (nonatomic, strong) NSString *actItemText;


/**
 用户设置的事件链接
 */
@property (nonatomic, strong) NSString *actItemLink;


/**
 用户设置的事件额外信息
 */
@property (nonatomic, strong) NSString *actItemOtherInfo;

/**
 发生事件的页面，即通过当前UIViewController的xs_pageName属性设置的名字或xStatisManager的pushPageWithKey:pageName:方法设置的名字
 */
@property (nonatomic, strong, readonly) NSString *pageName;

/**
 发生事件的页的Id
 */
@property (nonatomic, strong, readonly) NSString *pageId;

/**
 上一个页面
 */
@property (nonatomic, strong, readonly) NSString *refPageName;

/**
 上一个页面的Id
 */
@property (nonatomic, strong, readonly) NSString *refPageId;

/**
 初始化方法
 */
- (instancetype) initWithActItemText:(NSString *)actItemText
                         actItemLink:(NSString *)actItemLink
                    actItemOtherInfo:(NSString*)actItemOtherInfo
                           actPosArr:(NSArray *)actPosArr;

/**
 初始化方法，如果不是延迟记录事件，不需要调用该方法
 */
- (instancetype) initWithUserActionView:(UIView *)userActionView
                        actItemText:(NSString *)actItemText
                        actItemLink:(NSString *)actItemLink
                   actItemOtherInfo:(NSString*)actItemOtherInfo
                          actPosArr:(NSArray *)actPosArr;

@end
