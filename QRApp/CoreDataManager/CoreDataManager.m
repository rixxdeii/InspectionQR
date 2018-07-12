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
    
    [loteData setValue:lote.noPaquetesPorPalet forKey:@"noPaquetesPorPalet"];
    [loteData setValue:lote.totalPalets forKey:@"totalPalets"];
    
    NSError *error = nil;
    // Save the object to persistent store
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
    
    
}

+(NSArray *)getLotesPedinetes{
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
            
            [arr addObject:LOT];
            
        }
         return arr;
        
    }
    
    return @[];

}

+(void)deleteLote:(int)indexselected{
    
    NSManagedObjectContext *context = ((AppDelegate*)[[UIApplication sharedApplication] delegate]).persistentContainer.viewContext;
   
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Inspection"];
    NSError *error = nil;
    NSArray *results = [context executeFetchRequest:request error:&error];
    
    
    [context deleteObject:[results objectAtIndex:indexselected]];
    
}


//+(NSArray *)getProductModel
//
//{
//    
//    NSManagedObjectContext *context = ((AppDelegate*)[[UIApplication sharedApplication] delegate]).persistentContainer.viewContext;
//    
//    
//    
//    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Product"];
//    NSError *error = nil;
//    
//    NSArray *results = [context executeFetchRequest:request error:&error];
//    
//    if (error != nil) {
//        //Deal with failure
//    }
//    else {
//        NSMutableArray * arr = [[NSMutableArray alloc]init];
//        
//        for (NSManagedObject * modele in results) {
//            
//            NSDictionary * dic = [self dataStructureFromManagedObject:modele];
//            
//            NSLog(@"get product :%@",dic);
//            
//            ProductModel * p = [[ProductModel alloc]init];
//            
//            NSData *data = [dic objectForKey:@"measures"];
//            
//            NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:data];
//            
//            p.idProduct  = [dic objectForKey:@"idproduct"];
//            p.measures  = array;
//            p.descrip  = [dic objectForKey:@"descrip"];
//            
//            [arr addObject:p];
//        }
//        
//        return arr;
//        
//    }
//    
//    return @[];
//}
//
//+(NSArray *)getIspectionModel
//{
//    NSManagedObjectContext *context = ((AppDelegate*)[[UIApplication sharedApplication] delegate]).persistentContainer.viewContext;
//    
//    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Inspection"];
//    NSError *error = nil;
//    
//    NSArray *results = [context executeFetchRequest:request error:&error];
//    
//    if (error != nil) {
//        //Deal with failure
//    }
//    else {
//        NSMutableArray * arr = [[NSMutableArray alloc]init];
//        
//        for (NSManagedObject * modele in results) {
//            
//            NSDictionary * dic = [self dataStructureFromManagedObject:modele];
//            
//            
//            NSLog(@"get Inspection  :%@",dic);
//            
//            InspectionModel * i = [[InspectionModel alloc]init];
//            
//            NSData *data = [dic objectForKey:@"qrcode"];
//            UIImage *image = [UIImage imageWithData:data];
//            
//            NSData *_data = [dic objectForKey:@"result"];
//            
//            NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:_data];
//              //[inspection setValue:inspection.auditoriaResult forKey:@"result"];
//            
//            
//            //    sizeMuestra
//            //    status
//            //    email
//            
//            i.auditor  = [dic objectForKey:@"auditos"];
//            i.QRCode  = image;
//            i.idIspection  = [dic objectForKey:@"idinspection"];
//            i.date = [dic objectForKey:@"fecha"];
//            i.sizeLot = [dic objectForKey:@"sizeMuestra"];
//            i.status = [dic objectForKey:@"status"];
//            i.email = [dic objectForKey:@"email"];
//            i.auditoriaResult = array;
//            
//            
//            
//            [arr addObject:i];
//        }
//        
//        return arr;
//        
//    }
//    
//    return @[];
//}
//
//
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
