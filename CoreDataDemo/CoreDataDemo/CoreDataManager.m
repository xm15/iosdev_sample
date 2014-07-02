//
//  CoreDataManager.m
//  CoreDataDemo
//
//  Created by caigee on 14-7-2.
//  Copyright (c) 2014年 caigee. All rights reserved.
//

#import "CoreDataManager.h"
#import <CoreData/CoreData.h>

#define ManagedObjectModelFileName @"DemoModel"

static CoreDataManager *sharedManager = nil;

@implementation CoreDataManager

@synthesize managedObjectContext    = _managedObjectContext;
@synthesize managedObjectModel      = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

+(id)sharedCoreDataManager
{
    @synchronized(self)
    {
        if (sharedManager == nil) {
            sharedManager = [[self alloc]init];
        }
    }
    return sharedManager;
}



#pragma mark ————管理对象上下文————
- (BOOL)saveContext{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil){
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]){
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            return NO;
        }
    }
    else{
        NSLog(@"Managed Object Context is nil");
        return NO;
    }
    NSLog(@"Context Saved");
    
    return YES;
}


- (NSManagedObjectContext *)managedObjectContext{
    if (_managedObjectContext != nil){
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil){
        
        NSManagedObjectContext *moc = [[NSManagedObjectContext alloc]
                                       initWithConcurrencyType:NSMainQueueConcurrencyType];
        
        [moc performBlockAndWait:^(void){
            // Set up an undo manager, not included by default
            NSUndoManager *undoManager = [[NSUndoManager alloc] init];
            [undoManager setGroupsByEvent:NO];
            [moc setUndoManager:undoManager];
            
            // Set persistent store
            [moc setPersistentStoreCoordinator:coordinator];
        }];
        
        
        _managedObjectContext = moc;
    }
    return _managedObjectContext;
}

/**
 受控对象模型
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel{
    if (_managedObjectModel != nil)
    {
        return _managedObjectModel;
    }
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:ManagedObjectModelFileName withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

/**
 创建调度器
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator{
    if (_persistentStoreCoordinator != nil){
        return _persistentStoreCoordinator;
    }
    
    // 持久化存储调度器
    // Set up persistent Store Coordinator
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    // Set up SQLite db and options dictionary
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite",ManagedObjectModelFileName]];
    NSDictionary *options = nil;
    
    // 添加持久化存储
    // Add the persistent store to the persistent store coordinator
    NSError *error = nil;
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                    configuration:nil
                                                              URL:storeURL
                                                          options:options
                                                            error:&error]){
        // Handle the error
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    
    
    return _persistentStoreCoordinator;
}

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark - Undo/Redo Operations


- (void)undo{
    [_managedObjectContext undo];
    
}

- (void)redo{
    [_managedObjectContext redo];
}

- (void)rollback{
    [_managedObjectContext rollback];
}

- (void)reset{
    [_managedObjectContext reset];
}

@end
