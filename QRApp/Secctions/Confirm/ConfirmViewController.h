//
//  ConfirmViewController.h
//  QRApp
//
//  Created by Ricardo Rojas on 25/06/18.
//  Copyright © 2018 Ricardo Rojas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GenericProductModel.h"
#import "LoteModel.h"
#import "BarCodeModel.h"

@interface ConfirmViewController : UIViewController

@property (nonatomic, strong) GenericProductModel * product;
@property (nonatomic, strong) LoteModel * lote;
@property (nonatomic, strong) BarCodeModel * barcode;
@property (nonatomic, strong)NSString * comeFrom;
@property BOOL comeFromPendientes;

@property BOOL existLote;
@property int pendenteInexx;



@end
