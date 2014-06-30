//
//  NextVC.m
//  ClassSample
//
//  Created by caigee on 14-6-29.
//  Copyright (c) 2014年 caigee. All rights reserved.
//

#import "NextVC.h"

@interface NextVC ()

@end

@implementation NextVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)dealloc
{
    [_myTextField release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Next";
    self.view.backgroundColor = [UIColor grayColor];
    
    [self addInput];
    // Do any additional setup after loading the view.
}

-(void)addInput
{
    UITextField *textf  = [[UITextField alloc]initWithFrame:CGRectMake(20.0, 100.0, 200.0, 30.0)];
    textf.backgroundColor = [UIColor whiteColor];
    [textf.layer setCornerRadius:4.0];
    _myTextField = textf;
    [self.view addSubview:textf];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(20.0, 130, 100.0, 40.0);
    [btn setTitle:@"Send" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(SendTextByDelegate) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

// 协议方法的触发
-(void)SendTextByDelegate
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(textSend:)]) {
        [self.delegate textSend:_myTextField.text];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(logOfTextSend)]) {
        [self.delegate logOfTextSend];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
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
