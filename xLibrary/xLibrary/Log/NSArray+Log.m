
#ifdef DEBUG

#import "NSArray+Log.h"
#import "LogEnvironment.h"

@implementation NSArray (Log)

- (NSString *)descriptionWithLocale:(id)locale
{
    NSMutableString *str = [NSMutableString stringWithFormat:@"%lu [\n", (unsigned long)self.count];
    [LogEnvironment sharedInstance].tcount++;
    for (int i=0; i<[self count];i++) {
        id obj = [self objectAtIndex:i];
        for(int j=0;j<[LogEnvironment sharedInstance].tcount;j++){
            [str appendFormat:@"\t"];
        }
        if ([obj isKindOfClass:[NSString class]]) {
            obj = [NSString stringWithFormat:@"\"%@\"", obj];
        }
        [str appendFormat:@"%@", obj];
        if(i < ([self count] - 1)){
            [str appendString:@",\n"];
        }
        else{
            [str appendString:@"\n"];
        }
    }
    [LogEnvironment sharedInstance].tcount--;
    for(int j=0;j<[LogEnvironment sharedInstance].tcount;j++){
        [str appendFormat:@"\t"];
    }
    [str appendString:@"]"];
    return str;
}

@end

#endif
