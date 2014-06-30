//
//  Singleton.m
//  Singleton
//
//  Created by caigee on 14-6-29.
//  Copyright (c) 2014年 caigee. All rights reserved.
//

#import "Singleton.h"

@implementation Singleton

+(Singleton *)sharedInstance
{
    if (!_sharedInstance) {
        _sharedInstance =[[self alloc]init];
    }
    return _sharedInstance;
}

// 避免生成两个_sharedInstance，仅在多线程下需要这样做
+(id)allocWithZone:(struct _NSZone *)zone
{
    @synchronized(self)
    {
        if (_sharedInstance ==nil) {
            _sharedInstance = [super allocWithZone:zone];
            return _sharedInstance;
        }
    }
    return nil;
}

@end
