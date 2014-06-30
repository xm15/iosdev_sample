//
//  RootVC.h
//  ClassSample
//
//  Created by caigee on 14-6-29.
//  Copyright (c) 2014年 caigee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NextVC.h"

// 申明协议实现
@interface RootVC : UIViewController<textSendDelegate>

@property (nonatomic,retain)UILabel *displayLabel;

@end
