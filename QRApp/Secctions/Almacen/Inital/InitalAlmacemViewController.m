//
//  InitalAlmacemViewController.m
//  FederalMogulM
//
//  Created by Ricardo Rojas on 15/07/18.
//  Copyright © 2018 Ricardo Rojas. All rights reserved.
//

#import "InitalAlmacemViewController.h"
#import "UserModel.h"

@interface InitalAlmacemViewController ()


@end

@implementation InitalAlmacemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        [self.inspectorLabel setText:[NSString stringWithFormat:@"Hola %@",[[UserModel sharedManager] userName]]];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:NO];
    self.title =@"";
    
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
