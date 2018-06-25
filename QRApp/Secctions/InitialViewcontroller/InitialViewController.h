//
//  InitialViewController.h
//  QRApp
//
//  Created by Ricardo Rojas on 05/06/18.
//  Copyright © 2018 Ricardo Rojas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingsViewController.h"
#import "GetInfoViewController.h"
@interface InitialViewController : UIViewController<UIAlertViewDelegate, SettingsDelegate,GetInfoDelegate>
@property (strong, nonatomic) NSMutableArray * allowedBarcodeTypes;
@end
