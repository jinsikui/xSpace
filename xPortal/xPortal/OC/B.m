

#import "B.h"
#import "A+xExtension.h"
#import "A+xCategory.h"

@implementation B

-(void)b_makeStr{
    s1_ = @"b_Hello";
    s2_ = @"b_World";
    s3_ = @"b_Hello";
    //s4_ = @"a_World"; @private 禁止访问
    s5_ = @"b_Hello";
    
    //Extension
    s6_ = @"b_Hello";
    s7_ = @"b_World";
    //s8_ = @"a_Hello"; @private 禁止访问
    s9_ = @"b_World";
    
    //Category
    [self x_genStr];
}

@end
