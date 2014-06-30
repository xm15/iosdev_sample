//
//  NSNull+InternalNullExtention.m
//  ClassForward
//
//  Created by caigee on 14-6-30.
//  Copyright (c) 2014年 caigee. All rights reserved.
//

//来源于 http://blog.rpplusplus.me/blog/2014/03/28/nsnull-category/

#define NSNullObjects @[@"",@0,@{},@[]]

#import "NSNull+InternalNullExtention.h"

@implementation NSNull (InternalNullExtention)

- (NSMethodSignature*)methodSignatureForSelector:(SEL)selector
{
    NSMethodSignature* signature = [super methodSignatureForSelector:selector];
    if (!signature) {
        for (NSObject *object in NSNullObjects) {
            signature = [object methodSignatureForSelector:selector];
            if (signature) {
                break;
            }
        }
        
    }
    return signature;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    SEL aSelector = [anInvocation selector];
    
    for (NSObject *object in NSNullObjects) {
        if ([object respondsToSelector:aSelector]) {
            [anInvocation invokeWithTarget:object];
            return;
        }
    }
    
    [self doesNotRecognizeSelector:aSelector];
}


@end
