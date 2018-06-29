//
//  SpecificProductModel.h
//  Exmaples
//
//  Created by Ricardo Rojas on 24/06/18.
//  Copyright © 2018 Ricardo Rojas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GenericProductModel.h"

@interface SpecificProductModel : GenericProductModel

@property (nonatomic, strong) NSString * fechaInspeccion;
@property (nonatomic, strong) NSString * fechaLLegada;
@property (nonatomic, strong) NSString * fechaManufactura;
@property (nonatomic, strong) NSString * turno;
@property (nonatomic, strong) NSString * loteDirecto;
@property (nonatomic, strong) NSString * loteIndirecto;
@property (nonatomic, strong) NSString * cantidad;
@property (nonatomic, strong) NSString * inspector;
@property (nonatomic, strong) NSDictionary * valorEspecificacion;
@property (nonatomic, strong) UIImage * QRImageSpesificProduct;

@end
