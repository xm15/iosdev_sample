//
//  CoolButton.m
//  caigee
//
//  Created by caigee on 14-5-29.
//  Copyright (c) 2014年 caigee. All rights reserved.
//

#import "CoolButton.h"
#import "Common.h"

@implementation CoolButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.upColor = [UIColor blackColor];
        self.downColor = [UIColor blackColor];
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //阴影
    CGColorRef shadowColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.5].CGColor;
    
    //两个颜色
    CGColorRef outerTop = self.upColor.CGColor;
    CGColorRef outerBottom = self.downColor.CGColor;
    
    CGFloat outerMargin = 5.0f;
    CGRect outerRect = CGRectInset(self.bounds, outerMargin, outerMargin);
    UIBezierPath *outerPath = [UIBezierPath bezierPathWithRoundedRect:outerRect cornerRadius:6.0];
    ;
    
    // Draw shadow
    if (self.state != UIControlStateHighlighted && !self.isFlat) {
        CGContextSaveGState(context);
        CGContextSetFillColorWithColor(context, outerTop);
        CGContextSetShadowWithColor(context, CGSizeMake(0, 2), 3.0, shadowColor);
        CGContextAddPath(context, outerPath.CGPath);
        CGContextFillPath(context);
        CGContextRestoreGState(context);
    }
    
    // Draw gradient for outer path //高光效果
    CGContextSaveGState(context);
    CGContextAddPath(context, outerPath.CGPath);
    CGContextClip(context);
    drawGlossAndGradient(context, outerRect, outerTop, outerBottom,self.isFlat);
    CGContextRestoreGState(context);
    

    if (self.state == UIControlStateHighlighted) {
        //添加黑色的cover，以表示选中
        UIBezierPath *outerPath = [UIBezierPath bezierPathWithRoundedRect:outerRect cornerRadius:6.0];
        ;
        CGContextSaveGState(context);
        CGContextSetFillColorWithColor(context, [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.2].CGColor);
        CGContextFillPath(context);
        CGContextAddPath(context, outerPath.CGPath);
        CGContextFillPath(context);
        CGContextRestoreGState(context);
    }
    
}

-(void)setUpColor:(UIColor *)upColor
{
    _upColor = upColor;
    [self setNeedsDisplay];
}

-(void)setDownColor:(UIColor *)downColor
{
    _downColor = downColor;
    [self setNeedsDisplay];
}

-(void)setIsFlat:(BOOL)isFlat
{
    _isFlat = isFlat;
    [self setNeedsDisplay];
}

-(void)hesitateUpdate
{
    [self setNeedsDisplay];
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self setNeedsDisplay];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    [self setNeedsDisplay];
    
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
    [self setNeedsDisplay];
    [self performSelector:@selector(hesitateUpdate) withObject:nil afterDelay:0.1];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    [self setNeedsDisplay];
    [self performSelector:@selector(hesitateUpdate) withObject:nil afterDelay:0.1];
}


@end
