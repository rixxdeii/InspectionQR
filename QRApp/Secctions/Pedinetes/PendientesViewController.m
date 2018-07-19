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
#import "ScannerViewController.h"

@interface PendientesViewController ()<UITableViewDelegate,UITableViewDataSource,FirebaseManagerDelegate>{
    int indexx;
}
@property (weak, nonatomic) IBOutlet UITableView *tableVieww;
@property (strong, nonatomic) InspectionViewController * insVC;
@property (weak, nonatomic) IBOutlet UILabel *subTitle;
@property (weak, nonatomic) IBOutlet UIView *viewHElper;

@end

@implementation PendientesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableVieww setDelegate:self];
    [self.tableVieww setDataSource:self];
    self.title = @"";
    
    if (!_recepcion) {
        self.subTitle.text =@"Elige la inspección para terminar la liberación.";
        [self.viewHElper setHidden:YES];
    }else{
        [self.viewHElper setHidden:NO];
        self.subTitle.text =@"Lista de productos que se encuentran en recepción";
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    
    
    if (_recepcion) {
        
        NSArray * keys=[_pendientesRecepcion allKeys];
        
        NSDictionary * childs =[_pendientesRecepcion objectForKey:[keys objectAtIndex:indexPath.section]];
        
        NSString *lote =[[childs allKeys] objectAtIndex:indexPath.row];
        
        NSDictionary * result =[childs objectForKey:lote];
        
        if ([result isKindOfClass:[NSString class]]) {
            return cell;
        }
        
        
        
        [cell.textLabel setText:[NSString stringWithFormat:@"No.Lote:%@   Cantidad:%@%@   Llegada%@",[result objectForKey:@"noLote"],[result objectForKey:@"cantidadTotalporLote"],[result objectForKey:@"unidadMedida"],[result objectForKey:@"fechaLlegada"]]];
        cell.textLabel.center = cell.contentView.center;
        
        [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
        return cell;
    }
    
    LoteModel * lot = ( LoteModel *)[_pendientes objectAtIndex:indexPath.row];
    
    
    [cell.textLabel setText:[NSString stringWithFormat:@"No.Parte:%@    No.Lote:%@",lot.noParte,lot.noLote]];
    cell.textLabel.center = cell.contentView.center;
    
    [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
    return cell;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_pendientesRecepcion) {
        NSArray * keys=[_pendientesRecepcion allKeys];
        
        NSArray * childs =[_pendientesRecepcion objectForKey:[keys objectAtIndex:section]];
        
        return childs.count;
    }
    
   
    return _pendientes.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_recepcion) {
        return [_pendientesRecepcion allKeys].count;
    }
    return 1;
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    if (_recepcion) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 0)];
        /* Create custom view to display section header... */
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, tableView.frame.size.width, 18)];
        
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setFont:[UIFont boldSystemFontOfSize:12]];
        NSString *string =[[_pendientesRecepcion allKeys]objectAtIndex:section];
        /* Section header is in 0th index... */
        [label setText:string];
        [view addSubview:label];
        [view setBackgroundColor:[UIColor colorWithRed:166/255.0 green:177/255.0 blue:186/255.0 alpha:1.0]]; //your background color...
        return view;
    }
    
    return nil;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (_recepcion) {
        
        
            NSArray * keys=[_pendientesRecepcion allKeys];

            NSDictionary * childs =[_pendientesRecepcion objectForKey:[keys objectAtIndex:indexPath.section]];

            NSString *lote =[[childs allKeys] objectAtIndex:indexPath.row];

            NSDictionary * result =[childs objectForKey:lote];
    
          [self performSegueWithIdentifier:@"scannerSegue" sender:result];
        
        return;
    }
    
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
        
    }else if([segue.identifier isEqualToString:@"scannerSegue"]) {
        ScannerViewController * VC =[segue destinationViewController];
        VC.loteRepresentation = sender;
    }
}


-(void)userLostConectionFireBase
{
    [[ERProgressHud sharedInstance]hide];
    
    UIAlertView * alert =[[UIAlertView alloc]initWithTitle:@"Error" message:@"No se pudo conctar con servidor" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    
}


@end
