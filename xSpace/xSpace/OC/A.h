

#import <Foundation/Foundation.h>

@protocol AProtocal <NSObject>

@optional
- (void) sendMsg;
@required
- (void) receiveMsg:(NSString*)msg;

@end

@interface A : NSObject<AProtocal>{

@public
    NSString* s1_;
    NSString* s2_;
@protected
    //本类和子类可以访问（默认）
    NSString* s3_;
@private
    //仅本类可访问
    NSString* s4_;
@package
    //本Library内可以使用（It’s for cases when you write a portable library, the visibility level is then set to your library, but not for the other source code that will make use of it.）
    NSString* s5_;
}

/* property attributes
atomic      nonatomic
strong      weak
readwrite	readonly
getter=     setter=
copy        assign
retain      unsafe_unretained
*/
@property(nonatomic, assign) int p1;
@property(nonatomic, strong) NSString *p2;

//构造方法，id:任意类型的oc对象，instancetype:方法所在类的对象
-(instancetype)initWithStr:(NSString*)str andStr:(NSString*)str2;
//实例方法
-(void)a_makeStr;
//类方法
+(NSString*)getNickname;
@end

//全局变量
extern NSString *A_global_name;



