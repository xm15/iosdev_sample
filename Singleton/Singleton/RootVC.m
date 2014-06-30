//
//  RootVC.m
//  Singleton
//
//  Created by caigee on 14-6-29.
//  Copyright (c) 2014年 caigee. All rights reserved.
//

#import "RootVC.h"
#import "UIView+UpsideDown.h"
#import "Singleton.h"

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
    UILabel *aLabel = [[UILabel alloc]initWithFrame:CGRectMake(20.0, 100.0, 200.0, 40.0)];
    [aLabel setBackgroundColor:[UIColor grayColor]];
    [aLabel setText:@"类别的使用"];
    [aLabel upsideDown];            //这一句话使用了类别
    [self.view addSubview:aLabel];
    [aLabel release];
    
    
    [self testSigleTon];
    // Do any additional setup after loading the view.
}

-(void)testSigleTon
{
    //单例的结果就是，调用类方法，只返回一个共有的对象
    Singleton *single = [Singleton sharedInstance];
    Singleton *single2 = [Singleton sharedInstance];
    if (single == single2) {
        NSLog(@"两个单例方法生成的对象指向同一个对象");
    }
    
    
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
