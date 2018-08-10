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
    
    NSDate *today = [[NSDate alloc] init];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setYear:9];

    if (_isDate) {
        [self.unDefinedButton setHidden:NO];
        
        [self.picker setHidden:YES];
        [self.pickerdate setDate:[NSDate date]];
        [self.pickerdate setMinimumDate:[NSDate date]];
        [self.pickerdate setMaximumDate:[gregorian dateByAddingComponents:offsetComponents toDate:today options:0]];
        self.pickerdate.datePickerMode = UIDatePickerModeDate;
        self.pickerdate.backgroundColor = [UIColor whiteColor];
        self.pickerdate.alpha =1;
    }else{
        [self.unDefinedButton setHidden:YES];
    [self.pickerdate setHidden:YES];
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
         if (_isDate) {
             NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
             [formatter setFormatterBehavior:NSDateFormatterBehavior10_4];
             [formatter setDateStyle:NSDateFormatterShortStyle];
             [formatter setTimeStyle:NSDateFormatterNoStyle];
             NSString *result = [formatter stringFromDate:self.pickerdate.date];
             
             [_delegate didUserSelect:result index:nil buttotn:nil];
             
         }else{
             [_delegate didUserSelect:obejctSelected index:indexx buttotn:_fromButton];
         }
         
         
         
     }];
}

- (IBAction)userDidTapUndefinedButton:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^
     {
         [_delegate didUserSelect:@"Indefinido" index:nil buttotn:nil];
     }];
}
- (IBAction)getValue:(UIDatePicker *)sender
{

    
}



@end
