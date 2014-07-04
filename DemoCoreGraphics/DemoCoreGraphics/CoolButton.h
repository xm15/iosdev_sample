//
//  CoolButton.h
//  caigee
//
//  Created by caigee on 14-5-29.
//  Copyright (c) 2014年 caigee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CoolButton : UIButton

@property(nonatomic)BOOL isFlat;
@property(nonatomic,retain)UIColor *upColor;
@property(nonatomic,retain)UIColor *downColor;

@end
