//
//  GetInfoViewController.m
//  QRApp
//
//  Created by Ricardo Rojas on 12/06/18.
//  Copyright © 2018 Ricardo Rojas. All rights reserved.
//

#import "GetInfoViewController.h"
#import "AuditorModel.h"

@interface GetInfoViewController ()

@end

@implementation GetInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _auditorTXT.text = [[AuditorModel sharedManager] nombre];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)finish:(id)sender {
    
    
    if (![_auditorTXT.text isEqualToString:@""]
        && ![_emailTXT.text isEqualToString:@""]
        &&![_sizeTXT.text isEqualToString:@""]
        &&![_idInspection.text isEqualToString:@""]) {
        
        
        [self dismissViewControllerAnimated:YES completion:^{
            
            [_delegate didFinishView:@{@"auditor":_auditorTXT.text,
                                       @"email":_emailTXT.text,
                                       @"sizeLot":_sizeTXT.text,
                                       @"idInspection":_idInspection.text
                                       }];
        }];
        
    }else
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Aviso" message:@"Faltan campos." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
        [alert show];
        
    }
    
   
}
- (IBAction)gesture:(id)sender {
    
    [self.view endEditing:YES];
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
