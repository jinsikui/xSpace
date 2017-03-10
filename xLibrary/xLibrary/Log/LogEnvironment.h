
#ifdef DEBUG

#import <Foundation/Foundation.h>

@interface LogEnvironment : NSObject

@property(atomic) int tcount;

+(LogEnvironment *)sharedInstance;

@end

#endif
