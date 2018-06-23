//
//  AuditoriaViewController.m
//  QRApp
//
//  Created by Ricardo Rojas on 06/06/18.
//  Copyright © 2018 Ricardo Rojas. All rights reserved.
//

#import "AuditoriaViewController.h"
#import "GetInfoViewController.h"
#import "QRCodeGenerator.h"
#import "ViewController.h"
#import "CoreDataManager.h"

@interface AuditoriaViewController ()<GetInfoDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    int sizeLot;
    NSArray * measures;
    int auditoriaIndex;
    NSMutableDictionary  * result;
    NSMutableArray * resultHelper;
    BOOL  statusOK;
}

@property (strong, nonatomic) InspectionModel * inspection;
@property (weak, nonatomic) IBOutlet UITableView *tb;
@property (weak, nonatomic) IBOutlet UIButton *btnContinue;


@end

@implementation AuditoriaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    GetInfoViewController * GIVC = [[GetInfoViewController alloc]init];
    
    GIVC.delegate =self;
    measures =_pdroduct.measures;
    resultHelper = [[NSMutableArray alloc]init];
    result = [[NSMutableDictionary alloc]init];
    
    self.definesPresentationContext = YES; //self is presenting view controller
    GIVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:GIVC animated:YES completion:nil];

}

-(void)didFinishView:(NSDictionary *)data
{
    NSLog(@"data : %@",data);
    
//    [_delegate didFinishView:@{@"auditor":_auditorTXT.text,
//                               @"email":_emailTXT.text,
//                               @"sizeLot":_sizeTXT.text}];
    
//    @property (nonatomic, strong) UIImage * QRCode ;

//    @property (nonatomic, strong) NSString * status;
    
    _pageIndicatorTXT.text = [self constructInfoLabel:@"1" two:[data objectForKey:@"sizeLot"]];
    _idProductTXT.text = _pdroduct.idProduct;

    _inspection = [[InspectionModel alloc]init];
    
    _inspection.idIspection = [data objectForKey:@"idInspection"];
    _inspection.auditor = [data objectForKey:@"auditor"];
    _inspection.sizeLot = [data objectForKey:@"sizeLot"];
    _inspection.email = [data objectForKey:@"email"];
    _inspection.date = [NSDate date];
    
    sizeLot = [_inspection.sizeLot intValue];
    auditoriaIndex = [@"1" intValue];
    
    [_tb setDelegate:self];
    [_tb setDataSource:self];
    
    [_tb reloadData];
}


- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section{
    return measures.count;
}

- (UITableViewCell *)tableView:(UITableView *)table cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [table dequeueReusableCellWithIdentifier:@"cell"];
    
    NSDictionary * dic =  [measures objectAtIndex:indexPath.row];
    
//    NSString * name = [measure objectForKey:@"MeasureName"];
//    NSString * ls = [measure objectForKey:@"LS"];
//    NSString * m = [measure objectForKey:@"LM"];
//    NSString * li = [measure objectForKey:@"LI"];
    
    cell.textLabel.text = [dic objectForKey:@"MeasureName"];
    
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 200, 21)];
        textField.placeholder = @"Introduce medida";
        textField.text = @"";//[inputTexts objectAtIndex:indexPath.row/2];
        textField.tag = indexPath.row;
        textField.delegate = self;
        cell.accessoryView = textField;
    [textField setKeyboardType:UIKeyboardTypeNumberPad];
    
    
    UIToolbar *ViewForDoneButtonOnKeyboard = [[UIToolbar alloc] init];
    [ViewForDoneButtonOnKeyboard sizeToFit];
    UIBarButtonItem *btnDoneOnKeyboard = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                          style:UIBarButtonItemStyleBordered target:self
                                                                         action:@selector(doneBtnFromKeyboardClicked:)];
    [ViewForDoneButtonOnKeyboard setItems:[NSArray arrayWithObjects:btnDoneOnKeyboard, nil]];
    
    textField.inputAccessoryView = ViewForDoneButtonOnKeyboard;


    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (IBAction)doneBtnFromKeyboardClicked:(id)sender
{
    NSLog(@"Done Button Clicked.");
    
    [self.view endEditing:YES];
}



- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
   NSLog(@"here!!");
    
    NSString * finalText = [NSString stringWithFormat:@"%@%@",textField.text,string];
    
    NSString * LS = [[measures objectAtIndex:textField.tag] objectForKey:@"LS"];
    NSString * LI = [[measures objectAtIndex:textField.tag] objectForKey:@"LI"];

    textField.textColor = [self chageColorOfTextLS:LS M:finalText LI:LI];
    
    return  YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
    [resultHelper addObject:@{[[measures objectAtIndex:textField.tag] objectForKey:@"MeasureName"]:textField.text}];

    NSLog(@"here");
    
}


-(NSString *)constructInfoLabel:(NSString *)one two:(NSString *)two
{
    return [NSString stringWithFormat:@"%@/%@",one,two];
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
- (IBAction)continueButtonPressed:(id)sender
{
    
    if (auditoriaIndex <sizeLot) {
        [result setObject:resultHelper forKey:[NSString stringWithFormat:@"measure %d",auditoriaIndex]];
        resultHelper = [[NSMutableArray alloc]init];
        auditoriaIndex++;
        
        if (sizeLot == auditoriaIndex) {
            [_btnContinue setTitle:@"Finaliza" forState:UIControlStateNormal];
        }
        _pageIndicatorTXT.text = [self constructInfoLabel:[NSString stringWithFormat:@"%d",auditoriaIndex] two:[NSString stringWithFormat:@"%@",_inspection.sizeLot]];
        [_tb reloadData];
        
    }else
    {
        [result setObject:resultHelper forKey:[NSString stringWithFormat:@"measure %d",auditoriaIndex]];
        _inspection.auditoriaResult =[[NSMutableArray alloc]init];
        [_inspection.auditoriaResult addObject:result];
        UIImage * image = [[[QRCodeGenerator alloc] initWithString:_inspection.idIspection] getImage];
        _inspection.QRCode = image;
        NSLog(@"inspection Final: %@",_inspection);
        
        [self performSegueWithIdentifier:@"segueProduct" sender:nil];
    }
    
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"segueProduct"]) {
        ViewController * VC = (ViewController *)[segue destinationViewController];
        [CoreDataManager saveIspection:_inspection];
        VC.inspection = _inspection;
    }
}


@end
