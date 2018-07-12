//
//  ExitoViewController.m
//  FederalMogulM
//
//  Created by Ricardo Rojas on 30/06/18.
//  Copyright © 2018 Ricardo Rojas. All rights reserved.
//

#import "ExitoViewController.h"
#import "ItemViewController.h"

@interface ExitoViewController ()

@end

@implementation ExitoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)userDidTapFinish:(id)sender {
    
    [self.navigationController popToViewController:[[self.navigationController viewControllers]objectAtIndex:1] animated:YES];
    
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
