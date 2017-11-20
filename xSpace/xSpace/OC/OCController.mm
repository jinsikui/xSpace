

#import "OCController.h"
#import "A.h"
#import "B.h"
#import "A+xCategory.h"
#import "A+xExtension.h"
#import "Greeting.h"

@interface OCController (){
    //c++ object
    Greeting greeting_;
}

@end

@implementation OCController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"OC语法";
    self.view.backgroundColor = kColor(0xFFFFFF);
    
    A *a = [[A alloc] initWithStr:@"Hellow" andStr:@"World"];
    a->s1_ = @"w_Hello";
    a->s2_ = @"w_World";
    //a->s3_ = @"w_Hello"; @protected 禁止访问
    //a->s4_ = @"w_World"; @private 禁止访问
    a->s5_ = @"w_Hello";
    a.p1 = 0;
    a.p2 = @"w_World";
    [a a_makeStr];
    
    //Extension
    a->s6_ = @"w_Hello";
    //a->s7_ = @"w_World"; @protected 禁止访问
    //a->s8_ = @"w_Hello"; @private 禁止访问
    a->s9_ = @"w_World";
    a.p3 = 0;
    [a e_makeStr];
    
    //Category
    [a x_makeStr];
    NSString *str = [a x_genStr];
    //
    UILabel *label = [xViewFactory labelWithText:str font:kFontPF(14) color:kColor(0) alignment:NSTextAlignmentCenter];
    label.frame = CGRectMake(0, 50, kContentWidth, 200);
    [self.view addSubview:label];
    
    //call c++
    NSString* str2 = [NSString stringWithCString:greeting_.greet().c_str() encoding:[NSString defaultCStringEncoding]];
    //
    UILabel *label2 = [xViewFactory labelWithText:str2 font:kFontPF(14) color:kColor(0) alignment:NSTextAlignmentCenter];
    label2.frame = CGRectMake(0, 250, kContentWidth, 20);
    [self.view addSubview:label2];
    
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

@end








