//
//  UIView+UpsideDown.m
//  Singleton
//
//  Created by caigee on 14-6-30.
//  Copyright (c) 2014年 caigee. All rights reserved.
//

#import "UIView+UpsideDown.h"
#import <math.h>

@implementation UIView (UpsideDown)

-(void)upsideDown
{
    CGFloat angle = M_PI;
    CGAffineTransform transform = CGAffineTransformMakeRotation(angle);
    [self setTransform:transform];
}


@end
