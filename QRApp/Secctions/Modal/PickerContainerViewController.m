//
//  PickerContainerViewController.m
//  FederalMogulM
//
//  Created by Ricardo Rojas on 02/07/18.
//  Copyright © 2018 Ricardo Rojas. All rights reserved.
//

#import "PickerContainerViewController.h"

@interface PickerContainerViewController ()<UIPickerViewDelegate,UIPickerViewDataSource>
{
    NSString * obejctSelected;
    NSInteger indexx;
}


@end

@implementation PickerContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    obejctSelected =@"";
    indexx = 0;
    if (_data.count >0) {
        obejctSelected  =  [_data firstObject];
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _data.count;
    
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    indexx = row;
    return [_data objectAtIndex:row];
    
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    obejctSelected = [_data objectAtIndex:row];
}
    
- (IBAction)userDidSelectObject:(id)sender {
    
    
    [self dismissViewControllerAnimated:YES completion:^
    {
       [_delegate didUserSelect:obejctSelected index:indexx buttotn:_fromButton];

    }];
}




@end
