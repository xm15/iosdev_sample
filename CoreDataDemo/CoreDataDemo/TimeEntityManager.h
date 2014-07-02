//
//  TimeEntityManager.h
//  CoreDataDemo
//
//  Created by caigee on 14-7-2.
//  Copyright (c) 2014年 caigee. All rights reserved.
//

#import "CoreDataManager.h"
#import "TimeEntity.h"

@interface TimeEntityManager : CoreDataManager

-(NSArray *)timeEntities;
-(NSArray *)timeEntitiesWithTitle:(NSString *)title;
-(TimeEntity *)makeEntityWithTime:(NSString *)time;
-(BOOL)removeTimeEnities:(NSArray *)timeEArray;
-(BOOL)removeALLTimeEnities;


@end
