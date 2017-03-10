
#ifdef DEBUG

#import "NSDictionary+Log.h"
#import "LogEnvironment.h"

@implementation NSDictionary (Log)

- (NSString *)descriptionWithLocale:(id)locale
{
        NSArray *allKeys = [self allKeys];
        NSMutableString *str = [[NSMutableString alloc] initWithString:@"{\n"];
        [LogEnvironment sharedInstance].tcount++;
        for (NSString *key in allKeys) {
            id value = self[key];
            for(int i=0;i<[LogEnvironment sharedInstance].tcount;i++){
                [str appendFormat:@"\t"];
            }
            if ([value isKindOfClass:[NSString class]]) {
                value = [NSString stringWithFormat:@"\"%@\"", value];
            }
            [str appendFormat:@"\"%@\" = %@;\n",key, value];
        }
        [LogEnvironment sharedInstance].tcount--;
        for(int i=0;i<[LogEnvironment sharedInstance].tcount;i++){
            [str appendFormat:@"\t"];
        }
        [str appendString:@"}"];
        return str;
}

@end

#endif
