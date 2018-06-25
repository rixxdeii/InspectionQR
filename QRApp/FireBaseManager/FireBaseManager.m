//
//  FireBaseManager.m
//  Exmaples
//
//  Created by Ricardo Rojas on 24/06/18.
//  Copyright © 2018 Ricardo Rojas. All rights reserved.
//

#import "FireBaseManager.h"

@implementation FireBaseManager

+(FIRDatabaseReference *)getReference{
    return  [[FIRDatabase database] reference];
}


+(void)saveGProduct:(GenericProductModel *)model
{


    NSDictionary * dicTosend = @{@"noParte":model.noParte,
                                    @"descript":model.descript,
                                 @"nivelRevision":model.nivelRevision,
                                 @"especificaciones":[NSString stringWithFormat:@"%@",model.especificaciones],
                                 @"muestra":model.muestra,
                                 @"caracterisiticaCritica":model.caracterisiticaCritica,
                                 @"almacenajeFrio":model.almacenaje,
                                 @"tipoproducto":model.tipoproducto
                                 //@"urlsDocumentos":model.urlsDocumentos,
                                 };
    FIRDatabaseReference * ref = [[FIRDatabase database] reference];
    
    [[[ref child:@"genericProduct"] child:model.noParte]
     setValue:dicTosend];

}
+(void)saveSProduct:(SpecificProductModel *)model
{
    NSDictionary * dicTosend = @{@"descript":model.descript,
//                                 @"nivelRevision":model.nivelRevision,
//                                 @"especificaciones":[NSString stringWithFormat:@"%@",model.especificaciones],
//                                 @"muestra":model.muestra,
//                                 @"caracterisiticaCritica":model.caracterisiticaCritica,
//                                 @"almacenaje":model.almacenaje,
                                 //@"urlsDocumentos":model.urlsDocumentos,
                                 @"fechaLLegada":model.fechaLLegada,
                                 @"fechaManufactura":model.fechaManufactura,
                                 @"turno":model.turno,
                                 @"loteDirecto":model.loteDirecto,
                                 @"loteIndirecto":model.loteIndirecto,
                                 @"cantidad":model.cantidad,
                                 @"inspector":model.inspector
                                 };
    FIRDatabaseReference * ref = [[FIRDatabase database] reference];
    
    [[[ref child:@"specificProduct"] child:[NSString stringWithFormat:@"%@-%@",model.noParte,model.loteDirecto ]]
     setValue:dicTosend];
    
}



+(void)getGProduct:(NSString *)model delegate:(id<FirebaseManagerDelegate> )delegate
{
    FIRDatabaseReference * ref = [[FIRDatabase database] reference];
    [[[ref child:@"genericProduct"] child:model] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {

        GenericProductModel * GP = [[GenericProductModel alloc]init];
        
        GP.noParte = snapshot.value[@"noParte"];
        GP.descript  =snapshot.value[@"descript"];
        GP.nivelRevision  =@"nivelRevision";
        GP.especificaciones  =snapshot.value[@""];
        GP.caracterisiticaCritica  =snapshot.value[@"caracterisiticaCritica"];
        GP.muestra  =snapshot.value[@"muestra"];
        GP.almacenaje  =snapshot.value[@"almacenajeFrio"];
        GP.tipoproducto = snapshot.value[@"tipoproducto"];
    
        [delegate GPStatusChanged:GP];
        
    } withCancelBlock:^(NSError * _Nonnull error) {
        NSLog(@"%@", error.localizedDescription);
        [delegate GPStatusChanged:nil];
    }];
    
    
    
}
+(void)getSProduct:(NSString *)model lote:(NSString *)lote delegate:(id<FirebaseManagerDelegate> )delegate
{
    
    FIRDatabaseReference * ref = [[FIRDatabase database] reference];
    [[[ref child:@"specificProduct"] child:[NSString stringWithFormat:@"%@-%@",model,lote]] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        // Get user value
        SpecificProductModel * SP = [[SpecificProductModel alloc]init];
        
        SP.noParte = snapshot.value[@"noParte"];
        SP.loteDirecto = snapshot.value[@"loteDirecto"];
        SP.fechaLLegada =snapshot.value[@"fechaLLegada"];
        SP.fechaManufactura = snapshot.value[@"fechaManufactura"];
        SP.turno = snapshot.value[@"turno"];
        SP.loteIndirecto = snapshot.value[@"loteIndirecto"];
        SP.cantidad = snapshot.value[@"cantidad"];
        SP.inspector = snapshot.value[@"inspector"];
        SP.descript = snapshot.value[@"descript"];

        [delegate GPStatusChanged:SP];
        // ...
    } withCancelBlock:^(NSError * _Nonnull error) {
        NSLog(@"%@", error.localizedDescription);
        [delegate GPStatusChanged:nil];
    }];
    
    
}


@end
