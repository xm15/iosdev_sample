//
//  DemoCoreImageViewController.m
//  DemoCoreImage
//
//  Created by Shawn Welch on 10/19/11.
//  Copyright (c) 2011 anythingsimple.com_. All rights reserved.
//

#import "DemoCoreImageViewController.h"

@implementation DemoCoreImageViewController
@synthesize imageContext = _imageContext, imageView = _imageView, originalImage = _originalImage, adjustSpinner = _adjustSpinner, faceSpinner = _faceSpinner;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _faceBoxes = [[NSMutableArray alloc] init];
        _imageContext = [CIContext contextWithOptions:nil];
        
        
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self setOriginalImage:[UIImage imageNamed:@"IMG_4230.JPG"]];
    [self.imageView setImage:_originalImage];
    
    // Create an array containing all available filter names
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
    
    NSLog(@"Number of Filters: %d",[[CIFilter filterNamesInCategory:kCICategoryBuiltIn] count]);
    
    //添加棕色的滤镜
    CIImage *myCoreImage = [CIImage imageWithCGImage:self.imageView.image.CGImage options:nil];
    
    // Create a new filter with the name CISepiaTone
    CIFilter *sepia = [CIFilter filterWithName:@"CISepiaTone"];

    // Set the input image of the sepia tone filter
    [sepia setValue:myCoreImage forKey:@"inputImage"];

    // Set the inputIntensity of the sepia tone filter
    NSNumber *intensity = [NSNumber numberWithFloat:.5f];
    [sepia setValue:intensity forKey:@"inputIntensity"];
        
    // Generate a new CIImage from the output image
    // of the sepia tone filter
    CIImage *outputImage = [sepia outputImage];

    // Render the CIImage to a CGImage and set to the image view;
    CGImageRef renderImage = [_imageContext createCGImage:outputImage fromRect:[outputImage extent]];
    [self.imageView setImage:[UIImage imageWithCGImage:renderImage]];
    
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

#pragma mark - Core Image Operations

- (CIImage*)makeBoxForFace:(CIFaceFeature*)face{
 
    CIColor *color = [CIColor colorWithRed:0 green:0 blue:1 alpha:.33];
    CIImage *image = [CIFilter filterWithName:@"CIConstantColorGenerator"
                                keysAndValues:@"inputColor", color, nil].outputImage;
    image = [CIFilter filterWithName:@"CICrop"
                       keysAndValues:kCIInputImageKey, image, @"inputRectangle",[CIVector vectorWithCGRect:face.bounds],nil].outputImage;

    return image;
}

- (void)updateFaceBoxes{
    if(_showsFacesSwith.on){
        _originalImage = self.imageView.image;
        
        CIImage *coreImage = [CIImage imageWithCGImage:_imageView.image.CGImage];
        
        // Set up desired accuracy options dictionary
        NSDictionary *options = [NSDictionary 
                                 dictionaryWithObject:CIDetectorAccuracyHigh
                                 forKey:CIDetectorAccuracy];

        // Create new CIDetector
        CIDetector *faceDetector = [CIDetector 
                                    detectorOfType:CIDetectorTypeFace
                                    context:self.imageContext 
                                    options:options];
                
        NSArray *faces = [faceDetector featuresInImage:coreImage
                                               options:nil];
        
        for(CIFaceFeature *face in faces){
            coreImage = [CIFilter filterWithName:@"CISourceOverCompositing"
                                   keysAndValues:kCIInputImageKey, [self makeBoxForFace:face],
                         kCIInputBackgroundImageKey, coreImage, nil].outputImage;
        }
        
        CGImageRef cgImage = [self.imageContext createCGImage:coreImage fromRect:[coreImage extent]];
        dispatch_async(dispatch_get_main_queue(), ^(void){  
            self.imageView.image = [UIImage imageWithCGImage:cgImage];
            [self.faceSpinner stopAnimating];
            [_showsFacesSwith setEnabled:YES];
        });
        
    }
    else{
        dispatch_async(dispatch_get_main_queue(), ^(void){
            self.imageView.image = _originalImage;
            [self.faceSpinner stopAnimating];
            [_showsFacesSwith setEnabled:YES];
        });
    }
}

- (CGImageRef)autoAdjustImage{
    CIImage *coreImage = [CIImage imageWithCGImage:_imageView.image.CGImage];
    
//    Use this dictionary to limit the effects of the auto adjustment filter    
//    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
//                             kCIImageAutoAdjustEnhance, [NSNumber numberWithBool:NO],
//                             kCIImageAutoAdjustRedEye, [NSNumber numberWithBool:YES],nil];

    // Create an array of optimized filters
    NSArray *filters = [coreImage autoAdjustmentFilters];
    NSLog(@"%@",filters);
    
    for(CIFilter *filter in filters){
        [filter setValue:coreImage forKey:kCIInputImageKey];
        coreImage = filter.outputImage;
    }
    
    
    NSLog(@"Starting CGImage Creation");
    return [self.imageContext createCGImage:coreImage fromRect:[coreImage extent]];
}


#pragma mark - IBActions

- (IBAction)actionButtonPressed:(UIBarButtonItem*)sender{
    if(_adjustmentsPopover.isPopoverVisible)
        [_adjustmentsPopover dismissPopoverAnimated:YES];
    
    if(!_actions.isVisible){
        _actions = [[UIActionSheet alloc] initWithTitle:nil 
                                               delegate:self 
                                      cancelButtonTitle:nil 
                                 destructiveButtonTitle:nil 
                                      otherButtonTitles:@"Save Image", @"Edit Image",nil];
        [_actions showFromBarButtonItem:sender animated:YES];
    }
}

- (IBAction)toggleShowsFaces:(UISwitch *)showsFacesSwitch{
    [self.faceSpinner startAnimating];
    [_showsFacesSwith setEnabled:NO];
    dispatch_async(
                   dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0),
                   ^(void){
                       [self updateFaceBoxes];
                   });
}

- (IBAction)selectSourceButtonPressed:(UIBarButtonItem*)sender{
    if(_imagePickerPopover.isPopoverVisible)
        [_imagePickerPopover dismissPopoverAnimated:YES];
    
    if(!_source.isVisible){
        _source = [[UIActionSheet alloc] initWithTitle:@"Image Source" 
                                               delegate:self 
                                      cancelButtonTitle:nil 
                                 destructiveButtonTitle:nil 
                                      otherButtonTitles:@"Photo From Photo Library", @"Photo From Camera",nil];
        [_source showFromBarButtonItem:sender animated:YES];
    }
}

- (IBAction)autoAdjustButtonPressed:(UIBarButtonItem *)sender{
    [self.adjustSpinner startAnimating];
    [sender setEnabled:NO];
    //自动优化
    dispatch_async(
       dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0),
       ^(void){
           
           
           // Create Core Image
           CGImageRef cgImg = self.imageView.image.CGImage;
           //CGImageRef cgImage = [self autoAdjustImage];
           CIImage *ciimage = [CIImage imageWithCGImage:cgImg];
           NSArray *filters  =[ciimage autoAdjustmentFilters];
           
           
           CIImage *coreImage = [CIImage imageWithCGImage:cgImg];
           
           // Iterate through all of our filters and apply
           // them to the CIImage
           for(CIFilter *filter in filters){
               [filter setValue:coreImage forKey:kCIInputImageKey];
               coreImage = filter.outputImage;
           }
           
           // Create a new CGImageRef by rendering through CIContext
           // This won't slow down main thread since we're in a background
           // dispatch queue
           CGImageRef newImg = [self.imageContext createCGImage:coreImage 
                                                       fromRect:[coreImage extent]];
           
           dispatch_async(dispatch_get_main_queue(), ^(void){
               // Update our image view on the main thread
               // You can also perform any other UI updates needed
               // here such as hidding activity spinners
               self.imageView.image = [UIImage imageWithCGImage:newImg];
               [self.adjustSpinner stopAnimating];
               [sender setEnabled:YES];
           });
       });
    
    
}



#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
 
    if([actionSheet isEqual:_source]){
        
        switch (buttonIndex) {
            case 0:{
                
                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                [picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
                [picker setDelegate:self];
                _imagePickerPopover = [[UIPopoverController alloc] initWithContentViewController:picker];
                
                [_imagePickerPopover presentPopoverFromBarButtonItem:_sourceButton 
                            permittedArrowDirections:UIPopoverArrowDirectionAny 
                                            animated:YES];
                
                break;}
            case 1:{
                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
#if TARGET_IPHONE_SIMULATOR
                [picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
#else
                [picker setSourceType:UIImagePickerControllerSourceTypeCamera];
#endif
                [picker setDelegate:self];
                _imagePickerPopover = [[UIPopoverController alloc] initWithContentViewController:picker];
                
                [_imagePickerPopover presentPopoverFromBarButtonItem:_sourceButton 
                                            permittedArrowDirections:UIPopoverArrowDirectionAny 
                                                            animated:YES];
                break;
            }
            default:
                break;
        }
    }
    else{
        switch (buttonIndex) {
            case 0:{
               
                CGImageRef cgImg = _imageView.image.CGImage;
                
                ALAssetsLibrary *library = [ALAssetsLibrary new];
                [library writeImageToSavedPhotosAlbum:cgImg
                                             metadata:nil
                                      completionBlock:^(NSURL *assetURL, NSError *error) {
                                          CGImageRelease(cgImg);
                                      }];
                break;}
            case 1:{
                
                AdjustmentsController *adjustments = [[AdjustmentsController alloc] initWithStyle:UITableViewStyleGrouped];
                [adjustments setDelegate:self];
                _adjustmentsPopover = [[UIPopoverController alloc] initWithContentViewController:adjustments];
                [_adjustmentsPopover setDelegate:self];
                [_adjustmentsPopover presentPopoverFromBarButtonItem:_actionButton permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
                
                
                break;}
            default:
                break;
        }
    }
    
}

#pragma mark UIImagePickerController Delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [_showsFacesSwith setOn:NO];
    [_imagePickerPopover dismissPopoverAnimated:YES];
    self.imageView.image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self setOriginalImage:[info objectForKey:UIImagePickerControllerOriginalImage]];
}

#pragma mark - UIPopoverControllerDelegate

#pragma mark - AdjustmentsControllerDelegate

- (void)filterName:(NSString *)filterName didUpdateFilterNumberValue:(CGFloat)newValue forAttribtueKey:(NSString *)attributeKey{
    
    if(!_applyingFilter){
        dispatch_async(
           dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),
           ^(void){
               _applyingFilter = YES;
               CIImage *image = [CIImage imageWithCGImage:_originalImage.CGImage];
               CIFilter *filter = [CIFilter filterWithName:filterName];
               [filter setValue:image forKey:kCIInputImageKey];
               [filter setValue:[NSNumber numberWithFloat:newValue] forKey:attributeKey];
               image = filter.outputImage;
                
               CGImageRef cgImage = [self.imageContext createCGImage:image fromRect:[image extent]];
               
               dispatch_async(dispatch_get_main_queue(), ^(void){
                   [self.imageView setImage:[UIImage imageWithCGImage:cgImage]];
                   CGImageRelease(cgImage);
                   _applyingFilter = NO;
               });
           }
        );
    }
    
}

- (void)didUpdateFiltersWithValues:(NSArray *)filterValues{
    if(!_applyingFilter){
        dispatch_async(
                       dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),
                       ^(void){
                           _applyingFilter = YES;
                           CIImage *image = [CIImage imageWithCGImage:_originalImage.CGImage];
                           
                           for(NSDictionary *filter in filterValues){
                               CIFilter *cif = [CIFilter filterWithName:[filter objectForKey:@"CIAttributeFilterName"]];
                               [cif setValue:image forKey:kCIInputImageKey];
                               [cif setValue:[NSNumber numberWithFloat:[[filter objectForKey:@"CIAttributeCurrentValue"] floatValue]] forKey:[filter objectForKey:@"CIAttributeFilterInputAttributeName"]];
                               image = cif.outputImage;
                           }
                           CGImageRef cgImage = [self.imageContext createCGImage:image fromRect:[image extent]];
                           
                           dispatch_async(dispatch_get_main_queue(), ^(void){
                               [self.imageView setImage:[UIImage imageWithCGImage:cgImage]];
                               CGImageRelease(cgImage);
                               _applyingFilter = NO;
                           });
                       }
                       );
    }

}

@end
