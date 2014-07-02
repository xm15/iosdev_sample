//
//  RootVC.m
//  TabedNavVC
//
//  Created by caigee on 14-7-2.
//  Copyright (c) 2014年 caigee. All rights reserved.
//

#import "RootVC.h"
#import "FirstVC.h"
#import "SecondVC.h"

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
    
    UITabBarController *tabBarController = [[UITabBarController alloc]init];
    tabBarController.delegate = self;
    
    FirstVC *firstVC = [[FirstVC alloc]init];
    UINavigationController *firstNav = [[UINavigationController alloc]initWithRootViewController:firstVC];
    firstNav.tabBarItem = [[UITabBarItem alloc]initWithTabBarSystemItem:UITabBarSystemItemRecents tag:0];
    
    SecondVC *secondVC = [[SecondVC alloc]init];
    UINavigationController *secondNav = [[UINavigationController alloc]initWithRootViewController:secondVC];
    secondNav.tabBarItem = [[UITabBarItem alloc]initWithTabBarSystemItem:UITabBarSystemItemRecents tag:1];

    tabBarController.viewControllers = [NSArray arrayWithObjects:firstNav,secondNav, nil];
    
    // 重要：一定不能让 tabBarController 释放掉，否则会引起崩溃
    self.topTabBarController = tabBarController;
    [self.view addSubview:tabBarController.view];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
