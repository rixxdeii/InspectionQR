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
    

    // Do any additional setup after loading the view from its nib.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    [self updateifo:self.datos];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)finish:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:^{
        
        [_delegate didFinishView:nil];
        
    }];
    
}
- (IBAction)gesture:(id)sender {
    
    [self.view endEditing:YES];
}

-(void)updateifo:(NSArray *)data
{
    if ([[data firstObject] isEqualToString:@"P"]) {
        [self.noParte setText:[data objectAtIndex:1]];
        [self.cantidad setText:[NSString stringWithFormat:@"%@ %@",[data objectAtIndex:2],[data objectAtIndex:3]]];
        [self.proveedor setText:[data objectAtIndex:5]];
        [self.noLote setText:[data objectAtIndex:4]];
        [self.fecha setText:[data objectAtIndex:6]];
        [self.estatus setText:@"Falta Inspección"];
    }else{
        [self.noParte setText:[data objectAtIndex:1]];
        [self.noLote setText:[data objectAtIndex:2]];
        [self.estatus setText:([[data firstObject] isEqualToString:@"L"])?@"Liberado":@"Rechazado"];
        
    }
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
