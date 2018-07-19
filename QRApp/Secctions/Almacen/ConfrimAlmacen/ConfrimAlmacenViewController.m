//
//  ConfrimAlmacenViewController.m
//  FederalMogulM
//
//  Created by Ricardo Rojas on 16/07/18.
//  Copyright © 2018 Ricardo Rojas. All rights reserved.
//

#import "ConfrimAlmacenViewController.h"
#import "PrintViewController.h"
#import "FireBaseManager.h"
#import "ERProgressHud.h"



@interface ConfrimAlmacenViewController ()<UITableViewDelegate,UITableViewDataSource,FirebaseManagerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tb;
@property (weak, nonatomic) IBOutlet UILabel *fecha;

@end

@implementation ConfrimAlmacenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _noParte.text = _lote.noParte;
    _noLote.text = _lote.noLote;
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    // or @"yyyy-MM-dd hh:mm:ss a" if you prefer the time with AM/PM
    NSLog(@"%@",[dateFormatter stringFromDate:[NSDate date]]);
    
    _fecha.text = [dateFormatter stringFromDate:[NSDate date]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - uitableviewMethods

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    NSString * str = [_data objectAtIndex:indexPath.row];
    
    cell.textLabel.text = str;
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.backgroundColor =[UIColor clearColor];
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _data.count;
}

#pragma mark - navigationsMethods

-(IBAction)userDidTapContinueButton:(id)sender
{
    
    
    
    FireBaseManager * fbm =[[FireBaseManager alloc]init];
    [[ERProgressHud sharedInstance]show];
    [fbm saveLote:_lote completion:^(BOOL isOK) {
    [[ERProgressHud sharedInstance]hide];
        if (isOK) {
            
           [self  performSegueWithIdentifier:@"segueExito" sender:nil];
            
        }else{
            
        }
        
    }];
    
    
    
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"segueExito"]) {
        
        PrintViewController * vc =[segue destinationViewController];
        vc.lote= _lote;
        
    }
    
}


- (void)userLostConectionFireBase {
    [[ERProgressHud sharedInstance] hide];
    UIAlertView * alert =[[UIAlertView alloc]initWithTitle:@"Error" message:@"No se puido conectar con servidor." delegate:self cancelButtonTitle:@"Aceptar" otherButtonTitles:nil, nil];
    
    [alert show];
    
}

@end
