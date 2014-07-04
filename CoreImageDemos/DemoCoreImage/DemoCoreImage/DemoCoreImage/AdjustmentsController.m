//
//  AdjustmentsController.m
//  DemoCoreImage
//
//  Created by Shawn Welch on 10/20/11.
//  Copyright (c) 2011 anythingsimple.com_. All rights reserved.
//

#import "AdjustmentsController.h"

@implementation AdjustmentsController
@synthesize delegate = _delegate;
@synthesize filters = _filters, sliderValues = _sliderValues, sliderValuesDefault = _sliderValuesDefault;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //If you want to just get all of the available filters, use the code below
        //NSArray *possibleFilters = [CIFilter filterNamesInCategory:kCICategoryStillImage];
        
        // Otherwise we specify the filters we want
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
        
        _filters = [[NSMutableArray alloc] init];
        _sliderValues = [[NSMutableArray alloc] init];
        
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
                                [_sliderValues addObject:slide];
                            }
                            
                        }
                    }
                    
                }
            }
            
        }
        NSLog(@"%@",_filters);
        // _sliderValuesDefault，_sliderValues 保存的是CIAttributeFilterName CIAttributeIdentity
        // _sliderValues 可改变
        _sliderValuesDefault = [_sliderValues mutableCopy];
        
    
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tableView.allowsSelection = NO;
    
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
    [footer setBackgroundColor:[UIColor clearColor]];
    UIButton *reset = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [reset setTitle:@"Reset to Default Values" forState:UIControlStateNormal];
    reset.frame = CGRectMake(10, 10, 300, 40);
    [reset addTarget:self action:@selector(reset:) forControlEvents:UIControlEventTouchUpInside];
    [footer addSubview:reset];
    
    
    
    [self.tableView setTableFooterView:footer];
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
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [_filters count];
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    
    NSString *header = [NSString stringWithFormat:@"%@: %@",
                        [[_filters objectAtIndex:section] objectForKey:@"CIAttributeFilterDisplayName"],
                        [[_filters objectAtIndex:section] objectForKey:@"CIAttributeFilterInputAttributeName"]];
                        
                        
    return header;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
       
    NSDictionary *filterAttributes = [_filters objectAtIndex:indexPath.section];
    AdjustmentsTableViewCell *cell = (AdjustmentsTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[AdjustmentsTableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier];
        [cell setDelegate:self];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    [cell setAttributeKey:[filterAttributes objectForKey:@"CIAttributeFilterInputAttributeName"]];
    [cell setFilterName:[filterAttributes objectForKey:@"CIAttributeFilterName"]];
    
    [cell.slider setMinimumValue:[[[filterAttributes objectForKey:@"CIAttributeFilterInputAttributes"] objectForKey:@"CIAttributeSliderMin"] floatValue]];
    [cell.slider setMaximumValue:[[[filterAttributes objectForKey:@"CIAttributeFilterInputAttributes"] objectForKey:@"CIAttributeSliderMax"] floatValue]]; 
    
    [cell.slider setValue:[[[_sliderValues objectAtIndex:indexPath.section] objectForKey:@"CIAttributeCurrentValue"] floatValue]]; 

    return cell;
}    


#pragma mark - AdjustmentsTableViewCellDelegate;

- (void)sliderValueChanged:(AdjustmentsTableViewCell*)cell{

    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    //[_delegate filterName:cell.filterName didUpdateFilterNumberValue:cell.slider.value forAttribtueKey:cell.attributeKey];

    NSMutableDictionary *value = [[_sliderValues objectAtIndex:indexPath.section] mutableCopy];
    [value setValue:[NSNumber numberWithFloat:cell.slider.value] forKey:@"CIAttributeCurrentValue"];
    [_sliderValues replaceObjectAtIndex:indexPath.section withObject:value];
    
    [_delegate didUpdateFiltersWithValues:[_sliderValues copy]];
    
}

#pragma mark - Button Actions
- (void)reset:(id)sender{
 
    [self.tableView reloadData];
    _sliderValues = [_sliderValuesDefault mutableCopy];
    [_delegate didUpdateFiltersWithValues:[_sliderValues copy]];
    
}

@end
