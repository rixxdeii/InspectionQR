//
//  AchiveViewerViewController.m
//  FederalMogulM
//
//  Created by Ricardo Rojas on 27/06/18.
//  Copyright © 2018 Ricardo Rojas. All rights reserved.
//

#import "AchiveViewerViewController.h"

@interface AchiveViewerViewController ()<UIAlertViewDelegate>

@end

@implementation AchiveViewerViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self createView];
}
-(void)createView{
    NSString * ip =[[NSUserDefaults standardUserDefaults]objectForKey:@"ip"];
    NSString *urlText = [NSString stringWithFormat:@"http://%@:8888/%@.pdf" ,ip,self.url];
    [self.webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlText]]];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)dismisView:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)showAlertIP:(id)sender {
    NSString * ip =[[NSUserDefaults standardUserDefaults]objectForKey:@"ip"];
    NSString * currenIP =[NSString stringWithFormat:@"IP actual %@",ip];
    
    UIAlertView * alert =[[UIAlertView alloc]initWithTitle:@"Configuración IP" message:currenIP delegate:self  cancelButtonTitle:@"Cancel" otherButtonTitles:@"Agregar", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [[NSUserDefaults standardUserDefaults]setObject:[alertView textFieldAtIndex:0].text forKey:@"ip"];
        [self createView];
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
