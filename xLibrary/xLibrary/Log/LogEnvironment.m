
#ifdef DEBUG

#import "LogEnvironment.h"

@interface LogEnvironment()
{
}

@end

@implementation LogEnvironment

static LogEnvironment *_instance;

+(LogEnvironment *)sharedInstance{
    @synchronized(self) {
        if(_instance == nil){
            _instance = [[LogEnvironment alloc] init];
            _instance.tcount = 0;
        }
        return _instance;
    }
}

@end

#endif
