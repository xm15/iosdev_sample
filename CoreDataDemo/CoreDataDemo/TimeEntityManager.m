//
//  TimeEntityManager.m
//  CoreDataDemo
//
//  Created by caigee on 14-7-2.
//  Copyright (c) 2014年 caigee. All rights reserved.
//

#import "TimeEntityManager.h"

#define Entity_Name    @"TimeEntity"
#define Entity_Key     @"number"

@implementation TimeEntityManager

-(NSArray *)timeEntities
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    // Set the entity of the fetch request to be our Issues object
    NSEntityDescription *entity = [NSEntityDescription entityForName:Entity_Name
                                              inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entity];
    
    // Set up the request sorting
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                        initWithKey:Entity_Key
                                        ascending:YES];
    
    [request setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    // Fetch the results
    // Since there is no predicate defined for this request,
    // The results will be all issues in the managed object context
    NSError *error = nil;
    NSArray *fetchResults = [self.managedObjectContext executeFetchRequest:request
                                                                  error:&error];
    // If the results found an object, return the first one found
    if([fetchResults count] > 0)
        return fetchResults;
    
    // Nothing found, return nil
    return nil;
}

-(NSArray *)timeEntitiesWithTitle:(NSString *)title
{
    // Create a new Fetch Request
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    // Set the entity of our request to a Reminder in our
    // our managed object context
	NSEntityDescription *entity = [NSEntityDescription entityForName:Entity_Name
                                              inManagedObjectContext:self.managedObjectContext];
	[request setEntity:entity];
	
    // Set up a predicate limiting the results of the request
    // We only want the issue with the name provided
	NSPredicate *query = [NSPredicate predicateWithFormat:@"%@ == %@",Entity_Key,title];
	[request setPredicate:query];
    
    // Set up the request sorting
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                        initWithKey:Entity_Key
                                        ascending:YES];
    
    [request setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
	
    // Fetch the results
	NSError *error = nil;
	NSArray *fetchResults = [self.managedObjectContext executeFetchRequest:request
                                                                  error:&error];
	if (fetchResults == nil) {
		NSLog(@"Error retrieving Reminders");
        return nil;
	}
	
    // Since names are not unique, we are returning an array of all matches found
	if([fetchResults count] > 0)
        return fetchResults;
	
    // No results were found, return nil
	return nil;
}

-(TimeEntity *)makeEntityWithTime:(NSString *)time
{
    TimeEntity *timerEntity = (TimeEntity*)[NSEntityDescription insertNewObjectForEntityForName:Entity_Name inManagedObjectContext:self.managedObjectContext];
    [timerEntity setTimeCreated:time];
    
    return timerEntity;
}

-(BOOL)removeALLTimeEnities
{
    for(TimeEntity *timeE in [self timeEntities]){
        [self.managedObjectContext deleteObject:timeE];
    }
    return [self saveContext];
}

-(BOOL)removeTimeEnities:(NSArray *)timeEArray
{
    for(TimeEntity *reminder in timeEArray){
        [self.managedObjectContext deleteObject:reminder];
    }
    return [self saveContext];
}
@end
