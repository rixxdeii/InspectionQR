//
//  AuditoriaViewController.h
//  QRApp
//
//  Created by Ricardo Rojas on 06/06/18.
//  Copyright © 2018 Ricardo Rojas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductModel.h"
#import "InspectionModel.h"

@interface AuditoriaViewController : UIViewController
@property (weak, nonatomic) ProductModel * pdroduct;
@property (weak, nonatomic) IBOutlet UILabel *idProductTXT;
@property (weak, nonatomic) IBOutlet UILabel *pageIndicatorTXT;

@end
