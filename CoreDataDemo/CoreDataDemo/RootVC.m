//
//  RootVC.m
//  CoreDataDemo
//
//  Created by caigee on 14-7-2.
//  Copyright (c) 2014年 caigee. All rights reserved.
//

#import "RootVC.h"


@interface RootVC ()

@end

@implementation RootVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    timesArray = [NSMutableArray array];
    sharedManager = [TimeEntityManager sharedCoreDataManager];
    [self addButton];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)refreshView
{
    [timesArray removeAllObjects];
    [timesArray addObjectsFromArray:[sharedManager timeEntities]];
    
    for (UIView *view in [self.view subviews]) {
        [view removeFromSuperview];
    }
    
    [self addButton];
    
    for (int i =0; i< [timesArray count]; i++) {
        UILabel *aLabel = [[UILabel alloc]initWithFrame:CGRectMake(20.0, 120+i*25, 280.0, 20.0)];
        aLabel.textAlignment = NSTextAlignmentCenter;
        TimeEntity *time =[timesArray objectAtIndex:i];
        
        [aLabel setText:time.timeCreated];
        [self.view addSubview:aLabel];
    }
}
-(void)timeAdd
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    
    //    TimeEntity *newTimer =
    [sharedManager makeEntityWithTime:currentDateStr];
    
    [sharedManager saveContext];
    [self refreshView];
}

-(void)timeDelete
{
    if ([timesArray count]>0) {
        [sharedManager removeTimeEnities:[NSArray arrayWithObject:[timesArray objectAtIndex:0]]];
        [sharedManager saveContext];
        
        [self refreshView];
    }
    
}

-(void)addButton
{
    do {
        UIButton *abtn = [UIButton buttonWithType:UIButtonTypeCustom];
        abtn.frame = CGRectMake(0, 74.0, 160, 20);
        [abtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        [abtn setTitle:@"ADD" forState:UIControlStateNormal];
        [abtn addTarget:self action:@selector(timeAdd) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:abtn];
    } while (0);
    
    do {
        UIButton *abtn = [UIButton buttonWithType:UIButtonTypeCustom];
        abtn.frame = CGRectMake(160, 74.0, 160, 20);
        [abtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [abtn setTitle:@"DELETE" forState:UIControlStateNormal];
        [abtn addTarget:self action:@selector(timeDelete) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:abtn];
    } while (0);
    do {
        UIButton *abtn = [UIButton buttonWithType:UIButtonTypeCustom];
        abtn.frame = CGRectMake(80*0, 90.0, 80, 30);
        [abtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [abtn setTitle:@"undo" forState:UIControlStateNormal];
        [abtn addTarget:self action:@selector(undo) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:abtn];
    } while (0);
    do {
        UIButton *abtn = [UIButton buttonWithType:UIButtonTypeCustom];
        abtn.frame = CGRectMake(80*1, 90.0, 80, 30);
        [abtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [abtn setTitle:@"redo" forState:UIControlStateNormal];
        [abtn addTarget:self action:@selector(redo) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:abtn];
    } while (0);
    do {
        UIButton *abtn = [UIButton buttonWithType:UIButtonTypeCustom];
        abtn.frame = CGRectMake(80*2, 90.0, 80, 30);
        [abtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [abtn setTitle:@"rollback" forState:UIControlStateNormal];
        [abtn addTarget:self action:@selector(rollback) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:abtn];
    } while (0);
    do {
        UIButton *abtn = [UIButton buttonWithType:UIButtonTypeCustom];
        abtn.frame = CGRectMake(80*3, 90.0, 80, 30);
        [abtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [abtn setTitle:@"reset" forState:UIControlStateNormal];
        [abtn addTarget:self action:@selector(reset) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:abtn];
    } while (0);
}

-(void)undo
{
    [sharedManager undo];
    [self refreshView];
}
-(void)redo
{
    [sharedManager redo];
    [self refreshView];
}
-(void)rollback
{
    [sharedManager rollback];
    [self refreshView];
}
-(void)reset
{
    [sharedManager reset];
    [self refreshView];
}

@end
