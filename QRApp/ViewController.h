//
//  ViewController.h
//  QRApp
//
//  Created by Ricardo Rojas on 05/06/18.
//  Copyright © 2018 Ricardo Rojas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QRCodeGenerator.h"
#import "InspectionModel.h"

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic)  InspectionModel *inspection;

@property (weak, nonatomic) IBOutlet UILabel *idProductLabel;

@end

