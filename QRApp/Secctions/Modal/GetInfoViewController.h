//
//  GetInfoViewController.h
//  QRApp
//
//  Created by Ricardo Rojas on 12/06/18.
//  Copyright © 2018 Ricardo Rojas. All rights reserved.
//


#import <UIKit/UIKit.h>
@protocol GetInfoDelegate
-(void)didFinishView:(NSDictionary *)data;
@end

@interface GetInfoViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *auditorTXT;
@property (weak, nonatomic) IBOutlet UITextField *emailTXT;
@property (weak, nonatomic) IBOutlet UITextField *sizeTXT;
@property (weak, nonatomic) id<GetInfoDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITextField *idInspection;

@end
