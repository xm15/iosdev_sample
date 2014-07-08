//
//  RootVC.m
//  DemoCoreAnimation
//
//  Created by caigee on 14-7-7.
//  Copyright (c) 2014年 caigee. All rights reserved.
//

#import "RootVC.h"
#import "FireworksView.h"

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
    
    NSArray *names = [[NSArray alloc]initWithObjects:@"UIKit1",@"UIKit2",
    @"BasAnimal",@"KeyFrame1",@"KeyFrame2",@"Base3D",@"3DtransFo",@"CAEmitter", nil];
    
    int numbsersInRow = 3;
    int height = 30;
    int startY = self.view.bounds.size.height - height*([names count]/numbsersInRow+1);
    
    
    for (int i =0; i<[names count]; i++) {
        
        int xPoz = i %numbsersInRow;
        int yPoz = i /numbsersInRow;
        UIButton *abtn = [[UIButton alloc]initWithFrame:CGRectMake(1+xPoz*320/numbsersInRow, startY + yPoz*height, 320/numbsersInRow-1, height-2)];
        abtn.tag = i;
        [abtn setTitle:(NSString *)[names objectAtIndex:i] forState:UIControlStateNormal];
        [abtn setBackgroundColor:[UIColor grayColor]];
        [abtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        abtn.titleLabel.textAlignment = NSTextAlignmentLeft;
        [abtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:abtn];
    }
    
    // Do any additional setup after loading the view.
}

-(void)clickBtn:(UIButton *)sender
{
    for (UIView *aView in [self.view subviews]) {
        if (![aView isKindOfClass:[UIButton class]]) {
            [aView removeFromSuperview];
        }
    }
    
    switch (sender.tag) {
        case 0:
            [self doUIKitAnimationMethod1];
            break;
        case 1:
            [self doUIKitAnimationMethod2];
            break;
        case 2:
            [self doCALayerBasicAnimation];
            break;
        case 3:
            [self doCALayerKeyFrameAnimation];
            break;
        case 4:
            [self doCALayerKeyFremAnimationMethod2];
            break;
        case 5:
            [self doBase3DtransformGroupAnimation];
            break;
        case 6:
            [self do3DtransformAnimation];
            break;
        case 7:
            [self CAEmitter];
            break;
        default:
            break;
    }
}

#pragma mark ### UIKit ###

-(void)doUIKitAnimationMethod1
{
    
    UIView *box = [[UIView alloc]initWithFrame:CGRectMake(10, 10, 50.0, 50.0)];
    box.backgroundColor = [UIColor blueColor];
    
    [self.view addSubview:box];
    
    
    [UIView beginAnimations:@"box-animation" context:nil];
    [UIView setAnimationDuration:1];
    
    box.backgroundColor = [UIColor redColor];
    box.frame = CGRectMake(50.0, 50.0, 100, 100);
    box.alpha = 0.5;
    
    [UIView commitAnimations];
}
-(void)doUIKitAnimationMethod2
{
    UIView *box = [[UIView alloc]initWithFrame:CGRectMake(10, 10, 50.0, 50.0)];
    box.backgroundColor = [UIColor blueColor];
    
    [self.view addSubview:box];
    
    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        box.backgroundColor = [UIColor redColor];
        box.frame = CGRectMake(50.0, 50.0, 100, 100);
        box.alpha = 0.5;
    } completion:^(BOOL finished) {
        NSLog(@"finished");
    }];
}

#pragma mark ###Core Animation ###

-(void)doCALayerBasicAnimation
{
    UIView *box = [[UIView alloc]initWithFrame:CGRectMake(50, 50, 100.0, 100.0)];
    box.backgroundColor = [UIColor blueColor];
    [self.view addSubview:box];
    
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.toValue = (id)[UIColor yellowColor].CGColor;
    animation.duration = 1;
    animation.autoreverses = YES;
    [box.layer addAnimation:animation forKey:@"backgroundColor"];
    
    CATransition *trans = [CATransition animation];
	trans.type = kCATransitionReveal;
	trans.subtype = kCATransitionFromLeft;
	trans.duration = .5;
    [self.view.layer addAnimation:trans forKey:@"transition"];
    box.layer.backgroundColor = [UIColor blueColor].CGColor;
}
-(void)doCALayerKeyFrameAnimation
{
    UIView *box = [[UIView alloc]initWithFrame:CGRectMake(50, 50, 100.0, 100.0)];
    box.backgroundColor = [UIColor blueColor];
    [self.view addSubview:box];
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.values = [NSArray arrayWithObjects:
                        (id)box.layer.backgroundColor,
                        (id)[UIColor yellowColor].CGColor,
                        (id)[UIColor greenColor].CGColor,
                        (id)[UIColor blueColor].CGColor,nil];
    animation.duration =3;
    animation.autoreverses = NO;
    [box.layer addAnimation:animation forKey:@"backgroundColor"];
}

-(void)doCALayerKeyFremAnimationMethod2
{
    UIView *box = [[UIView alloc]initWithFrame:CGRectMake(10, 10, 50.0, 50.0)];
    box.backgroundColor = [UIColor blueColor];
    [self.view addSubview:box];
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    CGMutablePathRef aPath = CGPathCreateMutable();
    CGPathMoveToPoint(aPath, nil, 10, 10);
    CGPathAddCurveToPoint(aPath, nil, 160, 30, 220, 220, 240, 380);
    
    animation.path = aPath;
    animation.duration = 1;
    
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    animation.rotationMode = @"auto";
    [box.layer addAnimation:animation forKey:@"position"];
    box.layer.position = CGPointMake(240, 380);
    
    CFRelease(aPath);
}
-(void)doBase3DtransformGroupAnimation
{
    CABasicAnimation *flip = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
    flip.toValue = [NSNumber numberWithDouble:-M_PI];
    
    CABasicAnimation *scale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scale.toValue = [NSNumber numberWithDouble:.9];
    scale.duration = 0.5;
    scale.autoreverses = YES;
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = [NSArray arrayWithObjects:flip,scale, nil];
    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    group.duration = 1;
    group.fillMode = kCAFillModeForwards;
    group.removedOnCompletion = NO;
    
    UIView *box = [[UIView alloc]initWithFrame:CGRectMake(50, 50, 100.0, 100.0)];
    box.backgroundColor = [UIColor blueColor];
    [self.view addSubview:box];

    [box.layer addAnimation:group forKey:@"flip"];
}

-(void)do3DtransformAnimation
{
    UIView *box = [[UIView alloc]initWithFrame:CGRectMake(50, 50, 100.0, 100.0)];
    box.backgroundColor = [UIColor blueColor];
    [self.view addSubview:box];
    
    box.layer.anchorPoint = CGPointMake(1, 0.5);
    CABasicAnimation *flip = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
    flip.toValue = [NSNumber numberWithDouble:M_PI];
    flip.duration = 1.5;
    
    CATransform3D perspective = CATransform3DIdentity;
    perspective.m34 = -1.0/1000;
    perspective = CATransform3DRotate(perspective, 0, 0, 1, 0);
    box.layer.transform = perspective;
    [box.layer addAnimation:flip forKey:@"flip"];
}

-(void)CAEmitter
{
    FireworksView *fireworks = [[FireworksView alloc] initWithFrame:self.view.bounds];
    fireworks.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth;
    fireworks.backgroundColor = [UIColor blackColor];
    [self.view addSubview:fireworks];
    
    [fireworks launchFirework];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fireworksTapped:)];
    [fireworks addGestureRecognizer:tap];
}

- (void)fireworksTapped:(UITapGestureRecognizer*)tap
{
    for (UIView *aView in [self.view subviews]) {
        if (![aView isKindOfClass:[UIButton class]]) {
            [aView removeFromSuperview];
        }
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
