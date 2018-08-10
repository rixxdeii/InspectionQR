//
//  RecepcionProductViewController.m
//  FederalMogulM
//
//  Created by Ricardo Rojas on 15/07/18.
//  Copyright © 2018 Ricardo Rojas. All rights reserved.
//

#import "RecepcionProductViewController.h"
#import "RecepcionLoteTableViewCell.h"
#import "LoteModel.h"
#import "PickerContainerViewController.h"
#import "ScannerViewController.h"
#import "ConfrimAlmacenViewController.h"
#import "FireBaseManager.h"
#import "ERProgressHud.h"
#import <MessageUI/MessageUI.h>

@interface RecepcionProductViewController ()<UITableViewDelegate, UITableViewDataSource,PickerContainerDelegate,printDelegate,ScannerDelegate,UITextFieldDelegate,FirebaseManagerDelegate,UIAlertViewDelegate,MFMailComposeViewControllerDelegate>{
    NSMutableArray * productsData;
    NSInteger  buttonTag;
    
}
@property (nonatomic, weak)IBOutlet UITableView * tb;
@property (nonatomic, weak)IBOutlet UITextField * noParte;
@property (nonatomic, weak)IBOutlet UITextField * noLote;
@property (nonatomic, weak)IBOutlet UILabel * noPalets;
@property (nonatomic, weak)IBOutlet UILabel * noPaquetes;
@property (nonatomic, weak)IBOutlet UITextField * proveedor;
@property (nonatomic, weak)IBOutlet UITextField * noFactura;
@property (nonatomic, weak)IBOutlet UITextField * cantidad;
@property (weak, nonatomic) IBOutlet UIButton *umTXT;
@property (weak, nonatomic) IBOutlet UIButton *continueButton;



@end

@implementation RecepcionProductViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.noParte setDelegate:self];
    productsData = [[NSMutableArray alloc]init];
    [self.tb registerNib:[UINib nibWithNibName:@"RecepcionLoteTableViewCell" bundle:nil]
         forCellReuseIdentifier:@"cell"];
    [self.tb setDelegate:self];
    [self.tb setDataSource:self];
    
    
    
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:NO];
    self.title =@"";
}

#pragma mark - textfield methods

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    
    if (textField == _noParte) {
        [[ERProgressHud sharedInstance] show];
        FireBaseManager * fbm = [[FireBaseManager alloc]init];
        
        [fbm getRealPartNumber:textField.text completion:^(BOOL isOK, BOOL Exist, NSString *realNoParte)
         {
             
             [[ERProgressHud sharedInstance] hide];
             if (isOK) {
                 
                 if (Exist) {
                     _noParte.text = realNoParte;
                 }else{
                     
                     UIAlertView * alert =[[UIAlertView alloc]initWithTitle:@"Aviso" message:@"No existe registro para el número de parte. Deseas agregarlo?" delegate:self  cancelButtonTitle:@"Cancel" otherButtonTitles:@"Agregar",@"Notificar", nil];
                     alert.tag = 20;
                     alert.alertViewStyle = UIAlertViewStylePlainTextInput;
                     
                     [alert show];
                 }
                 
                 
             }else{
                 [self userLostConectionFireBase];
             }
         }];
        
    }
    
}



#pragma mark - uitableviewMethods

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    RecepcionLoteTableViewCell * cell =[tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    NSDictionary * data = [productsData objectAtIndex:indexPath.row];
    
    
    cell.tag = indexPath.row;
    cell.noParteTXT.text =[data objectForKey:@"noParte"];
    cell.noLoteTXT.text =[data objectForKey:@"noLote"];
    cell.noFacturaTXT.text =[data objectForKey:@"noFactura"];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return productsData.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete
        [productsData removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        //[self saveList];
    }
}

#pragma mark - private methods
-(IBAction)userdidSelectUM:(id)sender{
    PickerContainerViewController * pickerView =[[PickerContainerViewController alloc]init];
    
    pickerView.data = @[@"cm",@"mm",@"in",@"KG"];
    
    pickerView.isDate = NO;
    
    self.definesPresentationContext = YES; //self is presenting view controller
    
    pickerView.delegate =self;
    pickerView.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:pickerView animated:YES completion:nil];
}

-(IBAction)userdidTapAddProduct:(id)sender
{
    
    if (![self returnValidation]) {
        
        NSDictionary * dic =@{@"noParte":_noParte.text,
                              @"noLote":_noLote.text,
                              @"noFactura":_noFactura.text
                              };
        [productsData addObject:dic];
        [self.tb reloadData];
       
    }else{
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Aviso" message:[self returnValidation] delegate:self cancelButtonTitle:@"Aceptar" otherButtonTitles:nil, nil];
        [alert show];
    }
    
}

#pragma mark - NavigationbMethods

-(IBAction)userDidTapCpntinueButton:(UIButton *)sender
{
    NSString * title =[self returnValidation];
    if (!title) {

             [self performSegueWithIdentifier:@"segueConfirm" sender:nil];
          
            return;

    }
    
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Aviso" message:title delegate:self cancelButtonTitle:@"Aceptar" otherButtonTitles:nil, nil];
    [alert show];

}

-(NSString *)returnValidation{
    
    
    if ([_noParte.text isEqualToString:@""]) {
        return  @"Te falta agregar producto";
    }
    if ([_noLote.text isEqualToString:@""]) {
        return @"Te falta agregar lote";
    }
    if ([_noPalets.text isEqualToString:@"0"]) {
       return @"Te falta agregar palets";
    }
    if ([_noPaquetes.text isEqualToString:@"0"]) {
        return @"Te falta agregar paquetes";
    }
    
    if ([_cantidad.text isEqualToString:@""]||[_cantidad.text floatValue]<=0) {
        return @"Te falta agregar cantidad";
    }
    
    if ([_proveedor.text isEqualToString:@""]) {
        return @"Te falta agregar proveedor";
    }
    
    if ([_noFactura.text isEqualToString:@""]) {
        return @"Te falta agregar número de factura";
    }

    return nil;

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"segueConfirm"]) {
        
        LoteModel * lot = [[LoteModel alloc]init];
        
    
        ConfrimAlmacenViewController * VC =[segue destinationViewController];
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd/MM/yyyy"];
        // or @"yyyy-MM-dd hh:mm:ss a" if you prefer the time with AM/PM
        NSLog(@"%@",[dateFormatter stringFromDate:[NSDate date]]);
        
        LoteModel * lt =[[LoteModel alloc]init];
        
        lt.noParte =_noParte.text;
        lt.noLote =_noLote.text;
        lt.proveedor = _proveedor.text;
        lt.cantidadTotalporLote = _cantidad.text;
        lt.unidadMedida = _umTXT.titleLabel.text;
        lt.totalPalets = _noPalets.text;
        lt.noPaquetesPorPalet = _noPaquetes.text;
        lt.fechaLlegada =[dateFormatter stringFromDate:[NSDate date]];
        lt.noFactura = _noFactura.text;
        VC.lote = lt;
        VC.noParte.text =_noParte.text;
        VC.noLote.text =_noLote.text;
        
        VC.data =@[[NSString stringWithFormat:@"No. Palets : %@",_noPalets.text],
                   [NSString stringWithFormat:@"No. Paquetes por palet : %@",_noPaquetes.text],
                   [NSString stringWithFormat:@"Proveedor : %@",_proveedor.text],
                   [NSString stringWithFormat:@"No Factura : %@",_noFactura.text],
                   [NSString stringWithFormat:@"Cantidad : %@%@",_cantidad.text,_umTXT.titleLabel.text],
                   [NSString stringWithFormat:@"Fecha llegada : %@",[dateFormatter stringFromDate:[NSDate date]]]];
    }
    
}


- (void)didUserSelect:(NSString *)object index:(NSInteger)index buttotn:(UIButton *)fromButton {
    [_umTXT setTitle:object forState:UIControlStateNormal];
}




- (void)printLotAtIndex:(long)index {
    NSLog(@"printItems");
    
    
}

#pragma mark -steperMethods

- (IBAction)userdidChangeStepper:(UIStepper *)sender
{
    switch (sender.tag) {
        case 100:
            _noPalets.text =[NSString stringWithFormat:@"%d",
                                  [[NSNumber numberWithDouble:[(UIStepper *)sender value]] intValue]];
            break;
        case 200:
            _noPaquetes.text =[NSString stringWithFormat:@"%d",
                                  [[NSNumber numberWithDouble:[(UIStepper *)sender value]] intValue]];
            
            break;
    
    }
    
}


#pragma scannerDelegate
-(IBAction)showScanner:(UIButton *)sender{
    
    buttonTag = sender.tag;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    ScannerViewController *scannerView = [storyboard instantiateViewControllerWithIdentifier:@"ScannerViewController"];
    
    scannerView.delegate = self;
    scannerView.simpleScanner = YES;
    self.definesPresentationContext = YES; //self is presenting view controller
    scannerView.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:scannerView animated:YES completion:nil];
    
}

-(void)returnStringFromBarcode:(NSString *)code
{
    switch (buttonTag) {
        case 1:
            [self getNoParteFromService:code];
            break;
        case 2:
            _noLote.text =code;
            break;
        case 3:
            _proveedor.text =code;
            break;
        case 4:
            _noFactura.text =code;
            break;
            
            
        default:
            break;
    }
    
    
}
-(void)userLostConectionFireBase
{
[[ERProgressHud sharedInstance] hide];
UIAlertView * alert =[[UIAlertView alloc]initWithTitle:@"Error" message:@"No se puido conectar con servidor." delegate:self cancelButtonTitle:@"Aceptar" otherButtonTitles:nil, nil];

[alert show];

}

#pragma mark -firbaseMethods
-(void)getNoParteFromService:(NSString *)code
{
    
    [[ERProgressHud sharedInstance] show];
    FireBaseManager * fbm = [[FireBaseManager alloc]init];
    
    [fbm getRealPartNumber:code completion:^(BOOL isOK, BOOL Exist, NSString *realNoParte)
     {
         
         [[ERProgressHud sharedInstance] hide];
         if (isOK) {
             
             if (Exist) {
                 _noParte.text =realNoParte;
             }else{
                 
                 UIAlertView * alert =[[UIAlertView alloc]initWithTitle:@"Aviso" message:@"No existe registro para el número de parte. Deseas agregarlo?" delegate:self  cancelButtonTitle:@"Cancel" otherButtonTitles:@"Agregar",@"Notificar", nil];
                 alert.tag = 20;
                 alert.alertViewStyle = UIAlertViewStylePlainTextInput;

                 [alert show];
             }
             
             
         }else{
             [self userLostConectionFireBase];
         }
     }];
    
}


#pragma mark - uialertViewMethods

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"%@", [alertView textFieldAtIndex:0].text);
    if (alertView.tag ==20)
    {
        [self.view endEditing:YES];
        switch (buttonIndex) {
            case 1:
                //agregar
                [self addRealNumber:_noParte.text real:[alertView textFieldAtIndex:0].text];
                break;
            case 2:
                //notificar
                [self createEmail];
                break;

        }
        
    }
 
}

-(void)addRealNumber:(NSString *)code  real:(NSString *)real{
    FireBaseManager * fbm =[[FireBaseManager alloc]init];
    [[ERProgressHud sharedInstance] show];
    [fbm saveRealNoParte:code real:real completion:^(BOOL isOK) {
        [[ERProgressHud sharedInstance] hide];
        
        if (isOK) {
            _noParte.text = real;
        }else{
            _noParte.text = @"";
            [self userLostConectionFireBase];
        }
        
    }];
    
}

#pragma mark - email Metods
-(void)createEmail{
    NSString *emailTitle = [NSString stringWithFormat:@"No. Parte no registrado: %@",self.noParte.text];
    // Email Content
    NSString *messageBody = @"Favor de indicar que núnero de parte le corresponde";//[NSString stringWithFormat:@"Se notifica que el producto : %@ del lote: %@ ha sido rechazado. ",self.descrip.text,_liberationPaper.lote ];
    //        // To address
    NSArray *toRecipents = @[@"delarosa-21@hotmail.com",@"ricardodeveloper.21@gmail.com"];//[NSArray arrayWithObject:@"support@appcoda.com"];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:toRecipents];
    [self presentViewController:mc animated:YES completion:NULL];
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

@end
