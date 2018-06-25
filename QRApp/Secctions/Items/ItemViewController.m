//
//  ItemViewController.m
//  QRApp
//
//  Created by Ricardo Rojas on 06/06/18.
//  Copyright © 2018 Ricardo Rojas. All rights reserved.
//

#import "ItemViewController.h"

@interface ItemViewController ()

@end

@implementation ItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO];
    self.title =@"";
}

@end
