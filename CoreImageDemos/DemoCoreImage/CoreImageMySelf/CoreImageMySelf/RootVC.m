//
//  RootVC.m
//  CoreImageMySelf
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
    self.originalImage = [UIImage imageNamed:@"test.JPG"];
    self.myImageView.image = self.originalImage;
    
    self.imageContext = [CIContext contextWithOptions:nil];
    
    [self printAllAccessoryFilters];
    
    [self printAllNumberValueableFilters];
    // Do any additional setup after loading the view from its nib.
}

// 打印所有可用的 Filters
- (void)printAllAccessoryFilters
{
    NSArray *filters = [CIFilter filterNamesInCategory:kCICategoryBuiltIn];
    
    // Iterate through each filter name
    // and output that filter's attributes to the console
    for(NSString *filter in filters){
        
        // Create a new filter with the filter name
        CIFilter *myFilter = [CIFilter filterWithName:filter];
        
        // Output the filter name and attributes to the console
        NSLog(@"%@",filter);
        NSLog(@"%@",[myFilter attributes]);
    }
    
    NSLog(@"Filters的个数是: %d",[[CIFilter filterNamesInCategory:kCICategoryBuiltIn] count]);
}

// 打印可以设置数值的 Filters
-(void)printAllNumberValueableFilters
{
    NSArray *possibleFilters = [NSArray arrayWithObjects:
                                @"CIColorControls",
                                @"CIGaussianBlur",
                                @"CIColorMonochrome",
                                @"CIExposureAdjust",
                                @"CIGammaAdjust",
                                @"CIHighlightShadowAdjust",
                                @"CIHueAdjust",
                                @"CISepiaTone",
                                @"CITemperatureAndTint",
                                @"CIVibrance",
                                @"CIVignette",
                                @"CIStraightenFilter", nil];
    
    NSMutableArray * _filters = [[NSMutableArray alloc] init];
    
    NSArray *exlcude = [NSArray arrayWithObjects:@"CICheckerboardGenerator", @"CIGaussianGradient", @"CIRadialGradient",@"CIStripesGenerator", nil];
    
    
    for(NSString *filterName in possibleFilters){
        if(![exlcude containsObject:filterName]){
            NSDictionary *attributes = [[CIFilter filterWithName:filterName] attributes];
            
            for(NSString *key in attributes){
                id value = [attributes objectForKey:key];
                //CIAttributeFilterName 作为唯一标示
                if([[value class] isSubclassOfClass:[NSDictionary class]]){
                    if([value valueForKey:@"CIAttributeClass"]){
                        
                        if([[value objectForKey:@"CIAttributeClass"] isEqualToString:@"NSNumber"] &&
                           ([[value objectForKey:@"CIAttributeType"] isEqualToString:@"CIAttributeTypeScalar"] ||
                            [[value objectForKey:@"CIAttributeType"] isEqualToString:@"CIAttributeTypeAngle"] ||
                            [[value objectForKey:@"CIAttributeType"] isEqualToString:@"CIAttributeTypeDistance"])){
                               
                               NSMutableDictionary *attr = [[NSMutableDictionary alloc] init];
                               [attr setValue:key forKey:@"CIAttributeFilterInputAttributeName"];
                               [attr setValue:[attributes objectForKey:key] forKey:@"CIAttributeFilterInputAttributes"];
                               [attr setValue:[attributes objectForKey:@"CIAttributeFilterDisplayName"] forKey:@"CIAttributeFilterDisplayName"];
                               [attr setValue:[attributes objectForKey:@"CIAttributeFilterName"] forKey:@"CIAttributeFilterName"];
                               
                               [_filters addObject:attr];
                               
                               
                               NSMutableDictionary *slide = [[NSMutableDictionary alloc] init];
                               [slide setValue:[attributes objectForKey:@"CIAttributeFilterName"] forKey:@"CIAttributeFilterName"];
                               [slide setValue:[[attributes objectForKey:key] objectForKey:@"CIAttributeIdentity"] forKey:@"CIAttributeCurrentValue"];
                               [slide setValue:key forKey:@"CIAttributeFilterInputAttributeName"];
                
                           }
                        
                    }
                }
                
            }
        }
        
    }
    NSLog(@"可以设置数值的 Fliters:\n%@",_filters);
}


-(IBAction)defaultImage:(id)sender
{
    self.originalImage = [UIImage imageNamed:@"test.JPG"];
    self.myImageView.image = self.originalImage;
}

-(IBAction)autoImage:(id)sender
{
    [sender setEnabled:NO];
    //自动优化
    dispatch_async(
                   dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0),
                   ^(void){
                       // 创建CIImage
                       CGImageRef cgImg = self.myImageView.image.CGImage;
                       CIImage *coreImage = [CIImage imageWithCGImage:cgImg];
                       
                       // 通过系统方法获得自动优化Filters 过滤器
                       NSArray *filters  =[coreImage autoAdjustmentFilters];
                       
                       
                       // 正确：遍历Filters，并且把处理的结果作为下一次遍历的输入，可以更加有效地使用系统的处理功能
                       // 错误的方法是生成image之后，又重新生成CIImage，输入过滤器，生成图片。
                       for(CIFilter *filter in filters){
                           [filter setValue:coreImage forKey:kCIInputImageKey];
                           coreImage = filter.outputImage;
                       }
                       
                       // 通过CIContext 生成新的CGImageRef
                       CGImageRef newImg = [self.imageContext createCGImage:coreImage
                                                                   fromRect:[coreImage extent]];
                       // 之前的代码都是在后台运行，当需要更新界面元素的时候，就需要切换到 main_queue 中
                       dispatch_async(dispatch_get_main_queue(), ^(void){
                           self.myImageView.image = [UIImage imageWithCGImage:newImg];

                           [sender setEnabled:YES];
                       });
                   });

}

-(IBAction)sepiaTone:(id)sender
{
    //添加棕色的滤镜
    CIImage *myCoreImage = [CIImage imageWithCGImage:self.myImageView.image.CGImage options:nil];
    
    // 创建Filter，@"CISepiaTone"这个名字是系统指定的
    CIFilter *sepia = [CIFilter filterWithName:@"CISepiaTone"];
    
    // 设置Filter
    [sepia setValue:myCoreImage forKey:@"inputImage"];
    
    NSNumber *intensity = [NSNumber numberWithFloat:.5f];
    [sepia setValue:intensity forKey:@"inputIntensity"];
    
    // 生成新的 CIImage
    CIImage *outputImage = [sepia outputImage];
    
    // 取出UIImage
    CGImageRef renderImage = [_imageContext createCGImage:outputImage fromRect:[outputImage extent]];
    [self.myImageView setImage:[UIImage imageWithCGImage:renderImage]];
}


- (CIImage*)makeBoxForFace:(CIFaceFeature*)face{
    
    CIColor *color = [CIColor colorWithRed:0 green:0 blue:1 alpha:.33];
    CIImage *image = [CIFilter filterWithName:@"CIConstantColorGenerator"
                                keysAndValues:@"inputColor", color, nil].outputImage;
    image = [CIFilter filterWithName:@"CICrop"
                       keysAndValues:kCIInputImageKey, image, @"inputRectangle",[CIVector vectorWithCGRect:face.bounds],nil].outputImage;
    
    return image;
}

-(IBAction)faceDetect:(id)sender
{
    _originalImage = self.myImageView.image;
    
    CIImage *coreImage = [CIImage imageWithCGImage:_originalImage.CGImage];
    
    // 设置检测的精确度
    NSDictionary *options = [NSDictionary
                             dictionaryWithObject:CIDetectorAccuracyHigh
                             forKey:CIDetectorAccuracy];
    
    // 创建检测器
    CIDetector *faceDetector = [CIDetector
                                detectorOfType:CIDetectorTypeFace
                                context:self.imageContext
                                options:options];
    
    NSArray *faces = [faceDetector featuresInImage:coreImage
                                           options:nil];
    //CISourceOverCompositing 过滤器是叠加用的，生成脸部框
    for(CIFaceFeature *face in faces){
        coreImage = [CIFilter filterWithName:@"CISourceOverCompositing"
                               keysAndValues:kCIInputImageKey, [self makeBoxForFace:face],
                     kCIInputBackgroundImageKey, coreImage, nil].outputImage;
    }
    
    CGImageRef cgImage = [self.imageContext createCGImage:coreImage fromRect:[coreImage extent]];
    dispatch_async(dispatch_get_main_queue(), ^(void){
        self.myImageView.image = [UIImage imageWithCGImage:cgImage];
    });

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
