//
//  PendientesViewController.m
//  FederalMogulM
//
//  Created by Ricardo Rojas on 06/07/18.
//  Copyright © 2018 Ricardo Rojas. All rights reserved.
//

#import "PendientesViewController.h"
#import "FireBaseManager.h"
#import "ERProgressHud.h"
#import "InspectionViewController.h"

@interface PendientesViewController ()<UITableViewDelegate,UITableViewDataSource,FirebaseManagerDelegate>{
    int indexx;
}
@property (weak, nonatomic) IBOutlet UITableView *tableVieww;
@property (strong, nonatomic) InspectionViewController * insVC;

@end

@implementation PendientesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableVieww setDelegate:self];
    [self.tableVieww setDataSource:self];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    LoteModel * lot = ( LoteModel *)[_pendientes objectAtIndex:indexPath.row];
    
    
    [cell.textLabel setText:[NSString stringWithFormat:@"No.Parte:%@    No.Lote:%@",lot.noParte,lot.noLote]];
    cell.textLabel.center = cell.contentView.center;
    
    [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
    return cell;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _pendientes.count;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    indexx =indexPath.row ;
    FireBaseManager * fbm =[[FireBaseManager alloc]init];
    fbm.delegate =self;
    [[ERProgressHud sharedInstance ] show];
    LoteModel * lot = ( LoteModel *)[_pendientes objectAtIndex:indexPath.row];
    
    [fbm getGProduct:lot.noParte completion:^(BOOL isOK, BOOL Exist, GenericProductModel *newModel)
     {
         [[ERProgressHud sharedInstance ] hide];
         
         if (isOK) {
             
             if (Exist){
                 
                 [self performSegueWithIdentifier:@"inspectionSegue" sender:@[lot,newModel]];
                 
             }else{
                 UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Aviso" message:@"Código fuera de control." delegate:self cancelButtonTitle:@"Aceptar" otherButtonTitles:nil, nil];
                 [alert show];
                 
             }
             
         }else{
             [self userLostConectionFireBase];
         }
     }];
    
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"inspectionSegue"])
    {
        self.insVC = (InspectionViewController *)[self.storyboard instantiateViewControllerWithIdentifier: @"InspectionViewController"];
        self.insVC  = segue.destinationViewController;
        
        self.insVC.lote =[sender firstObject];
        self.insVC.product =[sender lastObject];
        self.insVC.comefromPendiente =YES;
        self.insVC.pendenteInexx =indexx;
        
    }
}


-(void)userLostConectionFireBase
{
    [[ERProgressHud sharedInstance]hide];
    
    UIAlertView * alert =[[UIAlertView alloc]initWithTitle:@"Error" message:@"No se pudo conctar con servidor" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    
}


@end
