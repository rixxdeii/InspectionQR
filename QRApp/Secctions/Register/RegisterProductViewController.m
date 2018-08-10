//
//  RegisterProductViewController.m
//  QRApp
//
//  Created by Ricardo Rojas on 05/06/18.
//  Copyright © 2018 Ricardo Rojas. All rights reserved.
//

#import "RegisterProductViewController.h"
#import "CoreDataManager.h"
#import "GenericProductModel.h"
#import "ConfirmViewController.h"
#import "AchiveViewerViewController.h"
#import "PickerContainerViewController.h"
typedef enum : NSUInteger {
    KQimico,
    KPlaca,
    KShim,
} TipoProducto;

@interface RegisterProductViewController ()<UITableViewDelegate,UITableViewDataSource,PickerContainerDelegate,UITextFieldDelegate>{
    
    BOOL isFrio;
    BOOL isCritica;
    TipoProducto producto;
}
@property (weak, nonatomic) IBOutlet UITextField *tipoIstrumentoTXT;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UITextField *noParteText;
@property (weak, nonatomic) IBOutlet UITextField *descripText;
@property (weak, nonatomic) IBOutlet UILabel *nRevisionText;
@property (weak, nonatomic) IBOutlet UILabel *tamanoMuestraText;
@property (weak, nonatomic) IBOutlet UIStepper *tamanoMuestraHelper;
@property (weak, nonatomic) IBOutlet UISwitch *almacenSwitch;
@property (weak, nonatomic) IBOutlet UILabel *tamanoMuestraTextQuimico;
@property (weak, nonatomic) IBOutlet UISwitch *tipoMeasure;



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
    _arr_measures = [[NSMutableArray alloc]init];
    isFrio = YES;
    producto = KQimico;
    isCritica = YES;
    
    _scrollView.center =self.view.center;   _scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height*2) ;
    self.title = @"";
    self.tb.allowsMultipleSelectionDuringEditing = NO;

}

-(void)viewDidAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO];
    self.title =@"";
}

- (IBAction)didUserContinueTap:(id)sender
{
    NSString * title = nil;
    NSString * tamanodemuestra;
    NSString * almacenaje;
    
    if ([_noParteText.text isEqualToString:@""]) {
        title = @"Falta número de Parte.";
        [self showAlert:title];
        return;
    }
    
    if ([_descripText.text isEqualToString:@""]) {
        title =@"Falta descripción.";
        [self showAlert:title];
        return;
        
    }
    
    if ([_nRevisionText.text isEqualToString:@"0"]) {
        title = @"Falta nivel de revisión.";
        [self showAlert:title];
        return;
        
    }

    if (producto != KQimico) {
        
        if ([_tamanoMuestraText.text isEqualToString:@"0"]) {
            title = @"Falta tamaño de muestra.";
            [self showAlert:title];
            return;
        }
    
        tamanodemuestra = _tamanoMuestraText.text;
    }else{
        tamanodemuestra = @"100%";
    }
    
    if (_arr_measures.count == 0) {
        title =@"Agrega especificaciones.";
        [self showAlert:title];
        return;
    }
    
    if (_almacenSwitch.isOn) {
        almacenaje = @"Si";
    }else{
        almacenaje = @"No";
    }
    
    NSString * tipo;
    switch (producto) {
        case KQimico:
            tipo = @"Químico";
            break;
        case KPlaca:
            tipo = @"Placa";
            break;
        case KShim:
            tipo = @"Shim";
            break;

    }
    
    GenericProductModel * GP = [[GenericProductModel alloc]init];
    GP.noParte = _noParteText.text;
    GP.descript  =_descripText.text;
    GP.nivelRevision  =_nRevisionText.text;
    GP.especificaciones  =@{@"especificaciones":_arr_measures};
    GP.muestra  =tamanodemuestra;
    GP.almacenaje  =almacenaje;
    GP.tipoproducto = tipo ;
    
    [self performSegueWithIdentifier:@"segueConfirm" sender:GP];

}


-(void)showAlert:(NSString *)title{
    if (title) {
        UIAlertView * alert = [[UIAlertView  alloc]initWithTitle:@"Aviso" message:title delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return;
        
    }
}
- (IBAction)addMeasure:(id)sender
{
    if (_tipoMeasure.isOn) {
        if (![_meausteTXT.text isEqualToString:@""]) {
            
        [_arr_measures addObject:@{@"MeasureName":_meausteTXT.text,
                                   @"LS":@"",
                                   @"LM":@"",
                                   @"LI":@"",
                                   @"isCritica":isCritica?@"YES":@"NO",
                                   @"tipoIstrumento":@"Visual"
                                   }];
        _LSTXT.text = @"0";
        _UMButton.titleLabel.text = @"cm";
        _LITXT.text= @"0";
        _meausteTXT.text =@"";
        _tipoIstrumentoTXT.text = @"";
        
     [_tb reloadData];
        return;
            
            
        }
        else
        {
            UIAlertView  * alert = [[UIAlertView alloc]initWithTitle:@"Aviso" message:@"Faltan medidas" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            
            [alert show];
            
            return;
            
        }
        
            
    }
    
    
    if (![_LSTXT.text isEqualToString:@""]
        &&![_LITXT.text isEqualToString:@""]
        &&![_UMButton.titleLabel.text isEqualToString:@""]
        &&![_meausteTXT.text isEqualToString:@""]
        &&![_InstrumentButton.titleLabel.text isEqualToString:@""]) {
    
        [_arr_measures addObject:@{@"MeasureName":_meausteTXT.text,
                         @"LS":_LSTXT.text,
                         @"LM":_UMButton.titleLabel.text,
                         @"LI":_LITXT.text,
                         @"isCritica":isCritica?@"YES":@"NO",
                         @"tipoIstrumento":_InstrumentButton.titleLabel.text
                         }];
        
        [_tb reloadData];
        _LSTXT.text = @"";
        _UMButton.titleLabel.text = @"cm";
        _LITXT.text= @"";
        _meausteTXT.text =@"";
        
        
        
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
    NSString * tipoInstrumento = [measure objectForKey:@"tipoIstrumento"];
//    @"isCritica":isCritica?@"YES":@"NO",
//    @"tipoIstrumento":@"visual"
    
//    cell.textLabel.text =[NSString stringWithFormat:@"%@:  Targ: %@   Tol: %@  UM: %@  Instrumrnto: %@",name,li,ls,m,tipoInstrumento];
    
    if ([ls isEqualToString:@""]) {
        cell.textLabel.text =[NSString stringWithFormat:@"%@    OK  %@",name,tipoInstrumento];
    }else{
         cell.textLabel.text =[NSString stringWithFormat:@"%@:  Targ: %@   Tol: %@  UM: %@  %@",name,li,ls,m,tipoInstrumento];
    }
    
    if (isCritica) {
        [cell.textLabel setTextColor:[UIColor redColor]];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    return cell;
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete
        [self.arr_measures removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        //[self saveList];
    }
}
- (IBAction)recognizerGesture:(id)sender
{
    [self.view endEditing:YES];
}
- (IBAction)addArchive:(id)sender {
    
    if (![_noParteText.text isEqualToString:@""]) {
        AchiveViewerViewController * archive = [[AchiveViewerViewController alloc]init];
        archive.url = _noParteText.text;
        self.definesPresentationContext = YES; //self is presenting view controller
        archive.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [self presentViewController:archive animated:YES completion:nil];
    }
}
- (IBAction)userDidSelectTypeProdut:(UISegmentedControl *)sender
{
    switch (sender.selectedSegmentIndex) {
        case KQimico:
            [self presentQuimicoConfiguration];
            break;
        case KPlaca:
            [self presentPlacaConfiguration];
            break;
        case KShim:
            [self presentShimConfiguration];
            break;
    }
    producto =sender.selectedSegmentIndex;
}

-(void)presentQuimicoConfiguration
{
    _tamanoMuestraText.hidden =YES;
    _tamanoMuestraHelper.hidden =YES;
    _tamanoMuestraTextQuimico.hidden =NO;
    
    
}

-(void)presentPlacaConfiguration
{
    _tamanoMuestraText.hidden =NO;
    _tamanoMuestraHelper.hidden =NO;
    _tamanoMuestraTextQuimico.hidden =YES;
    
}
-(void)presentShimConfiguration
{
    _tamanoMuestraText.hidden =NO;
    _tamanoMuestraHelper.hidden =NO;
    _tamanoMuestraTextQuimico.hidden =YES;
}

#pragma mark - upcreastMEthod

- (IBAction)nivelRevision:(UIStepper *)sender
{
    _nRevisionText.text =[NSString stringWithFormat:@"%d",
                          [[NSNumber numberWithDouble:[(UIStepper *)sender value]] intValue]];
}

- (IBAction)tamañoDeMuestra:(UIStepper *)sender
{
    _tamanoMuestraText.text =[NSString stringWithFormat:@"%d",
                              [[NSNumber numberWithDouble:[(UIStepper *)sender value]] intValue]];
}

- (IBAction)userDidSelectFrioType:(UISwitch *)sender
{
    isFrio = [sender isOn];
}
- (IBAction)userDidChangetypeOfMeasure:(UISwitch *)sender
{
    
    [_LSTXT setEnabled:!sender.isOn];
    [_LITXT setEnabled:!sender.isOn];
    [_UMButton setEnabled:!sender.isOn];
    _InstrumentButton.enabled = !sender.isOn;

    
    if (!sender.isOn)
    {
        _tipoIstrumentoTXT.text = @"";
    }else{
        
        [_InstrumentButton setTitle:@"Visual" forState:UIControlStateNormal] ;
    }
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(GenericProductModel *)sender
{
    if ([segue.identifier isEqualToString:@"segueConfirm"]) {
        ConfirmViewController * VC =[segue destinationViewController];
        VC.comeFrom = @"registroProducto";
        VC.product = sender;
    }
    
}
- (IBAction)userDidTapMedidaCritica:(UISwitch *)sender {
    
    isCritica = [sender isOn];
    
}

#pragma mark - UserSelectPickerObject
-(void)didUserSelect:(NSString *)object index:(NSInteger)index buttotn:(UIButton *)fromButton
{
    if (fromButton == _UMButton) {
        [_UMButton setTitle:object forState:UIControlStateNormal];
    }else if (fromButton == _InstrumentButton){
        [_InstrumentButton setTitle:object forState:UIControlStateNormal];
    }
    
}
- (IBAction)didUserTapSelectObjetFromPicker:(UIButton *)sender
{
    
    PickerContainerViewController * modal = [[PickerContainerViewController alloc]init];
    modal.delegate =self;
    modal.fromButton = sender;
    modal.isDate = NO;
    modal.data = (sender == _InstrumentButton)?ARR_INSTRUMENTS:ARR_UM;

    self.definesPresentationContext = YES; //self is presenting view controller
    modal.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:modal animated:YES completion:nil];

}

//KeyBoard Manager
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    CGPoint pointInTable = [textField.superview convertPoint:textField.frame.origin toView:self.scrollView];
    CGPoint contentOffset = self.scrollView.contentOffset;
    
    contentOffset.y = (pointInTable.y -400);
    
    NSLog(@"contentOffset is: %@", NSStringFromCGPoint(contentOffset));
    [self.scrollView setContentOffset:contentOffset  animated:YES];
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSArray * validCharacteres =@[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@".",@"-"];
    if (textField == _LITXT || textField == _LSTXT){
        for (NSString *object in validCharacteres) {
            if ([object isEqualToString:string]) {
            }
            return YES;
        }
        return  NO;

    }
    return YES;

}




@end
