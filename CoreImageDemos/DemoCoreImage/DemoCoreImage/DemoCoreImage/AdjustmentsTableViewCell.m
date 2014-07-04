//
//  AdjustmentsTableViewCell.m
//  DemoCoreImage
//
//  Created by Shawn Welch on 10/20/11.
//  Copyright (c) 2011 anythingsimple.com_. All rights reserved.
//

#import "AdjustmentsTableViewCell.h"

@implementation AdjustmentsTableViewCell
@synthesize delegate = _delegate;
@synthesize slider = _slider, attributeLabel = _attributeLabel, filterName = _filterName, attributeKey = _attributeKey;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        _slider = [[UISlider alloc] init];
        [_slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        _attributeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        
        [self.contentView addSubview:_slider];
        [self.contentView addSubview:_attributeLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Slider Target

- (void)sliderValueChanged:(UISlider*)slider{
    [_delegate sliderValueChanged:self];    
}

#pragma mark - UITableViewCell Overrides

- (void)layoutSubviews{
    [super layoutSubviews];
 
    _slider.frame = CGRectMake(10, 0, self.bounds.size.width-40, 40);

}

@end
