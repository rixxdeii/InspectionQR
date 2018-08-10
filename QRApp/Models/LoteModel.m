//
//  LoteModel.m
//  FederalMogulM
//
//  Created by Ricardo Rojas on 04/07/18.
//  Copyright © 2018 Ricardo Rojas. All rights reserved.
//

#import "LoteModel.h"


@implementation LoteModel

-(NSDictionary *)getDictionaryFromLoteModel:(LoteModel *)model
{
    
    return @{@"noParte":model.noParte,
             @"noLote":model.noLote,
             @"estatusLiberacion":model.estatusLiberacion,
             @"muestreo":model.muestreo,
             @"fechaCaducidad":model.fechaCaducidad,
             @"fechaManufactura":model.fechaManufactura,
             @"proveedor":model.proveedor,
             @"cantidadTotalporLote":model.cantidadTotalporLote,
             @"unidadMedida":model.unidadMedida,
             @"ubicacion":model.ubicacion,
             @"noFactura":model.noFactura,
             @"fechaLlegada":model.fechaLlegada,
             @"tipoPorducto":model.tipoPorducto,
             @"fechaLiberacion":model.fechaLiberacion,
             @"noPalet":model.noPalet,
             @"paquete":model.paquete,
             @"noPaquetesPorPalet":model.noPaquetesPorPalet,
             @"totalPalets":model.totalPalets,
             @"nivelRevision":model.nivelRevision
             
             };
    
}

-(LoteModel *)getLoteModelFromDictionary:(NSDictionary *)model
{
    
    
    self.noParte =  [model objectForKey:@"noParte"];
    self.noLote =  [model objectForKey:@"noLote"];
    self.estatusLiberacion =  [model objectForKey:@"estatusLiberacion"];
    self.muestreo =  [model objectForKey:@"muestreo"];
    self.fechaCaducidad =  [model objectForKey:@"fechaCaducidad"];
    self.fechaManufactura =  [model objectForKey:@"fechaManufactura"];
    self.proveedor =  [model objectForKey:@"proveedor"];
    self.cantidadTotalporLote =  [model objectForKey:@"cantidadTotalporLote"];
    self.unidadMedida =  [model objectForKey:@"unidadMedida"];
    self.ubicacion =  [model objectForKey:@"ubicacion"];
    self.noFactura =  [model objectForKey:@"noFactura"];
    self.fechaLlegada=  [model objectForKey:@"fechaLlegada"];
    self.tipoPorducto =  [model objectForKey:@"tipoPorducto"];
    self.fechaLiberacion =  [model objectForKey:@"fechaLiberacion"];
    self.noPalet =  [model objectForKey:@"noPalet"];
    self.paquete=  [model objectForKey:@"paquete"];
    self.noPaquetesPorPalet =  [model objectForKey:@"noPaquetesPorPalet"];
    self.totalPalets =  [model objectForKey:@"totalPalets"];
    
    
    return self;
    
}





@end
