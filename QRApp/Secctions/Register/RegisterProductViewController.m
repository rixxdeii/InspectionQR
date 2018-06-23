//
//  RegisterProductViewController.m
//  QRApp
//
//  Created by Ricardo Rojas on 05/06/18.
//  Copyright © 2018 Ricardo Rojas. All rights reserved.
//

#import "RegisterProductViewController.h"
#import "CoreDataManager.h"

@interface RegisterProductViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITextField *descipcionTXT;
@property (weak, nonatomic) IBOutlet UITextField *idTXT;
@property (weak, nonatomic) IBOutlet UITextField *LSTXT;
@property (weak, nonatomic) IBOutlet UITextField *MTXT;
@property (weak, nonatomic) IBOutlet UITextField *LITXT;
@property (weak, nonatomic) IBOutlet UITextField *meausteTXT;
@property (weak, nonatomic) IBOutlet UITableView *tb;

@property (nonatomic, strong)NSMutableArray * arr_measures;

@end

@implementation RegisterProductViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _arr_measures = [[NSMutableArray alloc]init];
}

- (IBAction)add:(id)sender
{
    if (![_idTXT.text isEqualToString:@""]
        &&![_descipcionTXT.text isEqualToString:@""]
        &&!(_arr_measures.count <= 0))
    {
        ProductModel * p = [[ProductModel alloc]init];
        p.idProduct = _idTXT.text;
        p.descrip = _descipcionTXT.text;
        p.measures = _arr_measures;
        
        [CoreDataManager saveProduct:p];
        
        [[self navigationController] popViewControllerAnimated:YES];
    }
    else
    {
        UIAlertView  * alert = [[UIAlertView alloc]initWithTitle:@"Aviso" message:@"Faltan campos" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
        [alert show];
        
    }
    
    
    
}
- (IBAction)addMeasure:(id)sender
{
    if (![_LSTXT.text isEqualToString:@""]
        &&![_LITXT.text isEqualToString:@""]
        &&![_MTXT.text isEqualToString:@""]
        &&![_meausteTXT.text isEqualToString:@""]) {
    
        [_arr_measures addObject:@{@"MeasureName":_meausteTXT.text,
                         @"LS":_LSTXT.text,
                         @"LM":_MTXT.text,
                         @"LI":_LITXT.text
                         }];
        
        [_tb reloadData];
        _LSTXT.text = @"";
        _MTXT.text = @"";
        _LITXT.text= @"";
        
        
    }else
    {
        UIAlertView  * alert = [[UIAlertView alloc]initWithTitle:@"Aviso" message:@"Faltan medidas" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
        [alert show];
        
    }
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _arr_measures.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    NSDictionary * measure = [_arr_measures objectAtIndex:indexPath.row];
    
    NSString * name = [measure objectForKey:@"MeasureName"];
    NSString * ls = [measure objectForKey:@"LS"];
    NSString * m = [measure objectForKey:@"LM"];
    NSString * li = [measure objectForKey:@"LI"];
    
    cell.textLabel.text =[NSString stringWithFormat:@"%@: %@, %@, %@",name,ls,m,li];
    
    return cell;
    
}
- (IBAction)recognizerGesture:(id)sender
{
    [self.view endEditing:YES];
}


@end
