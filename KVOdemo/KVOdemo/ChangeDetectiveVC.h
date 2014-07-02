//
//  ChangeDetectiveVC.h
//  KVOdemo
//
//  Created by caigee on 14-7-2.
//  Copyright (c) 2014年 caigee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Book.h"

@interface ChangeDetectiveVC : UIViewController

@property (nonatomic,strong)Book *abook;

-(id)init:(Book *)theBook;

@end
