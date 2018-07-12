//
//  RegisterUserModalViewController.h
//  QRApp
//
//  Created by Ricardo Rojas on 23/06/18.
//  Copyright © 2018 Ricardo Rojas. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol registerUserDlegate
-(void)finishUserRegistration;
@end

@interface RegisterUserModalViewController : UIViewController

@property(nonatomic, weak) id<registerUserDlegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *image;
@property (weak, nonatomic) IBOutlet UITextField *nombre;
@property (weak, nonatomic) IBOutlet UITextField *IDEmpleado;
@property (weak, nonatomic) IBOutlet UITextField *contrasenaa;
@property (weak, nonatomic) IBOutlet UITextField *email;

@end
