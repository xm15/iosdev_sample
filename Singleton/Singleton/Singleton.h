//
//  Singleton.h
//  Singleton
//
//  Created by caigee on 14-6-29.
//  Copyright (c) 2014年 caigee. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Singleton;
// 用static申明一个类的静态实例，
static Singleton *_sharedInstance = nil;

@interface Singleton : NSObject
// "+" 表示类的方法，由类调用
+(Singleton *)sharedInstance;

@end
