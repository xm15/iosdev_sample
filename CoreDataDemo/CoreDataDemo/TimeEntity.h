//
//  TimeEntity.h
//  CoreDataDemo
//
//  Created by caigee on 14-7-2.
//  Copyright (c) 2014年 caigee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface TimeEntity : NSManagedObject

@property (nonatomic, retain) NSString * timeCreated;
@property (nonatomic, retain) NSNumber * number;

@end
