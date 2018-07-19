//
//  BarCodeModel.h
//  QRApp
//
//  Created by Ricardo Rojas on 22/06/18.
//  Copyright © 2018 Ricardo Rojas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BarCodeModel : NSObject
@property (strong, nonatomic)  NSString *noParte;
@property (strong, nonatomic)  NSString *noLote;
@property (strong, nonatomic)  NSString *palet;
@property (strong, nonatomic)  NSString *paquete;
@property (strong, nonatomic)  NSString *paletsPorLote;
@property (strong, nonatomic)  NSString *paquetesPorPalets;
@property (strong, nonatomic)  NSString *cantidad;
@property (strong, nonatomic)  NSString *UM;
@property (strong, nonatomic)  NSString *fechaRecibo;
@property (strong, nonatomic)  NSString *noFactura;

@property (strong, nonatomic)  NSString *proveedor;


//FM-noParte-lote-palet-paquete-nopalets-noPaquetes-cantidad-UM-fechallegada-nofactura-fechaCaducidad


@end
