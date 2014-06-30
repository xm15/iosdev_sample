//
//  RootVC.m
//  ClassSample
//
//  Created by caigee on 14-6-29.
//  Copyright (c) 2014年 caigee. All rights reserved.
//

#import "RootVC.h"
#import "NextVC.h"

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
    
    self.title = @"Root";
    
    [self addButton];
    // Do any additional setup after loading the view.
}

-(void)addButton
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(20.0, 100.0, 100.0, 40.0);
    [btn setTitle:@"Next" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(naviNext) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20.0, 140.0, 200.0, 30.0)];
    self.displayLabel = label;
    [self.view addSubview:label];
    [label release];
    
}


-(void)naviNext
{
    //协议的绑定
    NextVC *next = [[NextVC alloc]init];
    next.delegate =self;
    [self.navigationController pushViewController:next animated:YES];
    [next release];
}

// 协议实现
-(void)textSend:(NSString *)textString
{
    self.displayLabel.text = textString;
}

-(void)logOfTextSend
{
    NSLog(@"a text is send to RootVC");
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
