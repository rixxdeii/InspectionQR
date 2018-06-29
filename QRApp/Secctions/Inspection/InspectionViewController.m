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

@interface InspectionViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIAlertViewDelegate,MFMailComposeViewControllerDelegate>{
    int muestra;
    int auditoriaIndex;
}
@property (weak, nonatomic) IBOutlet UILabel *noParte;
@property (weak, nonatomic) IBOutlet UILabel *noLote;
@property (weak, nonatomic) IBOutlet UILabel *descrip;
@property (weak, nonatomic) IBOutlet UILabel *inspector;
@property (strong , nonatomic) NSDictionary * especificaciones;
@property (strong , nonatomic) NSMutableArray  * arrayData;


@end

@implementation InspectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _arrayData =[[NSMutableArray alloc]init];

    self.noParte.text = _liberationPaper.noParte;
    self.noLote.text = _liberationPaper.lote;
    self.descrip.text = _liberationPaper.descript;
    self.especificaciones = _liberationPaper.especificaciones;
    muestra = [_liberationPaper.muestra intValue];
    auditoriaIndex = 1;
    
    _pageIndicatorTXT.text = [self constructInfoLabel:[NSString stringWithFormat:@"%d",auditoriaIndex] two:[NSString stringWithFormat:@"%@",_liberationPaper.muestra]];
    
    
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

    _especificaciones = [[NSMutableDictionary alloc]init];
   

    [self.LoteTableView registerNib:[UINib nibWithNibName:@"LoteTableViewCell" bundle:nil]
         forCellReuseIdentifier:@"loteCell"];
    [self.inspectionTableView registerNib:[UINib nibWithNibName:@"InspectionHeaderTableViewCell" bundle:nil]
             forCellReuseIdentifier:@"inspCell"];
    
    

      [self.sideBarController showMenuViewControllerInDirection:LMSideBarControllerDirectionRight];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (tableView == _LoteTableView) {
        return 1;
    }
    return _arrayData.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    
    if (tableView == _LoteTableView)
    {
        LoteTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"loteCell" forIndexPath:indexPath];
        
        [cell.lote setText:_liberationPaper.lote];
        
        return cell;
    }
    
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
    
        if ([[param objectForKey:@"LS"]isEqualToString:@""]) {//tipoChek
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
            
            [cell.labelReal setHidden:YES];
            [cell.sw setHidden:YES];
            [cell.textFielReal setHidden:NO];
            cell.textFielReal.tag =indexPath.row;
            cell.textFielReal.delegate = self;
            
            cell.especificacion.text = [param objectForKey:@"MeasureName"];
            cell.Toleracias.text =[NSString stringWithFormat:@"tar:%@  tol:%@",[param objectForKey:@"LS"],[param objectForKey:@"LI"]];
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
            
            [dic setObject:[sw isOn]?@"true":@"false" forKey:@"medidaReal"];
            if (![sw isOn]){
                [dic setObject:@"rechazado" forKey:@"status"];
            }else{
                [dic setObject:@"aceptado" forKey:@"status"];
            }
            [_arrayData replaceObjectAtIndex:index withObject:dic];
            
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
    
    return  YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{

    int index = 0;
    
    if ([textField.text isEqualToString:@""]) {
        textField.text = 0;
    }
    
    for (NSMutableDictionary  * dic in _arrayData) {
        
        
        if (textField.tag == index) {
            
             [dic setObject:textField.text forKey:@"medidaReal"];
            if ([textField.textColor isEqual:[UIColor redColor]]){
                [dic setObject:@"rechazado" forKey:@"status"];
            }else{
                [dic setObject:@"aceptado" forKey:@"status"];
            }
            
              [_arrayData replaceObjectAtIndex:index withObject:dic];
            break;
        }
       
        index++;
        
        
        
    }
  

}

-(UIColor *)chageColorOfTextLS:(NSString *)LS
                             M:(NSString *)M
                            LI:(NSString *)LI
// realMeasure:(NSString *)realM
{
    NSUInteger  _LS = [LS integerValue];
    NSUInteger  _M = [M integerValue];
    NSUInteger  _LI = [LI integerValue];
    
    if (_M > _LS || _M < _LI ) {
        return [UIColor redColor];
        
    }
    
    //    if (realM == M) {
    //        return [UIColor greenColor]
    //    }
    return [UIColor greenColor];
    
}
- (IBAction)showArchive:(id)sender {
    if (![_liberationPaper.noParte isEqualToString:@""]) {
        AchiveViewerViewController * archive = [[AchiveViewerViewController alloc]init];
        archive.url = _liberationPaper.noParte;
        self.definesPresentationContext = YES; //self is presenting view controller
        archive.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [self presentViewController:archive animated:YES completion:nil];
    }
}
- (IBAction)continueButton:(id)sender
{
    
    for (NSDictionary *object in _arrayData) {
        if (![[object objectForKey:@"LI"]isEqualToString:@"Toelrancia"]) {
            
            if ([[object objectForKey:@"medidaReal"] isEqual:@""]
                ||[[object objectForKey:@"medidaReal"] isEqual:@"0"]
                ||[object objectForKey:@"medidaReal"] ==nil
                //||[[object objectForKey:@"medidaReal"] intValue]<=0
                ) {
                
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Aviso" message:@"Te faltra llenar campos" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
                alert.tag = 2;
                return;
            }
        }
    }
    [_especificaciones setValue:_arrayData forKey:[NSString stringWithFormat:@"muestra %d", auditoriaIndex]];
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

//        [result setObject:resultHelper forKey:[NSString stringWithFormat:@"measure %d",auditoriaIndex]];
//        _inspection.auditoriaResult =[[NSMutableArray alloc]init];
//        [_inspection.auditoriaResult addObject:result];
//        UIImage * image = [[[QRCodeGenerator alloc] initWithString:_inspection.idIspection] getImage];
//        _inspection.QRCode = image;
        
        [_especificaciones setValue:_arrayData forKey:[NSString stringWithFormat:@"muestra %d", auditoriaIndex]];
        for (NSDictionary *object in _arrayData) {
            if (![object isEqual:[_arrayData firstObject]]) {
                
                if ([[object objectForKey:@"status"] isEqualToString:@"rechazado"]){
                    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Rechazado" message:@"Deseas enviar una notificación? " delegate:self cancelButtonTitle:@"Continuar" otherButtonTitles:@"Notificar", nil];
                    [alert show];
                    return;
                }
            }
            
        }
        
        
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Liberado" message:@"El producto cumple con los estandares de calidad" delegate:self cancelButtonTitle:@"Continuar" otherButtonTitles:nil, nil];
        [alert show];
        
        NSLog(@"inspection Final: %@",_arrayData);
        return;
    
        
    }
    
    
}
-(NSString *)constructInfoLabel:(NSString *)one two:(NSString *)two
{
    return [NSString stringWithFormat:@"Muestra: %@/%@",one,two];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    
    if (buttonIndex == 1)
    {

        NSString *emailTitle = [NSString stringWithFormat:@"Rechazo Inspección Recibo no. parte %@",self.noParte.text];
        // Email Content
        NSString *messageBody = [NSString stringWithFormat:@"Se notifica que el producto : %@ del lote: %@ ha sido rechazado. ",self.descrip.text,_liberationPaper.lote ];
        // To address
        NSArray *toRecipents = @[@"delarosa-21@hotmail.com",@"ricardodeveloper.21@hotmail.com"];//[NSArray arrayWithObject:@"support@appcoda.com"];
        
        MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
        mc.mailComposeDelegate = self;
        [mc setSubject:emailTitle];
        [mc setMessageBody:messageBody isHTML:NO];
        [mc setToRecipients:toRecipents];
        
        // Present mail view controller on screen
        [self presentViewController:mc animated:YES completion:NULL];
    }else{
        if (alertView.tag == 2) {
            return;
        }
        
        [self performSegueWithIdentifier:@"segue" sender:nil];
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
        [self performSegueWithIdentifier:@"segue" sender:nil];
    }];
}

//-(void)

//-(NSDictionary *)stringToJson:(NSString *)string{
//
//
//    NSError *err = nil;
//    NSArray *array = [NSJSONSerialization JSONObjectWithData:[string dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&err];
//    NSDictionary *dictionary = [array objectAtIndex:0];
//    NSString *test = [dictionary objectForKey:@"ID"];
//    NSLog(@"Test is %@",test);
//    return dictionary;
//}


@end
