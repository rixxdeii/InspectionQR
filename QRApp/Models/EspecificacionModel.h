//
//  EspecificacionModel.h
//  FederalMogulM
//
//  Created by Ricardo Rojas on 04/07/18.
//  Copyright © 2018 Ricardo Rojas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EspecificacionModel : NSObject
@property(nonatomic, strong)NSString * descripcion;
@property(nonatomic, strong)NSString * tipoChek;
@property(nonatomic, strong)NSString * medidaCritica;
@property(nonatomic, strong)NSString * tolerancias;
@property(nonatomic, strong)NSString * tipoIstrumento;
@property(nonatomic, strong)NSString * unidadMedida;
@property(nonatomic, strong)NSString * medidaReal;
@end
