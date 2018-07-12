//
//  ConfirmViewController.m
//  QRApp
//
//  Created by Ricardo Rojas on 25/06/18.
//  Copyright © 2018 Ricardo Rojas. All rights reserved.
//

#import "ConfirmViewController.h"
#import "FireBaseManager.h"
#import "QRCodeGenerator.h"
#import "ERProgressHud.h"
#import <MessageUI/MessageUI.h>
#import "CoreDataManager.h"
#import "CodigoBarrasModal.h"

@interface ConfirmViewController ()<UITableViewDelegate,UITableViewDataSource,FirebaseManagerDelegate,MFMailComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *noParte;
@property (weak, nonatomic) IBOutlet UILabel *descrip;
@property (strong, nonatomic)  NSMutableArray *data;
@property (weak, nonatomic) IBOutlet UILabel *fecha;
@property (weak, nonatomic) IBOutlet UILabel *QRLabel;
@property (weak, nonatomic) IBOutlet UIImageView *QRImage;
@property (weak, nonatomic) IBOutlet UIButton *continueBtn;
@property (weak, nonatomic) IBOutlet UILabel *indicatorlabel;

@end

@implementation ConfirmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _data = [[NSMutableArray alloc]init];
    
    self.title = @"";
    
    if ([_comeFrom isEqualToString:@"registroLiberacion"] ) {
        _noParte.text = _lote.noParte;
        _descrip.text =_product.descript;
        [_QRImage setHighlighted:NO];
        [_QRLabel setHighlighted:NO];
        
        
        [_QRLabel setText:[NSString stringWithFormat:@"%@-%@",_lote.noParte,_lote.noLote]];
        
        _QRImage.image =[[[QRCodeGenerator alloc] initWithString:_QRLabel.text] getImage];
        
        
        [_data addObject:[NSString stringWithFormat:@"Estado: %@",_lote.estatusLiberacion]];
        [_data addObject:[NSString stringWithFormat:@"Cantida por lote: %@",_lote.cantidadTotalporLote]];
        [_data addObject:[NSString stringWithFormat:@"Auditor: %@",[[UserModel sharedManager]userName]]];
        [_data addObject:[NSString stringWithFormat:@"Auditor Codigo: %@",[[UserModel sharedManager]userCode]]];
        // [_data addObject:[NSString stringWithFormat:@"Fecha de legada: %@",_lote]];
        //[_data addObject:[NSString stringWithFormat:@"Turno: %@",_lote.estatusLiberacion]];
        // [_data addObject:[NSString stringWithFormat:@"Fecha manufactura: %@",_lote.estatusLiberacion]];
        // [_data addObject:[NSString stringWithFormat:@"Lote indirecto: %@",_lote.estatusLiberacion]];
        
        [self printSpesificaciones:_lote.muestreo];
        
    }else if ([_comeFrom isEqualToString:@"registroProducto"]){
        [_QRImage setHighlighted:YES];
        [_QRLabel setHighlighted:YES];
        _noParte.text = _product.noParte;
        _descrip.text =_product.descript;
        
        [_data addObject:[NSString stringWithFormat:@"Nivel de Revisión: %@",_product.nivelRevision]];
        [_data addObject:[NSString stringWithFormat:@"Tamaño de muestra: %@",_product.muestra]];
        [_data addObject:[NSString stringWithFormat:@"AlmecenarFrio: %@",_product.almacenaje]];
        [_data addObject:[NSString stringWithFormat:@"Tipo de producto: %@",_product.tipoproducto]];
        [self getSpecificationsRegister:_product.especificaciones];
        
    }else{// ScanerInitial
        [_indicatorlabel setText:@""];
        [_continueBtn setTitle:@"Código de barras" forState: UIControlStateNormal ];
//        _continueBtn.backgroundColor =[UIColor colorWithRed:22.0f/255.0f
//                                                      green:176.0f/255.0f
//                                                       blue:65.0f/255.0f
//                                                      alpha:1.0f];
//        _noParte.text = _barcode.noParte;
        _descrip.text =_product.descript;
        [_QRImage setHighlighted:NO];
        [_QRLabel setHighlighted:NO];
        
        [_QRLabel setText:[NSString stringWithFormat:@"%@-%@",_barcode.noParte,_barcode.noLote]];
        
        _QRImage.image =[[[QRCodeGenerator alloc] initWithString:_QRLabel.text] getImage];
        
        if (_existLote) {
            [_data addObject:[NSString stringWithFormat:@"Estatus: %@",_lote.estatusLiberacion]];
            [_data addObject:[NSString stringWithFormat:@"Inspector: %@",_product.nivelRevision]];
            [_data addObject:[NSString stringWithFormat:@"No. Lote: %@",_product.muestra]];
            [_data addObject:[NSString stringWithFormat:@"No. Palet: %@",_product.almacenaje]];
            [_data addObject:[NSString stringWithFormat:@"Paquete: %@",_product.tipoproducto]];
            [_data addObject:[NSString stringWithFormat:@"Caducidad: %@",_product.tipoproducto]];
            [_data addObject:[NSString stringWithFormat:@"Fecha Liberacion: %@",_product.tipoproducto]];
        }else{
        
        [_data addObject:[NSString stringWithFormat:@"Estatus: %@",_lote.estatusLiberacion]];
        [_data addObject:[NSString stringWithFormat:@"Inspector: %@",_product.nivelRevision]];
        [_data addObject:[NSString stringWithFormat:@"No. Palet: %@",_barcode.palet]];
        [_data addObject:[NSString stringWithFormat:@"Paquete: %@",_barcode.paquete]];
        [_data addObject:[NSString stringWithFormat:@"Caducidad: %@",_product.tipoproducto]];
        [_data addObject:[NSString stringWithFormat:@"Fecha Liberacion: %@",_product.tipoproducto]];
        [_data addObject:[NSString stringWithFormat:@"Fecha Fecha Caducidad: %@",_barcode.fechaCad]];
        }
    }
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    // or @"yyyy-MM-dd hh:mm:ss a" if you prefer the time with AM/PM
    NSLog(@"%@",[dateFormatter stringFromDate:[NSDate date]]);
    
    _fecha.text = [dateFormatter stringFromDate:[NSDate date]];
    
    
    
}

-(void)printSpesificaciones:(NSMutableDictionary *)dic{
    
    
    
    NSArray * dicKeys = [dic allKeys];
    [_data addObject:@"RESULTADO DE MUESTRA:" ];
    
    int indexx = 1;
    int keyIndex = 0;
    
    for (NSString *object in dicKeys) {
        if ([[dic objectForKey:object] isKindOfClass:[NSDictionary class]]||[[dic objectForKey:object] isKindOfClass:[NSMutableDictionary class]]) {
            NSDictionary * subDic = [dic objectForKey:object];
            NSArray * arr =[subDic allKeys];
            [_data addObject:[dicKeys objectAtIndex:keyIndex]];//[NSString stringWithFormat:@"MUESTRA %i",indexx]];
            keyIndex ++;
            
            for (NSString *str in arr) {
                
                NSDictionary * dicHelper =[subDic objectForKey:str];
                
                if ([dicHelper isKindOfClass:[NSDictionary class]]||[dicHelper isKindOfClass:[NSMutableDictionary class]]) {
                    NSString *dataToShow = [NSString stringWithFormat:@"%@    Resultado:%@    %@",[dicHelper objectForKey:@"MeasureName"],[dicHelper objectForKey:@"medidaReal"],[dicHelper objectForKey:@"estatus"]];
                    [_data addObject:dataToShow];
                }
                
            }
            
            
        }else{
            
            NSArray * subArray=[dic objectForKey:object];
            [_data addObject:[NSString stringWithFormat:@"MUESTRA %i",indexx]];
            for (NSDictionary * str in subArray) {
                
                if (![[str objectForKey:@"LI"]isEqualToString:@"Toelrancia"]) {
                    NSString * dataToShow = [NSString stringWithFormat:@"%@    Resultado:%@    %@",[str objectForKey:@"MeasureName"],[str objectForKey:@"medidaReal"],[str objectForKey:@"status"]];
                    [_data addObject:dataToShow];
                    
                }
                
            }
            indexx++;
        }
        
    }
    
    
}

-(void)getSpecificationsRegister:(NSDictionary *)dic
{
    NSArray * arr = [dic objectForKey:@"especificaciones"];
    
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
- (IBAction)userDidTapConfirm:(UIButton *)sender
{
    
    if ([sender.titleLabel.text isEqualToString:@"Código de barras"]) {
        
        CodigoBarrasModal * GIVC = [[CodigoBarrasModal alloc]init];
        
        
        self.definesPresentationContext = YES; //self is presenting view controller
        GIVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [self presentViewController:GIVC animated:YES completion:nil];
    
        
        return;
    }
    
    FireBaseManager * fbm =[[FireBaseManager alloc]init];
    
    
    if ([self.comeFrom isEqualToString:@"registroProducto"]) {
        
        [[ERProgressHud sharedInstance] show];
        [fbm saveGProduct:_product completion:^(BOOL isOK) {
            [[ERProgressHud sharedInstance] hide];
            if (isOK) {
                
                [self performSegueWithIdentifier:@"segue" sender:nil];
            }else{
                [self userLostConectionFireBase];
            }
            
        }];
        
    }else if([self.comeFrom isEqualToString:@"registroLiberacion"]){
    
                    [self finalizaInspeccion];
    }else{
        // mostrar Etiqueta Verde
        
    }
    
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




- (void)userLostConectionFireBase {
    [[ERProgressHud sharedInstance] hide];
    UIAlertView * alert =[[UIAlertView alloc]initWithTitle:@"Error" message:@"No se puido conectar con servidor." delegate:self cancelButtonTitle:@"Aceptar" otherButtonTitles:nil, nil];
    
    [alert show];
    
}

-(void)finalizaInspeccion{
    
    if ([_lote.estatusLiberacion isEqualToString:@"Rechazado"]) {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Rechazado" message:@"Deseas enviar una notificación?" delegate:self cancelButtonTitle:@"Cancelar" otherButtonTitles:@"Notificar", @"Liberar", nil];
        _lote.estatusLiberacion = @"Rechazado";
        [alert show];
        alert.tag = 100;
        return;
    }else{
        
        
        
        
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Liberado" message:@"El producto cumple con los estandares de calidad. Confirma y guarda tu resultado." delegate:self cancelButtonTitle:@"Continuar" otherButtonTitles:nil, nil];
        _lote.estatusLiberacion = @"Liberado";
        [alert show];
        alert.tag = 101;
        
        return;
        
    }
    
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    
    if (alertView.tag ==101) {
        FireBaseManager * fbm =[[FireBaseManager alloc]init];
        [fbm saveLiberation:_lote completion:^(BOOL isOK) {
            if (isOK) {
                if (_comeFromPendientes) {
                    [CoreDataManager deleteLote:_pendenteInexx];
                }
                    [self performSegueWithIdentifier:@"segue" sender:nil];
                
                // [self performSegueWithIdentifier:@"segue" sender:nil];
            }else{
                [self userLostConectionFireBase];
            }
            
        }];
    }
    
    
    if (alertView.tag ==100) {
        if (buttonIndex == 2)
        {
          
            FireBaseManager * fbm =[[FireBaseManager alloc]init];
            [fbm saveLiberation:_lote completion:^(BOOL isOK) {
                if (isOK) {
                    if (_comeFromPendientes) {
                        [CoreDataManager deleteLote:_pendenteInexx];
                        [self performSegueWithIdentifier:@"segue" sender:nil];
                    }
                    // [self performSegueWithIdentifier:@"segue" sender:nil];
                }else{
                    [self userLostConectionFireBase];
                }
                
            }];
            
            
            
        }
        
        if (buttonIndex == 0) {
            
        }
        
        if (buttonIndex == 1) {
            NSString *emailTitle = [NSString stringWithFormat:@"Rechazo Inspección Recibo no. parte %@",self.noParte.text];
            // Email Content
            NSString *messageBody = @"";//[NSString stringWithFormat:@"Se notifica que el producto : %@ del lote: %@ ha sido rechazado. ",self.descrip.text,_liberationPaper.lote ];
            //        // To address
            NSArray *toRecipents = @[@"delarosa-21@hotmail.com",@"ricardodeveloper.21@hotmail.com"];//[NSArray arrayWithObject:@"support@appcoda.com"];
            
            MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
            mc.mailComposeDelegate = self;
            [mc setSubject:emailTitle];
            [mc setMessageBody:messageBody isHTML:NO];
            [mc setToRecipients:toRecipents];
            [self presentViewController:mc animated:YES completion:NULL];
        }
    }

}



@end
