//
//  CoreDataManager.h
//  CoreDataDemo
//
//  Created by caigee on 14-7-2.
//  Copyright (c) 2014年 caigee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoreDataManager : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;


+(id)sharedCoreDataManager;
- (BOOL)saveContext;

// Context Operations
- (void)undo;
- (void)redo;
- (void)rollback;
- (void)reset;

@end
