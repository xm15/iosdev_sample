//
//  DemoCoreImageViewController.h
//  DemoCoreImage
//
//  Created by Shawn Welch on 10/19/11.
//  Copyright (c) 2011 anythingsimple.com_. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "AdjustmentsController.h"


@interface DemoCoreImageViewController : UIViewController <AdjustmentsControllerDelegate, UIPopoverControllerDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>{
    IBOutlet UIBarButtonItem *_sourceButton;
    IBOutlet UIBarButtonItem *_actionButton;
    IBOutlet UISwitch *_showsFacesSwith;
    
    NSMutableDictionary *_defaultFilterValues;
        
@private
    UIActionSheet *_actions;
    UIActionSheet *_source;
    NSMutableArray *_faceBoxes;
    
    BOOL _applyingFilter;
    
    UIPopoverController *_imagePickerPopover;
    UIPopoverController *_adjustmentsPopover;
}


@property (nonatomic, strong) CIContext *imageContext;
@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) UIImage *originalImage;

@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *adjustSpinner;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *faceSpinner;

- (IBAction)actionButtonPressed:(UIBarButtonItem*)sender;
- (IBAction)selectSourceButtonPressed:(UIBarButtonItem*)sender;
- (IBAction)toggleShowsFaces:(UISwitch*)showsFacesSwitch;
- (IBAction)autoAdjustButtonPressed:(UIBarButtonItem*)sender;


// Core Image Operations

- (CGImageRef)autoAdjustImage;
- (void)updateFaceBoxes;
- (CIImage*)makeBoxForFace:(CIFaceFeature*)face;

@end
