//
//  xUrlHelper.h
//  QTTourAppStore
//
//  Created by JSK on 2018/10/26.
//  Copyright © 2018年 Markphone Culture Media Co.Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface xUrlHelper : NSObject

+(NSString*)addToInput:(NSString*)input queryParams:(NSDictionary*)params;

@end
