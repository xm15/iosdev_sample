//
//  AdjustmentsTableViewCell.h
//  DemoCoreImage
//
//  Created by Shawn Welch on 10/20/11.
//  Copyright (c) 2011 anythingsimple.com_. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AdjustmentsTableViewCellDelegate;
@interface AdjustmentsTableViewCell : UITableViewCell

@property (nonatomic, assign) id<AdjustmentsTableViewCellDelegate> delegate;
@property (nonatomic, strong) UISlider *slider;
@property (nonatomic, strong) UILabel *attributeLabel;
@property (nonatomic, strong) NSString *filterName, *attributeKey;


@end

@protocol AdjustmentsTableViewCellDelegate <NSObject>

- (void)sliderValueChanged:(AdjustmentsTableViewCell*)cell;

@end