//
//  RootVC.h
//  CoreDataDemo
//
//  Created by caigee on 14-7-2.
//  Copyright (c) 2014年 caigee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimeEntityManager.h"

@interface RootVC : UIViewController
{
    NSMutableArray      *timesArray;
    TimeEntityManager   *sharedManager;
    
    int currentNmumber;

}

@end
