//
//  RootVC.m
//  UIWebLoadLocalFiles
//
//  Created by caigee on 14-7-4.
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
    
    CGRect webFrame = [UIScreen mainScreen].bounds;
    UIWebView *aWebView = [[UIWebView alloc]initWithFrame:webFrame];
    aWebView.scalesPageToFit = YES;
    
    
    

//    NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
//    NSURL *url = [NSURL fileURLWithPath:htmlPath];
//    [aWebView loadRequest:[NSURLRequest requestWithURL:url]];
    
//    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"index" ofType:@"html"];
//    NSString *htmlString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
//    [aWebView loadHTMLString:htmlString baseURL:[NSURL URLWithString:filePath]];
    
    NSString *bundleFile = [[NSBundle mainBundle] pathForResource:@"xxx" ofType:@"bundle"];
    NSString *htmlFile = [bundleFile stringByAppendingPathComponent:@"/index.html"];
    
    NSData *htmlData = [NSData dataWithContentsOfFile:htmlFile];
    [aWebView loadData:htmlData MIMEType:@"text/html" textEncodingName:@"UTF-8" baseURL:[NSURL fileURLWithPath:bundleFile]];
    
    self.aWebView = aWebView;
    [self.view addSubview:aWebView];
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
