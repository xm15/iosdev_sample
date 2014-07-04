//
//  AdjustmentsController.h
//  DemoCoreImage
//
//  Created by Shawn Welch on 10/20/11.
//  Copyright (c) 2011 anythingsimple.com_. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdjustmentsTableViewCell.h"

@protocol AdjustmentsControllerDelegate;
@interface AdjustmentsController : UITableViewController <AdjustmentsTableViewCellDelegate>{
 
}

@property (nonatomic, assign) id<AdjustmentsControllerDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *filters;
@property (nonatomic, strong) NSMutableArray *sliderValues, *sliderValuesDefault;

- (IBAction)sliderValueChanged:(UISlider*)sender;


@end

@protocol AdjustmentsControllerDelegate <NSObject>

- (void)filterName:(NSString*)filterName didUpdateFilterNumberValue:(CGFloat)newValue forAttribtueKey:(NSString*)attributeKey;
- (void)didUpdateFiltersWithValues:(NSArray*)filterValues;

@end