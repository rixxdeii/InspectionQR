//
//  InspectionViewController.m
//  QRApp
//
//  Created by Ricardo Rojas on 09/06/18.
//  Copyright © 2018 Ricardo Rojas. All rights reserved.
//

#import "InspectionViewController.h"
#include "LMSideBarController.h"
#import "UIViewController+LMSideBarController.h"

@interface InspectionViewController ()

@end

@implementation InspectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.infolabel setText:_textLable];
    // Do any additional setup after loading the view.
    // Init side bar styles

      [self.sideBarController showMenuViewControllerInDirection:LMSideBarControllerDirectionRight];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
