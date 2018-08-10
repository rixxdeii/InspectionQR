//
//  PickerContainerViewController.h
//  FederalMogulM
//
//  Created by Ricardo Rojas on 02/07/18.
//  Copyright © 2018 Ricardo Rojas. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PickerContainerDelegate

-(void)didUserSelect:(NSString *)object index:(NSInteger) index buttotn:(UIButton *)fromButton;

@end

@interface PickerContainerViewController : UIViewController
@property BOOL isDate;
@property (nonatomic, weak) id<PickerContainerDelegate> delegate;
@property (nonatomic, strong) NSArray * data;
@property (nonatomic, strong) UIButton * fromButton;

@property (weak, nonatomic) IBOutlet UIDatePicker *pickerdate;
@property (weak, nonatomic) IBOutlet UIPickerView *picker;
@property (weak, nonatomic) IBOutlet UIButton *unDefinedButton;
@property (weak, nonatomic) IBOutlet UIButton *okButton;

@end
