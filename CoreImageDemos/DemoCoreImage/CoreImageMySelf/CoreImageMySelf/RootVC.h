//
//  RootVC.h
//  CoreImageMySelf
//
//  Created by caigee on 14-7-4.
//  Copyright (c) 2014年 caigee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootVC : UIViewController

@property (nonatomic,strong)IBOutlet UIImageView *myImageView;

@property (nonatomic,strong)UIImage *originalImage;
@property (nonatomic,strong)CIContext *imageContext;

-(IBAction)defaultImage:(id)sender;
-(IBAction)autoImage:(id)sender;
-(IBAction)sepiaTone:(id)sender;
-(IBAction)faceDetect:(id)sender;

@end
