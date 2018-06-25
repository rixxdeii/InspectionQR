//
//  RegisterUserModalViewController.h
//  QRApp
//
//  Created by Ricardo Rojas on 23/06/18.
//  Copyright © 2018 Ricardo Rojas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterUserModalViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *image;
@property (weak, nonatomic) IBOutlet UITextField *nombre;
@property (weak, nonatomic) IBOutlet UIView *IDEmpleado;
@property (weak, nonatomic) IBOutlet UITextField *contraseña;
@property (weak, nonatomic) IBOutlet UITextField *email;

@end
