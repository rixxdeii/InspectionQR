//
//  CoreDataManager.m
//  QRApp
//
//  Created by Ricardo Rojas on 09/06/18.
//  Copyright © 2018 Ricardo Rojas. All rights reserved.
//

#import "CoreDataManager.h"


@implementation CoreDataManager


+(void)loteStatusPendiente:(LoteModel *)lote;
{
    NSLog(@"ios Version :  %@",[[UIDevice currentDevice] systemVersion]) ;
    
    NSArray * iOSVersionsDescompost = [[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."];
    
    NSString * iOSVersion = [iOSVersionsDescompost firstObject];
    uint iOSVersionNumber =[iOSVersion intValue];
    
    if (iOSVersionNumber <10)
    {
        NSMutableArray * arr = [[NSMutableArray alloc]init];
        
        [arr addObject:[self saveLotemodel:lote]];
        
        NSArray * arrPendientes = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"standarPendientes"]];
        
        for (NSDictionary *object in arrPendientes) {
            [arr addObject:object];
        }
        
        
        [[NSUserDefaults standardUserDefaults]setObject:[NSKeyedArchiver archivedDataWithRootObject:arr] forKey:@"standarPendientes"];
        
        return;
    }
    
    NSManagedObjectContext *context = ((AppDelegate*)[[UIApplication sharedApplication] delegate]).persistentContainer.viewContext;
    
    NSManagedObject *loteData = [NSEntityDescription insertNewObjectForEntityForName:@"Inspection" inManagedObjectContext:context];
    
    
    [loteData setValue:[NSKeyedArchiver archivedDataWithRootObject:lote.muestreo] forKey:@"muestreo"];
    [loteData setValue:lote.noParte forKey:@"noParte"];
    [loteData setValue:lote.noLote forKey:@"noLote"];
    [loteData setValue:lote.estatusLiberacion forKey:@"estatusLiberacion"];
    [loteData setValue:lote.fechaCaducidad forKey:@"fechaCaducidad"];
    [loteData setValue:lote.fechaManufactura forKey:@"fechaManufactura"];
    [loteData setValue:lote.proveedor forKey:@"proveedor"];
    [loteData setValue:lote.cantidadTotalporLote forKey:@"cantidadTotalporLote"];
    [loteData setValue:lote.unidadMedida forKey:@"unidadMedida"];
    
    [loteData setValue:lote.ubicacion forKey:@"ubicacion"];
    [loteData setValue:lote.noPalet forKey:@"noPalet"];
    [loteData setValue:lote.paquete forKey:@"paquete"];
    
    [loteData setValue:lote.noPaquetesPorPalet forKey:@"noPaquetesPorPalet"];
    [loteData setValue:lote.totalPalets forKey:@"totalPalets"];
    [loteData setValue:lote.fechaLiberacion forKey:@"fechaLiberacion"];
    [loteData setValue:lote.fechaLlegada forKey:@"fechaLlegada"];
    [loteData setValue:lote.tipoPorducto forKey:@"tipoPorducto"];
    [loteData setValue:lote.nivelRevision forKey:@"nivelRevision"];
    
    NSError *error = nil;
    // Save the object to persistent store
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
    
    
}

+(NSDictionary *)saveLotemodel:(LoteModel *)model{
    
    
    
    NSDictionary * dicTosend = @{@"noParte":model.noParte,
                                 @"noLote":model.noLote,
                                 @"proveedor":model.proveedor,
                                 @"cantidadTotalporLote":model.cantidadTotalporLote,
                                 @"unidadMedida":model.unidadMedida,
                                 @"noPalet":model.noPalet,
                                 @"paquete":model.paquete,
                                 @"fechaCaducidad":model.fechaCaducidad,
                                 @"totalPalets":model.totalPalets,
                                 @"totalPaquetes":model.noPaquetesPorPalet,
                                 @"muestreo":[NSKeyedArchiver archivedDataWithRootObject:model.muestreo],
                                 @"estatusLiberacion":model.estatusLiberacion,
                                 @"noPaquetesPorPalet":model.noPaquetesPorPalet,
                                 @"fechaLlegada":model.fechaLlegada,
                                 @"tipoProducto":model.tipoPorducto,
                                 @"ubicacion":model.ubicacion,
                                 @"noFactura":model.noFactura,
                                 @"fechaLiberacion":model.fechaLiberacion,
                                 @"tipoPorducto":model.tipoPorducto,
                                 @"nivelRevision":model.nivelRevision
                                 };
    
    return dicTosend;
    
}

+(NSArray *)getLotesPedinetes{
    
    NSLog(@"ios Version :  %@",[[UIDevice currentDevice] systemVersion]) ;
    
    NSArray * iOSVersionsDescompost = [[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."];
    
    NSString * iOSVersion = [iOSVersionsDescompost firstObject];
    uint iOSVersionNumber =[iOSVersion intValue];
    
    if (iOSVersionNumber <10)
    {
        NSMutableArray * arrHelper =[[NSMutableArray alloc]init];
        NSArray * arr = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"standarPendientes"]];
        
        for (NSDictionary *object in arr) {
            
            [arrHelper addObject:[self getLoteStructure:object]];
        }
        
        
        return arrHelper;
        
    }
    
    
    NSManagedObjectContext *context = ((AppDelegate*)[[UIApplication sharedApplication] delegate]).persistentContainer.viewContext;
    
    //    NSManagedObject *loteData = [NSEntityDescription insertNewObjectForEntityForName:@"Inspection" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Inspection"];
    
    NSError *error = nil;
    
    NSArray *results = [context executeFetchRequest:request error:&error];
    
    if (error != nil) {
        //Deal with failure
    }else{
        NSMutableArray * arr = [[NSMutableArray alloc]init];
        
        for (NSManagedObject * modele in results) {
            LoteModel * LOT = [[LoteModel alloc]init];
            NSDictionary * dic = [self dataStructureFromManagedObject:modele];
            
            
            NSData *data = [dic objectForKey:@"muestreo"];
            
            NSDictionary *array = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            
            LOT.muestreo = [array mutableCopy];
            LOT.noParte = [dic objectForKey:@"noParte"];
            LOT.noLote = [dic objectForKey:@"noLote"];
            LOT.estatusLiberacion = [dic objectForKey:@"estatusLiberacion"];
            LOT.fechaCaducidad = [dic objectForKey:@"fechaCaducidad"];
            LOT.fechaManufactura = [dic objectForKey:@"fechaManufactura"];
            LOT.proveedor = [dic objectForKey:@"proveedor"];
            LOT.cantidadTotalporLote = [dic objectForKey:@"cantidadTotalporLote"];
            LOT.unidadMedida = [dic objectForKey:@"unidadMedida"];
            LOT.ubicacion = [dic objectForKey:@"ubicacion"];
            LOT.noPalet = [dic objectForKey:@"noPalet"];
            LOT.noPaquetesPorPalet = [dic objectForKey:@"noPaquetesPorPalet"];
            LOT.totalPalets = [dic objectForKey:@"totalPalets"];
            LOT.noFactura =[dic objectForKey:@"noFactura"];
            LOT.fechaLiberacion =[dic objectForKey:@"fechaLiberacion"];
            LOT.paquete =[dic objectForKey:@"paquete"];
            LOT.fechaLlegada =[dic objectForKey:@"fechaLlegada"];
            LOT.tipoPorducto =[dic objectForKey:@"tipoPorducto"];
            LOT.nivelRevision =[dic objectForKey:@"nivelRevision"];
            
            [arr addObject:LOT];
            
        }
        return arr;
        
    }
    
    return @[];
    
}

+(LoteModel *)getLoteStructure:(NSDictionary *)dic{
    LoteModel * LOT = [[LoteModel alloc]init];
    NSData *data = [dic objectForKey:@"muestreo"];
    
    NSDictionary *array = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    LOT.muestreo = [array mutableCopy];
    LOT.noParte = [dic objectForKey:@"noParte"];
    LOT.noLote = [dic objectForKey:@"noLote"];
    LOT.estatusLiberacion = [dic objectForKey:@"estatusLiberacion"];
    LOT.fechaCaducidad = [dic objectForKey:@"fechaCaducidad"];
    LOT.fechaManufactura = [dic objectForKey:@"fechaManufactura"];
    LOT.proveedor = [dic objectForKey:@"proveedor"];
    LOT.cantidadTotalporLote = [dic objectForKey:@"cantidadTotalporLote"];
    LOT.unidadMedida = [dic objectForKey:@"unidadMedida"];
    LOT.ubicacion = [dic objectForKey:@"ubicacion"];
    LOT.noPalet = [dic objectForKey:@"noPalet"];
    LOT.noPaquetesPorPalet = [dic objectForKey:@"noPaquetesPorPalet"];
    LOT.totalPalets = [dic objectForKey:@"totalPalets"];
    LOT.noFactura =[dic objectForKey:@"noFactura"];
    LOT.fechaLiberacion =[dic objectForKey:@"fechaLiberacion"];
    LOT.paquete =[dic objectForKey:@"paquete"];
    LOT.fechaLlegada =[dic objectForKey:@"fechaLlegada"];
    LOT.tipoPorducto =[dic objectForKey:@"tipoPorducto"];
    LOT.nivelRevision =[dic objectForKey:@"nivelRevision"];
    
    return LOT;
}

+(void)deleteLote:(int)indexselected{
    
    NSLog(@"ios Version :  %@",[[UIDevice currentDevice] systemVersion]) ;
    
    NSArray * iOSVersionsDescompost = [[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."];
    
    NSString * iOSVersion = [iOSVersionsDescompost firstObject];
    uint iOSVersionNumber =[iOSVersion intValue];
    
    if (iOSVersionNumber <10)
    {
        NSMutableArray * arrHelper =[[NSMutableArray alloc]init];
        NSArray * arr = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"standarPendientes"]];
        
        for (NSDictionary *object in arr) {
            
            [arrHelper addObject:[self getLoteStructure:object]];
        }
        
        
        [arrHelper removeObjectAtIndex:indexselected];
        
        [[NSUserDefaults standardUserDefaults]setObject:[NSKeyedArchiver archivedDataWithRootObject:arrHelper] forKey:@"standarPendientes"];
        return;
        
    }
    
    
    NSManagedObjectContext *context = ((AppDelegate*)[[UIApplication sharedApplication] delegate]).persistentContainer.viewContext;
    
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Inspection"];
    NSError *error = nil;
    NSArray *results = [context executeFetchRequest:request error:&error];
    
    
    [context deleteObject:[results objectAtIndex:indexselected]];
    
}

+ (NSDictionary*)dataStructureFromManagedObject:(NSManagedObject*)managedObject
{
    NSDictionary *attributesByName        = [[managedObject entity] attributesByName];
    NSDictionary *relationshipsByName     = [[managedObject entity] relationshipsByName];
    NSMutableDictionary *valuesDictionary = [[managedObject dictionaryWithValuesForKeys:[attributesByName allKeys]] mutableCopy];
    [valuesDictionary setObject:[[managedObject entity] name] forKey:@"Inspection"];
    
    for (NSString *relationshipName in [relationshipsByName allKeys]) {
        
        NSRelationshipDescription *description = [[[managedObject entity] relationshipsByName] objectForKey:relationshipName];
        
        if ([[[description userInfo] objectForKey:@"isExportable"] boolValue] == YES) {
            
            if (![description isToMany]) {
                NSManagedObject *relationshipObject = [managedObject valueForKey:relationshipName];
                if (relationshipObject) {
                    [valuesDictionary setObject:[self dataStructureFromManagedObject:relationshipObject] forKey:relationshipName];
                }
                
                continue;
            }
            
            NSSet *relationshipObjects        = [managedObject valueForKey:relationshipName];
            NSMutableArray *relationshipArray = [[NSMutableArray alloc] init];
            
            for (NSManagedObject *relationshipObject in relationshipObjects) {
                [relationshipArray addObject:[self dataStructureFromManagedObject:relationshipObject]];
            }
            
            [valuesDictionary setObject:relationshipArray forKey:relationshipName];
            
        }
        
    }
    return valuesDictionary;
}

@end
