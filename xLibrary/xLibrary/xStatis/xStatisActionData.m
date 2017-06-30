//
//  xStatisActionData.m
//  xLibrary
//
//  Created by JSK on 2017/6/29.
//  Copyright © 2017年 xSpace. All rights reserved.
//

#import "xStatisActionData.h"
#import "xStatisService.h"
#import "xStatisStack.h"
#import "UIView+xStatis.h"


@interface xStatisActionData(){
    UIView      *actionView_;
    NSString    *actionViewPath_;
    NSString    *pageName_;
    NSString    *pageId_;
    NSString    *refPageName_;
    NSString    *refPageId_;
}

@end

@implementation xStatisActionData

/**
 初始化方法
 */
- (instancetype) initWithActItemText:(NSString *)actItemText
                         actItemLink:(NSString *)actItemLink
                    actItemOtherInfo:(NSString*)actItemOtherInfo
                           actPosArr:(NSArray *)actPosArr
{
    return [self initWithUserActionView:nil
                        actItemText:actItemText
                        actItemLink:actItemLink
                   actItemOtherInfo:actItemOtherInfo
                          actPosArr:actPosArr];
}

/**
 初始化方法
 */
- (instancetype) initWithUserActionView:(UIView *)userActionView
                        actItemText:(NSString *)actItemText
                        actItemLink:(NSString *)actItemLink
                   actItemOtherInfo:(NSString*)actItemOtherInfo
                          actPosArr:(NSArray *)actPosArr
{
    self = [super init];
    if (self) {
        self.userActionView = userActionView;
        self.actPosArr = actPosArr;
        self.actItemText = actItemText;
        self.actItemLink = actItemLink;
        self.actItemOtherInfo = actItemOtherInfo;
        //
        xStatisService *service = [xStatisService sharedInstance];
        actionView_ = service.previousResponder;
        //
        actionViewPath_ = actionView_.xs_viewPath;
        //
        xStatisStack *stack = [xStatisStack sharedInstance];
        xStatisStackData *data = stack.topData;
        if(data){
            pageId_ = data.pageId;
            pageName_ = data.pageName;
            refPageId_ = data.refPageId;
            refPageName_ = data.refPageName;
        }
    }
    return self;
}

-(UIView*)actionView{
    return actionView_;
}

-(NSString*)actionViewXPath{
    return actionViewPath_;
}

-(NSString*)pageName{
    return pageName_;
}

-(NSString*)pageId{
    return pageId_;
}

-(NSString*)refPageName{
    return refPageName_;
}

-(NSString*)refPageId{
    return refPageId_;
}

@end
