//
//  ShowMaterialDetailViewController.m
//  FederalMogulM
//
//  Created by Ricardo Rojas on 09/08/18.
//  Copyright © 2018 Ricardo Rojas. All rights reserved.
//

#import "ShowMaterialDetailViewController.h"
#import "CodigoBarrasModal.h"

@interface ShowMaterialDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView * tb;

@property (weak, nonatomic) IBOutlet UILabel * noParte;
@property (weak, nonatomic) IBOutlet UILabel * descrip;
@property (weak, nonatomic) IBOutlet UILabel * noLote;


@property (weak, nonatomic) IBOutlet UILabel * fecha;
@property (strong, nonatomic) NSArray * data;


@end

@implementation ShowMaterialDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _noParte.text =@"GXXXSHIM";//[_dataLast objectAtIndex:1];
    _noLote.text =@"12345678";//[_dataLast objectAtIndex:2];
    _descrip.text = @"shim descripción";
    

    _data = @[@"Estatus liberación : Liberado ",@"Nivel de Revisión : 1 ",@"No. Palet : 1 ",@"No. Paquete : 1",@"Ubicación : Calidad",@"No. Factura : 12345",@"Fecha Liberación : 19/07/2018",@"Fecha LLegada : 17/07/2018"];
    
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:NO];
    self.title =@"";
}



#pragma mark - UITableViewMethods

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell  * cell =[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.text =[_data objectAtIndex:indexPath.row];
    cell.backgroundColor =[UIColor clearColor];
    return cell;

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _data.count;;
}
- (IBAction)showBarCode:(id)sender
{
    CodigoBarrasModal * GIVC = [[CodigoBarrasModal alloc]init];
    
    
    self.definesPresentationContext = YES; //self is presenting view controller
    GIVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:GIVC animated:YES completion:nil];
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
