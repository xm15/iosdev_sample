//
//  RootVC.m
//  ClassSample
//
//  Created by caigee on 14-6-29.
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
 
    [self setText:@"你好"]; //这里setText是不能被自己接受的，但是应为在下面做了消息转发，最后事件由self.displayLabel 接受了
}

-(NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    NSMethodSignature *signature = [super methodSignatureForSelector:aSelector];
    if (!signature) {
        signature = [self.displayLabel methodSignatureForSelector:aSelector];
    }
    return signature;
}

-(void)forwardInvocation:(NSInvocation *)anInvocation
{
    SEL selector = [anInvocation selector];
    if ([self.displayLabel respondsToSelector:selector]) {
        [anInvocation invokeWithTarget:self.displayLabel];
    }
}


-(void)naviNext
{
   
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
