//
//  AlmacenViewController.m
//  FederalMogulM
//
//  Created by Ricardo Rojas on 07/07/18.
//  Copyright © 2018 Ricardo Rojas. All rights reserved.
//

#import "AlmacenViewController.h"
#import "UserModel.h"

@interface AlmacenViewController ()
@property (weak, nonatomic) IBOutlet UILabel *userTXT;

@end

@implementation AlmacenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.userTXT setText:[[UserModel sharedManager]userName]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:NO];
    self.title =@"";
   
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
