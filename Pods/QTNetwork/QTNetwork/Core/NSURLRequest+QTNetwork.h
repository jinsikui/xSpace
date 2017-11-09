//
//  NSURLRequest+QTNetwork.h
//  QTNetwork
//
//  Created by Leo on 2017/8/16.
//  Copyright © 2017年 QT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURLRequest (QTNetwork)

/**
 URLRequest的唯一标识符
 */
- (NSString *)qt_unqiueIdentifier;

@end
