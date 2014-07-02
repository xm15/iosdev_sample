//
//  SecondVC.m
//  TabedNavVC
//
//  Created by caigee on 14-7-2.
//  Copyright (c) 2014年 caigee. All rights reserved.
//

#import "SecondVC.h"

@interface SecondVC ()

@end

@implementation SecondVC

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
    self.view.backgroundColor = [UIColor grayColor];
    
    self.title = [NSString stringWithFormat:@"Another page:%d",self.currentIndex];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(20.0, 80.0, 280, 40)];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitle:@"POP" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    do {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(20.0, 140, 280, 40)];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setTitle:@"Dismiss" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(disMiss) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    } while (0);
    // Do any additional setup after loading the view.
}

-(void)disMiss
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)next
{
    SecondVC *second = [[SecondVC alloc]init];
    second.currentIndex = self.currentIndex +1;
    [self presentViewController:second animated:YES completion:nil];
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
