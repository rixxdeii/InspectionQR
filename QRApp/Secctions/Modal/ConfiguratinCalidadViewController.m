//
//  ConfiguratinCalidadViewController.m
//  FederalMogulM
//
//  Created by Ricardo Rojas on 18/07/18.
//  Copyright © 2018 Ricardo Rojas. All rights reserved.
//

#import "ConfiguratinCalidadViewController.h"

@interface ConfiguratinCalidadViewController ()
@property (weak, nonatomic) IBOutlet UITextField *ipText;

@end

@implementation ConfiguratinCalidadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)aceptar:(id)sender
{
    if ([_ipText.text isEqualToString:@""]) {
        
    }else{
        [self dismissViewControllerAnimated:YES completion:^{
            [[NSUserDefaults standardUserDefaults]setObject:_ipText.text forKey:@"ip"];
        }];
        
    }
    
    
    
}


@end
