

#import "A.h"

@interface A (xCategory)

//category中只能定义方法，不能定义属性，不能定义实例变量
-(void)x_makeStr;
-(NSString*)x_genStr;
+(void)log;

@end
