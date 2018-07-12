//
//  BarCodeModel.h
//  QRApp
//
//  Created by Ricardo Rojas on 22/06/18.
//  Copyright © 2018 Ricardo Rojas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BarCodeModel : NSObject
@property (weak, nonatomic)  NSString *noParte;
@property (weak, nonatomic)  NSString *noLote;
@property (weak, nonatomic)  NSString *palet;
@property (weak, nonatomic)  NSString *paquete;
@property (weak, nonatomic)  NSString *paquetesPorLote;
@property (weak, nonatomic)  NSString *cantidad;
@property (weak, nonatomic)  NSString *UM;
@property (weak, nonatomic)  NSString *proveedor;
@property (weak, nonatomic)  NSString *fechaRecibo;
@property (weak, nonatomic)  NSString *fechaCad;
@property (weak, nonatomic)  NSString *totalPalest;

//FM-GXC1234-11223344-1-1-10-500-KG-LAPINOS-17/05/18-17/05/18


@end
