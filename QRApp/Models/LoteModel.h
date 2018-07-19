//
//  LoteModel.h
//  FederalMogulM
//
//  Created by Ricardo Rojas on 04/07/18.
//  Copyright © 2018 Ricardo Rojas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BarCodeModel.h"
#import "GenericProductModel.h"
@interface LoteModel : NSObject

@property (nonatomic, strong) NSString * noParte;
@property (nonatomic, strong) NSString * noLote;
@property (nonatomic, strong) NSString * estatusLiberacion;
@property (nonatomic, strong) NSMutableDictionary * muestreo;
@property (nonatomic, strong) NSString * fechaCaducidad;
@property (nonatomic, strong) NSString *fechaManufactura;
@property (nonatomic, strong) NSString *proveedor;
@property (nonatomic, strong) NSString *cantidadTotalporLote;
@property (nonatomic, strong) NSString *unidadMedida;
@property (nonatomic, strong) NSString * ubicacion;
@property (nonatomic, strong) NSString * noFactura;
@property (nonatomic, strong) NSString *fechaLlegada;
@property (nonatomic, strong) NSString *tipoPorducto;
@property (nonatomic, strong) NSString *fechaLiberacion;

@property  NSString * noPalet;
@property  NSString * paquete;
@property NSString * noPaquetesPorPalet;
@property NSString * totalPalets;


@end
