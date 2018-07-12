//
//  RegisterProductViewController.h
//  QRApp
//
//  Created by Ricardo Rojas on 05/06/18.
//  Copyright © 2018 Ricardo Rojas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemViewController.h"

#define ARR_UM @[@"mm",@"cm",@"in",@"%",@"Kg",@"g"]
#define ARR_INSTRUMENTS @[@"Visual",@"Calibrador",@"Regla",@"Micrometro",@"Laboratorio"]




@interface RegisterProductViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *UMButton;
@property (weak, nonatomic) IBOutlet UIButton *InstrumentButton;

//@property (nonatomic, weak) ItemViewController * lastVC;
@end
