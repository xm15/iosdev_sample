//
//  RootVC.m
//  DemoCoreGraphics
//
//  Created by caigee on 14-7-4.
//  Copyright (c) 2014年 caigee. All rights reserved.
//

#import "RootVC.h"
#import "DrawView.h"
#import "CoolButton.h"

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
    
    DrawView *drawView = [[DrawView alloc]initWithFrame:CGRectMake(0.0, 0.0, 320.0, 536)];
    [self.view addSubview:drawView];
    
    NSString *str = @"你好";
    
    CGSize size= [str sizeWithFont:[UIFont systemFontOfSize:15] forWidth:200 lineBreakMode:NSLineBreakByCharWrapping];
    CoolButton *cool = [[CoolButton alloc]initWithFrame:CGRectMake(20.0, 300.0, size.width +40, size.height +20)];
    cool.isFlat = YES;
    cool.upColor = [UIColor orangeColor];
    cool.downColor = [UIColor redColor];
    [cool setTitle:@"你好" forState:UIControlStateNormal];
    [self.view addSubview:cool];
    
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
