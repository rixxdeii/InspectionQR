//
//  InspectionViewController.m
//  QRApp
//
//  Created by Ricardo Rojas on 09/06/18.
//  Copyright © 2018 Ricardo Rojas. All rights reserved.
//

#import "InspectionViewController.h"
#include "LMSideBarController.h"
#import "UIViewController+LMSideBarController.h"
#import "FireBaseManager.h"
#import "LoteTableViewCell.h"
#import "InspectionHeaderTableViewCell.h"
#import "AchiveViewerViewController.h"
#import <MessageUI/MessageUI.h>
#import "ConfirmViewController.h"
#import "UserModel.h"
#import "CoreDataManager.h"
#import "ScannerViewController.h"
#import "PickerContainerViewController.h"
@interface InspectionViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIAlertViewDelegate,MFMailComposeViewControllerDelegate,ScannerDelegate,PickerContainerDelegate>{
    int muestra;
    int auditoriaIndex;
    int IDlote;
}
@property (weak, nonatomic) IBOutlet UILabel *noParte;
@property (weak, nonatomic) IBOutlet UILabel *noLote;
@property (weak, nonatomic) IBOutlet UILabel *descrip;
@property (weak, nonatomic) IBOutlet UILabel *inspector;
@property (strong , nonatomic) NSDictionary * especificaciones;
@property (strong , nonatomic) NSMutableArray  * arrayData;
@property (strong , nonatomic) NSMutableArray  * arrLotes;
@property (strong , nonatomic) NSMutableDictionary * recolecorMuestras;
@property (weak, nonatomic) IBOutlet UIButton *scannerButton;
@property (weak, nonatomic) IBOutlet UIButton *scannerTXT;
@property (weak, nonatomic) IBOutlet UILabel *Scannerlabel;
@property (weak, nonatomic) IBOutlet UILabel *paqueteLabel;

@end

@implementation InspectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _arrayData =[[NSMutableArray alloc]init];
    
    if (_comefromPendiente) {
        
        self.noParte.text = _product.noParte;
        self.noLote.text = _lote.noLote;
        self.descrip.text = _product.descript;
        self.especificaciones = _product.especificaciones;
        self.inspector.text =[[UserModel sharedManager] userName];
        self.lote.proveedor =_lote.proveedor;
        auditoriaIndex = 1;
        _recolecorMuestras =[[NSMutableDictionary alloc]init];
        muestra = [_product.muestra intValue];
        _lote.nivelRevision = _product.nivelRevision;
        
        NSString * PC = [NSString stringWithFormat:@"Palet:%@",_lote.noPalet];
        [self.paletText setText:PC];
        NSString * PP = [NSString stringWithFormat:@"Paquete:%@",_lote.paquete];
        [self.paqueteLabel setText:PP];
        
        
    }else{
        
        self.noParte.text = _barcode.noParte;
        self.noLote.text = _barcode.noLote;
        self.descrip.text = _product.descript;
        self.especificaciones = _product.especificaciones;
        self.inspector.text =[[UserModel sharedManager] userName];
        auditoriaIndex = 1;
        _lote =[[LoteModel alloc]init];
        _lote.muestreo = [[NSMutableDictionary alloc]init];
        _recolecorMuestras =[[NSMutableDictionary alloc]init];
        _lote.noParte = _barcode.noParte;
        _lote.nivelRevision = _product.nivelRevision;
        
        NSString * PC = [NSString stringWithFormat:@"Palet:%@",_barcode.palet];
        [self.paletText setText:PC];
        NSString * PP = [NSString stringWithFormat:@"Paquete:%@",_barcode.paquete];
        [self.paqueteLabel setText:PP];
        muestra = [_product.muestra intValue];
        
        
    }
    
    if ([_product.tipoproducto isEqualToString:@"Químico"]) {
        
        [self.scannerButton setHidden:NO];
        [self.scannerTXT setHidden:NO];
        [self.Scannerlabel setHidden:NO];
        //
        //        NSInteger  paquetes = [_barcode.paquetesPorPalets integerValue];
        //        NSInteger  palets = [_barcode.paletsPorLote integerValue];
        
        muestra = 1;
        _pageIndicatorTXT.text = [self constructInfoLabel:[NSString stringWithFormat:@"%d",auditoriaIndex] two:[NSString stringWithFormat:@"%d",muestra]];
    }else
    {
        
        [self.scannerButton setHidden:YES];
        [self.scannerTXT setHidden:YES];
        [self.Scannerlabel setHidden:YES];
        _pageIndicatorTXT.text = [self constructInfoLabel:[NSString stringWithFormat:@"%d",auditoriaIndex] two:[NSString stringWithFormat:@"%@",_product.muestra]];
    }
    
    
    
    [_arrayData addObject:@{@"LI":@"Toelrancia",
                            @"MeasureName":@"Especificación",
                            @"tipoIstrumento":@"Insrumento",
                            @"LM":@"UM"
                            }];
    
    if (_especificaciones.count > 0) {
        for (NSDictionary * dic  in self.especificaciones) {
            [_arrayData addObject:dic];
        }
    }
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    [formatter setTimeStyle:NSDateFormatterNoStyle];
    NSString *result = [formatter stringFromDate:[NSDate date]];
    
    
    [_scannerTXT setTitle:result forState:UIControlStateNormal];
    
    [self.sideBarController showMenuViewControllerInDirection:LMSideBarControllerDirectionRight];
    
    self.title = @"";
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _arrayData.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    InspectionHeaderTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"inspCell" forIndexPath:indexPath];
    
    
    NSDictionary * param =[_arrayData objectAtIndex:indexPath.row];
    
    if (indexPath.row == 0) {
        
        cell.especificacion.text = [param objectForKey:@"MeasureName"];
        cell.Toleracias.text = [param objectForKey:@"LI"];
        cell.tipoInsturmento.text = [param objectForKey:@"tipoIstrumento"];
        cell.UM = [param objectForKey:@"LM"];
        
        [cell.sw setHidden:YES];
        [cell.textFielReal setHidden:YES];
        [cell.labelReal setHidden:NO];
        cell.backgroundColor =[UIColor colorWithRed:249.0f/255.0f
                                              green:200.0f/255.0f
                                               blue:74.0f/255.0f
                                              alpha:1.0f];
    }else{
        
        cell.backgroundColor =[UIColor clearColor];
        
        if ([[param objectForKey:@"LS"]isEqualToString:@""]) {//tipoChek
            
            if (_comefromPendiente) {
                NSArray * keys =[_lote.muestreo allKeys];
                
                [cell.labelReal setHidden:YES];
                [cell.sw setHidden:NO];
                cell.sw.tag = indexPath.row;
                //                [cell.sw setOn:NO];
                //                [cell.sw addTarget:self action:@selector(onSwitchClick:) forControlEvents:UIControlEventValueChanged];
                //                [self onSwitchClick:cell.sw];
                [cell.textFielReal setHidden:YES];
                
                cell.especificacion.text = [param objectForKey:@"MeasureName"];
                cell.Toleracias.text = [param objectForKey:@"LI"];
                cell.tipoInsturmento.text = [param objectForKey:@"tipoIstrumento"];
                cell.UM.text = [param objectForKey:@"LM"];
                [cell.sw setEnabled:NO];
                for (NSString * key in keys) {
                    NSArray * subKeys = [[_lote.muestreo objectForKey:key] allKeys];
                    
                    if ([[[_lote.muestreo objectForKey:key] objectForKey:subKeys] isKindOfClass:[NSDictionary class]]||[[[_lote.muestreo objectForKey:key] objectForKey:subKeys] isKindOfClass:[NSMutableDictionary class]]) {
                        
                        for (NSString *object in subKeys) {
                            NSString * prueba =[[[_lote.muestreo objectForKey:key] objectForKey:object] objectForKey:@"MeasureName"];
                            if ([prueba isEqualToString:[param objectForKey:@"MeasureName"]]) {
                                [cell.sw setOn:![[[[_lote.muestreo objectForKey:key] objectForKey:object] objectForKey:@"medidaReal"]isEqualToString:@"false"]];
                                
                                
                                
                            }
                            
                        }
                    }
                }
                [_recolecorMuestras setObject:@"elementoInspeccionado" forKey:[NSString stringWithFormat: @"object%ld",(long)indexPath.row]];
                
                return cell;
            }
            
            [cell.labelReal setHidden:YES];
            [cell.sw setHidden:NO];
            cell.sw.tag = indexPath.row;
            [cell.sw setOn:NO];
            [cell.sw addTarget:self action:@selector(onSwitchClick:) forControlEvents:UIControlEventValueChanged];
            [self onSwitchClick:cell.sw];
            [cell.textFielReal setHidden:YES];
            
            cell.especificacion.text = [param objectForKey:@"MeasureName"];
            cell.Toleracias.text = [param objectForKey:@"LI"];
            cell.tipoInsturmento.text = [param objectForKey:@"tipoIstrumento"];
            cell.UM.text = [param objectForKey:@"LM"];
            
            
            
            
        }else
        {
            
            
            if ([[param objectForKey:@"tipoIstrumento"]isEqualToString:@"Laboratorio"])
            {
                if (_comefromPendiente) {
                    [cell.textFielReal setText:@"0"];
                    [cell.labelReal setHidden:YES];
                    [cell.sw setHidden:YES];
                    [cell.textFielReal setHidden:NO];
                    cell.textFielReal.tag =indexPath.row;
                    cell.textFielReal.delegate = self;
                    
                    cell.especificacion.text = [param objectForKey:@"MeasureName"];
                    cell.Toleracias.text =[NSString stringWithFormat:@"tar:%@  tol:%@",[param objectForKey:@"LI"],[param objectForKey:@"LS"]];
                    cell.tipoInsturmento.text = [param objectForKey:@"tipoIstrumento"];
                    cell.UM.text = [param objectForKey:@"LM"];
                    
                    
                }else{
                    [cell.textFielReal setHidden:YES];
                    [cell.labelReal setHidden:NO];
                    [cell.labelReal setText:@"Pendiente"];
                    
                    [cell.sw setHidden:YES];
                    
                    cell.especificacion.text = [param objectForKey:@"MeasureName"];
                    cell.Toleracias.text =[NSString stringWithFormat:@"tar:%@  tol:%@",[param objectForKey:@"LI"],[param objectForKey:@"LS"]];
                    cell.tipoInsturmento.text = [param objectForKey:@"tipoIstrumento"];
                    cell.UM.text = [param objectForKey:@"LM"];
                    [_recolecorMuestras setObject:@"elementoInspeccionado" forKey:[NSString stringWithFormat: @"object%ld",(long)indexPath.row]];
                    
                }
                
                
                return cell;
            }
            
            if (_comefromPendiente) {
                
                [cell.textFielReal setHidden:YES];
                [cell.labelReal setHidden:NO];
                [cell.sw setHidden:YES];
                
                NSArray * keys =[_lote.muestreo allKeys];
                
                for (NSString * key in keys) {
                    NSArray * subKeys = [[_lote.muestreo objectForKey:key] allKeys];
                    
                    for (NSString *object in subKeys) {
                        
                        if ([[[_lote.muestreo objectForKey:key] objectForKey:object] isKindOfClass:[NSDictionary class]]||[[[_lote.muestreo objectForKey:key] objectForKey:object] isKindOfClass:[NSMutableDictionary class]]) {
                            NSString * prueba =[[[_lote.muestreo objectForKey:key] objectForKey:object] objectForKey:@"MeasureName"];
                            if ([prueba isEqualToString:[param objectForKey:@"MeasureName"]]) {
                                
                                [cell.labelReal setText:[[[_lote.muestreo objectForKey:key] objectForKey:object] objectForKey:@"medidaReal"]];
                                
                                
                            }
                        }
                        
                    }
                    
                }
                
                
                cell.especificacion.text = [param objectForKey:@"MeasureName"];
                cell.Toleracias.text =[NSString stringWithFormat:@"tar:%@  tol:%@",[param objectForKey:@"LI"],[param objectForKey:@"LS"]];
                cell.tipoInsturmento.text = [param objectForKey:@"tipoIstrumento"];
                cell.UM.text = [param objectForKey:@"LM"];
                [_recolecorMuestras setObject:@"elementoInspeccionado" forKey:[NSString stringWithFormat: @"object%ld",(long)indexPath.row]];
                
                return cell;
            }
            
            
            [cell.textFielReal setText:@"0"];
            [cell.labelReal setHidden:YES];
            [cell.sw setHidden:YES];
            [cell.textFielReal setHidden:NO];
            cell.textFielReal.tag =indexPath.row;
            cell.textFielReal.delegate = self;
            
            cell.especificacion.text = [param objectForKey:@"MeasureName"];
            cell.Toleracias.text =[NSString stringWithFormat:@"tar:%@  tol:%@",[param objectForKey:@"LI"],[param objectForKey:@"LS"]];
            cell.tipoInsturmento.text = [param objectForKey:@"tipoIstrumento"];
            cell.UM.text = [param objectForKey:@"LM"];
            
            
        }
    }
    return cell;
}

-(void)onSwitchClick:(UISwitch *)sw{
    
    
    int index = 0;
    
    for (NSMutableDictionary  * dic in _arrayData) {
        
        if (sw.tag == index) {
            
            NSString * muestraname = [NSString stringWithFormat:@"%d",index];
            
            NSDictionary * data = @{@"MeasureName":[[_arrayData objectAtIndex:index] objectForKey:@"MeasureName"],
                                    @"medidaReal":[sw isOn]?@"true":@"false",
                                    @"estatus":[sw isOn]?@"Liberado":@"Rechazado"
                                    };
            
            [_recolecorMuestras setObject:data forKey:muestraname];
            
        }
        index++;
        
    }
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    
    
    NSString * finalText = [NSString stringWithFormat:@"%@%@",textField.text,string];
    
    NSString * LS = [[_arrayData objectAtIndex:textField.tag] objectForKey:@"LS"];
    NSString * LI = [[_arrayData objectAtIndex:textField.tag] objectForKey:@"LI"];
    textField.textColor = [self chageColorOfTextLS:LS M:finalText LI:LI];
    NSArray * validCharacteres =@[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@".",@"-"];
    
    
    
    for (NSString *object in validCharacteres) {
        if ([object isEqualToString:string]) {
        }
        return YES;
    }
    return  NO;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    int index = 0;
    
    if ([textField.text isEqualToString:@""]) {
        textField.text = 0;
    }
    
    for (NSMutableDictionary  * dic in _arrayData) {
        
        
        if (textField.tag == index) {
            
            NSString * muestraname = [NSString stringWithFormat:@"%d",index];
            
            NSDictionary * data = @{@"MeasureName":[[_arrayData objectAtIndex:index] objectForKey:@"MeasureName"],
                                    @"medidaReal":textField.text,
                                    @"estatus":(textField.textColor ==[UIColor greenColor])?@"Liberado":@"Rechazado"
                                    };
            
            [_recolecorMuestras setObject:data forKey:muestraname];
            
        }
        
        index++;
    }
}


-(UIColor *)chageColorOfTextLS:(NSString *)LS
                             M:(NSString *)M
                            LI:(NSString *)LI
{
    NSUInteger  _LS = [LS integerValue];
    NSUInteger  _M = [M integerValue];
    NSUInteger  _LI = [LI integerValue];
    
    if (_M > _LS || _M < _LI ) {
        return [UIColor redColor];
        
    }
    return [UIColor greenColor];
    
}


- (IBAction)showArchive:(id)sender {
    AchiveViewerViewController * archive = [[AchiveViewerViewController alloc]init];
    archive.url = _lote.noParte;
    self.definesPresentationContext = YES; //self is presenting view controller
    archive.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:archive animated:YES completion:nil];
    
}
- (IBAction)continueButton:(id)sender
{
    //Muestras completas
    //        if ([_product.tipoproducto isEqualToString: @"Químico"]) {
    //            if ([self.scannerTXT.text isEqualToString:@""]) {
    //                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Aviso" message:@"Te faltra agregar fechaCaducidad" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    //                [alert show];
    //                return;
    //            }
    //        }
    
    
    if (_recolecorMuestras.count != _arrayData.count-1)
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Aviso" message:@"Te faltra llenar campos" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        alert.tag = 2;
        return;
    }
    
    
    if (_comefromPendiente) {
        
        [_lote.muestreo setObject:_recolecorMuestras forKey:[NSString stringWithFormat:@"muestraLaboratorio%d", auditoriaIndex]];
    }else{
        [_lote.muestreo setObject:_recolecorMuestras forKey:[NSString stringWithFormat:@"muestra%d", auditoriaIndex]];
    }
    
    _recolecorMuestras =[[NSMutableDictionary alloc]init];
    
    if (auditoriaIndex <muestra) {
        
        auditoriaIndex++;
        
        if (muestra == auditoriaIndex) {
            [_btnContinue setTitle:@"Finaliza" forState:UIControlStateNormal];
        }
        
        NSString * muestraa = [NSString stringWithFormat:@"%i",muestra];
        
        
        _pageIndicatorTXT.text = [self constructInfoLabel:[NSString stringWithFormat:@"%d",auditoriaIndex] two:[NSString stringWithFormat:@"%@",muestraa]];
        [_inspectionTableView reloadData];
        
    }else
    {
        if (_comefromPendiente) {
            _lote.fechaManufactura =@"";
            _lote.fechaLlegada = _lote.fechaLlegada;
            _lote.tipoPorducto = _lote.tipoPorducto;
        }

        if (!_comefromPendiente){
            _lote.fechaLlegada = _barcode.fechaRecibo;
            _lote.tipoPorducto =_product.tipoproducto;
            _lote.fechaManufactura = @"";
            _lote.noLote = _barcode.noLote;
            _lote.noFactura =_barcode.noFactura;
            _lote.proveedor = _barcode.proveedor;
            _lote.cantidadTotalporLote = _barcode.cantidad;
            _lote.unidadMedida = _barcode.UM;
            _lote.noPalet =_barcode.palet;
            _lote.noPaquetesPorPalet =_barcode.paquetesPorPalets;
            _lote.totalPalets = _barcode.paletsPorLote;
            _lote.ubicacion =@"Calidad";
            _lote.paquete = _paqueteLabel.text;
           
            _lote.tipoPorducto = _product.tipoproducto;
            
            _lote.fechaLiberacion = @"pendiente";
            _lote.tipoPorducto =_product.tipoproducto;
            
            if ([_product.tipoproducto isEqualToString: @"Químico"]) {
                _lote.fechaCaducidad = _scannerTXT.titleLabel.text;
            }else{
                _lote.fechaCaducidad = @"N/A";
            }
            
            
            
            for (NSDictionary  *object in _arrayData) {
                if ([[object objectForKey:@"tipoIstrumento"]isEqualToString:@"Laboratorio"]) {
                    
                    UIAlertView * alert =[[UIAlertView alloc]initWithTitle:@"Aviso" message:@"El producto quedará pendiente de liberación (Laboratorio)." delegate:self cancelButtonTitle:@"Cancelar" otherButtonTitles:@"Aceptar", nil];
                    alert.tag =100;
                    [alert show];
                    _lote.estatusLiberacion = @"Pendiente";
                    _lote.ubicacion =@"Calidad";
                    return;
                }
                
            }
        }
        
        NSArray * keys =[_lote.muestreo allKeys];
        
        
        for (NSString *key in keys) {
            NSDictionary * dic = [_lote.muestreo objectForKey:key];
            NSArray * subkeys =[dic allKeys];
            for (NSString *subKey in subkeys) {
                
                if ([[dic objectForKey:subKey] isKindOfClass:[NSDictionary class]]||[[dic objectForKey:subKey] isKindOfClass:[NSMutableDictionary class]]) {
                    if ([[[dic objectForKey:subKey]objectForKey:@"estatus"]isEqualToString:@"Rechazado"]) {
                        _lote.estatusLiberacion = @"Rechazado";
                        [self performSegueWithIdentifier:@"segueConfirm" sender:nil];
                        return;
                    }
                }
                
            }
        }
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd-MM-yyyy"];
        
        NSLog(@"Fecha Liberación : %@",[dateFormatter stringFromDate:[NSDate date]]);
        _lote.fechaLiberacion = [dateFormatter stringFromDate:[NSDate date]];
        _lote.estatusLiberacion = @"Liberado";
        [self performSegueWithIdentifier:@"segueConfirm" sender:nil];
        
    }
    
}
-(NSString *)constructInfoLabel:(NSString *)one two:(NSString *)two
{
    return [NSString stringWithFormat:@"Muestra: %@/%@",one,two];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (alertView.tag == 100) {
        
        if (buttonIndex ==1) {
            _lote.noParte = _barcode.noParte;
            [CoreDataManager loteStatusPendiente:_lote];
            [self.navigationController popToViewController:[[self.navigationController viewControllers]objectAtIndex:1] animated:YES];
        }
        
    }
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(LoteModel *)sender{
    if ([segue.identifier isEqualToString:@"segueConfirm"]) {
        ConfirmViewController * VC =[segue destinationViewController];
        VC.comeFrom =@"registroLiberacion";
        VC.lote = _lote;
        VC.product = _product;
        VC.barcode = _barcode;
        VC.comeFromPendientes = _comefromPendiente;
        VC.pendenteInexx = _pendenteInexx;
        
        
        //        VC.isComeFromLiberationPapoerVC = YES;
        //        VC.liberationPaper = _liberationPaper;
    }
}
- (IBAction)gesture:(id)sender
{
    [self.view endEditing:YES];
    
}

- (IBAction)userDidTapScannerButton:(id)sender
{
    [self showDateSheetWithInitialDate:_scannerTXT.titleLabel.text];
    
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//
//    ScannerViewController *scannerView = [storyboard instantiateViewControllerWithIdentifier:@"ScannerViewController"];
//
//    scannerView.delegate = self;
//    scannerView.simpleScanner = YES;
//    self.definesPresentationContext = YES; //self is presenting view controller
//    scannerView.modalPresentationStyle = UIModalPresentationOverCurrentContext;
//    [self presentViewController:scannerView animated:YES completion:nil];
    
}

-(void)returnStringFromBarcode:(NSString *)code
{
    [self.scannerTXT setTitle:code forState:UIControlStateNormal];
}

-(NSString *)fechaCaducidad:(NSString *)fecha
{
    NSDate *dateResult;
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    
    if ([fecha isEqualToString:@"Indefinido"])
    {
        NSDate *today = [[NSDate alloc] init];
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
        [offsetComponents setYear:1];
        dateResult = [gregorian dateByAddingComponents:offsetComponents toDate:today options:0];
        
        
    }else{
        dateResult = [dateFormatter dateFromString:fecha];
    }
    
    
    
    NSLog(@"Fecha Liberación : %@",[dateFormatter stringFromDate:dateResult ]);
    return [dateFormatter stringFromDate:dateResult];
    
}

#pragma mark - dateSheet Methods

-(void)showDateSheetWithInitialDate:(NSString *)initialDate
{
    
    
    PickerContainerViewController * modal = [[PickerContainerViewController alloc]init];
    modal.delegate =self;
    modal.isDate = YES;

    self.definesPresentationContext = YES; //self is presenting view controller
    modal.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:modal animated:YES completion:nil];
}
-(void)didUserSelect:(NSString *)object index:(NSInteger)index buttotn:(UIButton *)fromButton
{
   NSString * caducidadResult = [self fechaCaducidad:object];
    
    [self.scannerTXT setTitle:caducidadResult forState:UIControlStateNormal];
    
}


@end
