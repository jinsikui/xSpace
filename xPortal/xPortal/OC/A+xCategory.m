

#import "A+xCategory.h"
#import "A+xExtension.h"


@implementation A (xCategory)

-(void)x_makeStr{
    
    s1_ = @"x_Hello";
    s2_ = @"x_World";
    s3_ = @"x_Hello";
    //可以访问主类的@private成员，说明category会和主类合并为一个类
    s4_ = @"x_World"; 
    s5_ = @"x_Hello";
    //调用主类方法
    [self a_makeStr];
    
    //Extension
    s6_ = @"x_Hello";
    s7_ = @"x_World";
    //也可以访问Extension中的@private成员，说明主类，extension，category三者会合并为一个类
    s8_ = @"x_Hello";
    s9_ = @"x_World";
    //调用Extension中的方法
    [self e_makeStr];
}

-(NSString*)x_genStr{
    return [NSString stringWithFormat:@"s1:%@\n s2:%@\n s3:%@\n s4:%@\n s5:%@\n s6:%@\n s7:%@\n s8:%@\n s9:%@\n", s1_, s2_, s3_, s4_, s5_, s6_, s7_, s8_, s9_];
}

+(void)log{
    //...
}

@end
