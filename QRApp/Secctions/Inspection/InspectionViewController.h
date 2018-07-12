//
//  InspectionViewController.h
//  QRApp
//
//  Created by Ricardo Rojas on 09/06/18.
//  Copyright © 2018 Ricardo Rojas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BarCodeModel.h"
#import "GenericProductModel.h"
#import "LoteModel.h"


@interface InspectionViewController : UIViewController

@property (nonatomic, strong) BarCodeModel * barcode;
@property (nonatomic, strong) GenericProductModel * product;
@property (nonatomic, strong) LoteModel * lote;

@property (nonatomic,weak) IBOutlet UILabel * infolabel;
@property (weak, nonatomic) IBOutlet UITableView *inspectionTableView;
@property (weak, nonatomic) IBOutlet UITableView *LoteTableView;

@property (weak, nonatomic) IBOutlet UIButton *btnContinue;
@property (weak, nonatomic) IBOutlet UILabel *pageIndicatorTXT;
@property (weak, nonatomic) IBOutlet UILabel *paletText;
@property (weak, nonatomic) IBOutlet UILabel *inspectorTxt;
@property BOOL comefromPendiente;
@property int pendenteInexx;



@end
