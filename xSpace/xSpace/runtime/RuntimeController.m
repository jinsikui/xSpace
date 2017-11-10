//
//  RuntimeController.m
//  xPortal
//
//  Created by JSK on 2017/6/30.
//  Copyright © 2017年 xSpace. All rights reserved.
//

#import "RuntimeController.h"
#import <objc/runtime.h>
#import <objc/message.h>


@implementation RuntimeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"runtime";
    self.view.backgroundColor = kColor_FFFFFF;
    //
    UILabel *label = [xViewTools createLabel:nil frame:CGRectMake(0, 10, kContentWidth, kContentHeight) alignment:NSTextAlignmentCenter font:kFontPF(14) textColor:kColor_000000 line:0];
    [self.view addSubview:label];
    
    /**
     1.给类名，初始化类实例
     2.给方法名，调用方法传参
     3.列出方法列表
     **/
    //1
    NSString *className = @"xStatisActionData";
    id obj = [[NSClassFromString(className) alloc] init];
    
    //3
    uint count;
    Method *methods = class_copyMethodList([obj class], &count);
    NSMutableString *s = [NSMutableString string];
    for(int i=0; i<count; i++){
        Method method = methods[i];
        SEL selector = method_getName(method);
        const char *methodType = method_getTypeEncoding(method);
        [s appendFormat:@"%@: %@\n",NSStringFromSelector(selector),[NSString stringWithUTF8String:methodType]];
    }
    [s appendString:@"\n"];
    
    //2
    NSString *methodName = @"setActItemText:";
    NSString *value = @"Hello runtime";
    SEL selector = NSSelectorFromString(methodName);
    /**
     方法一
     function call below will got 'Too many arguments to function call, expected 0, have 3' compile error
     you can disable the check in the build settings by setting 'Enable strict checking of objc_msgSend Calls' to no
     **/
    //objc_msgSend(obj, selector, value);
    
    /**
     方法二
     got 'PerformSelector may cause a leak because its selector is unknown' warning
     using this method the argument count must less than two
     **/
    //[obj performSelector:selector withObject:value];
    
    /**
     方法三
     可以任意个参数
     **/
    NSMethodSignature *sig = [obj methodSignatureForSelector:selector];
    NSInvocation *invoc = [NSInvocation invocationWithMethodSignature:sig];
    invoc.target = obj;
    invoc.selector = selector;
    [invoc setArgument:&value atIndex:2];//从2开始,0:obj,1:selector
    [invoc invoke];
    
    //call getter
    selector = NSSelectorFromString(@"actItemText");
    sig = [obj methodSignatureForSelector:selector];
    invoc = [NSInvocation invocationWithMethodSignature:sig];
    invoc.target = obj;
    invoc.selector = selector;
    [invoc invoke];
    NSString *retStr;
    [invoc getReturnValue:&retStr];
    [s appendFormat:@"obj.actItemText: %@", retStr];//must be 'Hello runtime'
    
    //
    label.text = s;
}

@end
