//
//  HistorialViewController.m
//  FederalMogulM
//
//  Created by Ricardo Rojas on 18/07/18.
//  Copyright © 2018 Ricardo Rojas. All rights reserved.
//

#import "HistorialViewController.h"
#import "FireBaseManager.h"
#import "ERProgressHud.h"
@interface HistorialViewController ()<FirebaseManagerDelegate,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>{
    
    NSInteger  indexSelected;
    BOOL isOpen ;
}
@property (nonatomic ,weak)IBOutlet UITableView * tbDescripcion;
@property (nonatomic ,weak)IBOutlet UITableView * tbProduct;
@property (nonatomic, strong) NSMutableArray * dataProduct;
@property (weak, nonatomic) IBOutlet UISearchBar *searchElement;
@property (nonatomic, strong) NSMutableArray * dataDescrip;
@property (nonatomic,strong) NSDictionary * dicCalidad;
@property (nonatomic,strong) NSDictionary * dicLiberation;
@property (nonatomic,strong) NSDictionary * dicLiberationQuimico;

@end

@implementation HistorialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    isOpen =NO;
    
    FireBaseManager * fbm =[[FireBaseManager alloc]init];
    fbm.delegate =self;
    [[ERProgressHud sharedInstance ] show];
    
    [fbm getProdctStory:@"calidad" Completion:^(BOOL isOK, NSDictionary *newModel)
    {
        self.dicCalidad = newModel;
        
        [fbm getProdctStory:@"liberation" Completion:^(BOOL isOK, NSDictionary *newModel)
         {
             self.dicLiberation = newModel;
             [fbm getProdctStory:@"liberationQuimico" Completion:^(BOOL isOK, NSDictionary *newModel)
              {
                  [[ERProgressHud sharedInstance ] hide];
                  
                  self.dicLiberationQuimico = newModel;
                  
                  _dataProduct = [[NSMutableArray  alloc]init];
  
                  for (NSString  *key in [_dicCalidad allKeys]) {
                      [_dataProduct addObject:key];
                  }
                  
//                  for (NSString  *key in [_dicLiberationQuimico allKeys])
//                  {
//                      NSArray * separate =[key componentsSeparatedByString:@"-"];
//
//                      [_dataProduct addObject:[separate firstObject]];
//                  }
                  
                   [self.tbProduct reloadData];
                  
                  NSLog(@"calidad : %@ ",_dicCalidad);
                  NSLog(@"liberation : %@ ",_dicLiberation);
                  NSLog(@"liberationQuimico : %@ ",_dicLiberationQuimico);
                  
              }];
             

             
         }];
        
        
//        _dataProduct = [newModel allKeys];
//       [self.tbProduct reloadData];
    
    }];
    
  
    
}



#pragma mark - uitableviewMethods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.tbProduct == tableView) {

        return _dataProduct.count;
    }
    
    return _dataDescrip.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell =[tableView dequeueReusableCellWithIdentifier:@"cell"forIndexPath:indexPath];
    
    if (tableView  == _tbProduct) {
        
        [cell.textLabel setText:[_dataProduct objectAtIndex:indexPath.row]];
        [cell.textLabel setTextAlignment:NSTextAlignmentCenter];

    }else{
        NSDictionary * dicRepresentation = [_dataDescrip objectAtIndex:indexPath.row];
        
        
        if ([dicRepresentation.allKeys.firstObject isEqualToString:@"subtitle"]) {
             [cell.textLabel setText: [dicRepresentation objectForKey:@"subtitle"]];
             [cell.textLabel setTextAlignment:NSTextAlignmentLeft];
             cell.backgroundColor = [UIColor clearColor];
            
        }else{
             [cell.textLabel setText: [dicRepresentation objectForKey:@"noLote"]];
             cell.backgroundColor = [UIColor lightGrayColor];
             [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
        }
        

       
    }
    
    return cell;
    
}

-(void)cleanTable
{
    NSMutableArray * arr = [[NSMutableArray alloc]init];
    
    for (NSDictionary *dic in _dataDescrip) {
        if (![dic.allKeys.firstObject isEqualToString:@"subtitle"]) {
            [arr addObject:dic];
        }
        
    }
    
    _dataDescrip = arr;
    [_tbDescripcion reloadData];
    
    
}

- (void)showNormalActionSheet:(UITableViewCell *)sender
{
    NSMutableArray * arr = [[NSMutableArray alloc]init];
    
    for (int i = 0; i< _dataDescrip.count; i++) {
         NSDictionary * dicRepresentation = [_dataDescrip objectAtIndex:i];
        [arr addObject:dicRepresentation];
        if (i == indexSelected) {
            
            NSArray * keys =[dicRepresentation allKeys];
            
            for (NSString * key in keys)
            {
                
                if (![key isEqualToString:@"muestreo"]&&![key isEqualToString:@"noLote"]) {
                    [arr addObject:@{@"subtitle":[NSString stringWithFormat:@"%@:%@",key,[dicRepresentation objectForKey:key]]}];
                }
            }

        }
        
        
    }
    
    _dataDescrip = arr;
    
    [_tbDescripcion reloadData];

//    cantidadTotalporLote = 800;
//    estatusLiberacion = Liberado;
//    fechaCaducidad = indefinida;
//    fechaLlegada = "18/07/2018";
    
//    noLote = 890;
//    noPaquetesPorPalet = 4;
//    palet = 1;
//    paquete = 1;
//    proveedor = ayer;
//    tipoProducto = "Qu\U00edmico";
//    totalPalets = 1;
//    totalPaquetes = 4;
//    unidadMedida = mm;

    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tbProduct) {
     _dataDescrip = [self searchProductNoParte:[_dataProduct objectAtIndex:indexPath.row]];
        [_tbDescripcion reloadData];
        
    }else{
        
         NSDictionary * dicRepresentation = [_dataDescrip objectAtIndex:indexPath.row];
        
        if (![dicRepresentation.allKeys.firstObject isEqualToString:@"subtitle"]) {
            if (isOpen) {
                isOpen = NO;
                indexSelected =indexPath.row;
                UITableViewCell * cell =  [_tbDescripcion cellForRowAtIndexPath:indexPath];
                [self showNormalActionSheet:cell];
                
            }else{
                isOpen = YES;
                [self cleanTable];
                
            }
            

        }
        
        
    }
    
}

#pragma  mnark - firebaseMethods


-(NSArray * )searchProductNoParte:(NSString *)noParte
{
    NSMutableArray * arrData =[[NSMutableArray alloc]init];
    
    NSDictionary * dic =[_dicLiberation objectForKey:noParte];
    
    NSArray * k =[dic allKeys];
    for (NSString *key in k)
    {
        [arrData addObject:[dic objectForKey:key]];
    }
    
    
    if (dic.count <=0 ) {
        
        NSArray * keys = [_dicLiberationQuimico allKeys];
        
        for (NSString *key in keys) {
            if( [key containsString:noParte])
            {
                NSDictionary * dic1 = [_dicLiberationQuimico objectForKey:key];
                
                NSArray * k =[dic1 allKeys];
                for (NSString *k2 in k)
                {
                    [arrData addObject:[dic1 objectForKey:k2]];
                }
                
    
            }
        
        }
        
        
    }

    return arrData;
    
}



-(void)userLostConectionFireBase
{
    [[ERProgressHud sharedInstance]hide];
    
    UIAlertView * alert =[[UIAlertView alloc]initWithTitle:@"Error" message:@"No se pudo conctar con servidor" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    
}
- (IBAction)segment:(UISegmentedControl *)sender
{
    NSString * prodcutType;
    switch (sender.selectedSegmentIndex) {
        case 0:
            prodcutType = @"Todos";
            break;
        case 1:
            prodcutType = @"Químico";
            break;
        case 2:
            prodcutType = @"Placa";
            break;
        case 3:
            prodcutType = @"Shim";
            break;

    }
    _dataProduct = [[NSMutableArray alloc]init];
    _dataDescrip =[[NSMutableArray alloc]init];
    if (sender.selectedSegmentIndex == 0) {
        for (NSString  *key in [_dicCalidad allKeys])
        {
            [_dataProduct addObject:key];
            
        }
    }

    //tipoproducto
    for (NSString  *key in [_dicCalidad allKeys])
    {
        NSDictionary * subdic =[_dicCalidad objectForKey:key];
        
        if ([[subdic objectForKey:@"tipoproducto"]isEqualToString:prodcutType]) {
            [_dataProduct addObject:key];
        }
    }
    
    [_tbProduct reloadData];
    [_tbDescripcion reloadData];
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    [self filterSearchBar:searchBar.text];
}

-(void)filterSearchBar:(NSString *)str
{
    _dataProduct = [[NSMutableArray alloc]init];
    _dataDescrip =[[NSMutableArray alloc]init];
    //tipoproducto
    for (NSString  *key in [_dicCalidad allKeys])
    {
        if ([key containsString:str]) {
            [_dataProduct addObject:key];
        }
        
        
    }
    
    [_tbProduct reloadData];
    [_tbDescripcion reloadData];
    
    
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
