//
//  LiberationPaper.h
//  FederalMogulM
//
//  Created by Ricardo Rojas on 27/06/18.
//  Copyright © 2018 Ricardo Rojas. All rights reserved.
//

#import "SpecificProductModel.h"

@interface LiberationPaper : SpecificProductModel

@property (nonatomic, strong) NSString * fechallegada;
@property (nonatomic, strong) NSString * fechaCaducidad;
@property (nonatomic, strong) NSString * lote;
@property (nonatomic, strong) NSString * palet;
@property (nonatomic, strong) NSString * unidades;
@property (nonatomic, strong) NSString * proveedor;
@property (nonatomic, strong) NSString * statusLiberacion;
@property (nonatomic, strong) NSDictionary * medidasReales;
@property (nonatomic, strong) NSString * cantidad;
@property (nonatomic, strong) NSString * unidadMedida;
@end
