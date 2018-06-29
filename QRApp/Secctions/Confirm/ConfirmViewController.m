//
//  ConfirmViewController.m
//  QRApp
//
//  Created by Ricardo Rojas on 25/06/18.
//  Copyright © 2018 Ricardo Rojas. All rights reserved.
//

#import "ConfirmViewController.h"
#import "FireBaseManager.h"

@interface ConfirmViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *noParte;
@property (weak, nonatomic) IBOutlet UILabel *descrip;
@property (strong, nonatomic)  NSMutableArray *data;
@property (weak, nonatomic) IBOutlet UILabel *fecha;

@end

@implementation ConfirmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _noParte.text = _product.noParte;
    _descrip.text =_product.descript;
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    // or @"yyyy-MM-dd hh:mm:ss a" if you prefer the time with AM/PM
    NSLog(@"%@",[dateFormatter stringFromDate:[NSDate date]]);
    
    _fecha.text = [dateFormatter stringFromDate:[NSDate date]];
    
    _data = [[NSMutableArray alloc]init];
    [_data addObject:[NSString stringWithFormat:@"Nivel de Revisión: %@",_product.nivelRevision]];
    [_data addObject:[NSString stringWithFormat:@"Tamaño de muestra: %@",_product.muestra]];
    [_data addObject:[NSString stringWithFormat:@"AlmecenarFrio: %@",_product.almacenaje]];
    [_data addObject:[NSString stringWithFormat:@"Tipo de producto: %@",_product.tipoproducto]];
    [self getSpecifications:_product.especificaciones];

}

-(void)getSpecifications:(NSArray *)arr
{
    for (NSDictionary  * arrHelper in arr) {
        
                    NSString * name = [arrHelper objectForKey:@"MeasureName"];
                    NSString * ls = [arrHelper objectForKey:@"LS"];
                    NSString * m = [arrHelper objectForKey:@"LM"];
                    NSString * li = [arrHelper objectForKey:@"LI"];
                    NSString * tipoInstrumento = [arrHelper objectForKey:@"tipoIstrumento"];
        
        
            if ([ls isEqualToString:@""]) {
                
                [_data addObject:[NSString stringWithFormat:@"%@    OK   %@",name,tipoInstrumento]];
            }else{
                [_data addObject:[NSString stringWithFormat:@"%@:  Targ: %@   Tol: %@  UM: %@  %@",name,li,ls,m,tipoInstrumento]];
                
            }
        
    }
}



-(void)viewDidAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO];
    self.title =@"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)userDidTapConfirm:(id)sender
{
    [FireBaseManager saveGProduct:_product];
    [self performSegueWithIdentifier:@"segue" sender:nil];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _data.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.text =[_data objectAtIndex:indexPath.row];
    
    return  cell;
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)GPStatusChanged:(GenericProductModel *)newModel {
    
}

- (void)SPStatusChanged:(SpecificProductModel *)newModel {
    
}



@end
