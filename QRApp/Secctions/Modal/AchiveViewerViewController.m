//
//  AchiveViewerViewController.m
//  FederalMogulM
//
//  Created by Ricardo Rojas on 27/06/18.
//  Copyright © 2018 Ricardo Rojas. All rights reserved.
//

#import "AchiveViewerViewController.h"

@interface AchiveViewerViewController ()

@end

@implementation AchiveViewerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *urlText = [NSString stringWithFormat:@"http://192.168.1.67:8888/%@.pdf" ,self.url];
    [self.webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlText]]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)dismisView:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
