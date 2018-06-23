//
//  CoreDataManager.m
//  QRApp
//
//  Created by Ricardo Rojas on 09/06/18.
//  Copyright © 2018 Ricardo Rojas. All rights reserved.
//

#import "CoreDataManager.h"


@implementation CoreDataManager


+(void)saveIspection:(InspectionModel *)inspection
{
    
    NSManagedObjectContext *context = ((AppDelegate*)[[UIApplication sharedApplication] delegate]).persistentContainer.viewContext;
    
    NSManagedObject *inspectionData = [NSEntityDescription insertNewObjectForEntityForName:@"Inspection" inManagedObjectContext:context];
    
    //    auditor
    //    fecha
    //    idinspection
    //    qrcode
    //    sizeMuestra
    //    status
    //email
    
    NSData *imageData = UIImagePNGRepresentation(inspection.QRCode);
    
    [inspectionData setValue:inspection.auditor forKey:@"auditor"];
    [inspectionData setValue:[NSDate date] forKey:@"fecha"];
    [inspectionData setValue:inspection.idIspection forKey:@"idinspection"];
    [inspectionData setValue:imageData forKey:@"qrcode"];
    [inspectionData setValue:inspection.sizeLot forKey:@"sizeMuestra"];
    [inspectionData setValue:inspection.status forKey:@"status"];
    [inspectionData setValue:inspection.email forKey:@"email"];
    [inspection setValue:[NSKeyedArchiver archivedDataWithRootObject:inspection.auditoriaResult] forKey:@"result"] ;
    
    NSError *error = nil;
    // Save the object to persistent store
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
    
    
}

+(void)saveProduct:(ProductModel *)product
{
    NSManagedObjectContext *context = ((AppDelegate*)[[UIApplication sharedApplication] delegate]).persistentContainer.viewContext;
    NSManagedObject *productData = [NSEntityDescription insertNewObjectForEntityForName:@"Product" inManagedObjectContext:context];
    
    //    descrip
    //    idproduct
    //    measures
    [productData setValue:product.descrip forKey:@"descrip"];
    [productData setValue:product.idProduct forKey:@"idproduct"];
    [productData setValue:[NSKeyedArchiver archivedDataWithRootObject:product.measures] forKey:@"measures"];
    NSError *error = nil;
    // Save the object to persistent store
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
    
}


+(NSArray *)getProductModel

{
    
    NSManagedObjectContext *context = ((AppDelegate*)[[UIApplication sharedApplication] delegate]).persistentContainer.viewContext;
    
    
    
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Product"];
    NSError *error = nil;
    
    NSArray *results = [context executeFetchRequest:request error:&error];
    
    if (error != nil) {
        //Deal with failure
    }
    else {
        NSMutableArray * arr = [[NSMutableArray alloc]init];
        
        for (NSManagedObject * modele in results) {
            
            NSDictionary * dic = [self dataStructureFromManagedObject:modele];
            
            NSLog(@"get product :%@",dic);
            
            ProductModel * p = [[ProductModel alloc]init];
            
            NSData *data = [dic objectForKey:@"measures"];
            
            NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            
            p.idProduct  = [dic objectForKey:@"idproduct"];
            p.measures  = array;
            p.descrip  = [dic objectForKey:@"descrip"];
            
            [arr addObject:p];
        }
        
        return arr;
        
    }
    
    return @[];
}

+(NSArray *)getIspectionModel
{
    NSManagedObjectContext *context = ((AppDelegate*)[[UIApplication sharedApplication] delegate]).persistentContainer.viewContext;
    
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Inspection"];
    NSError *error = nil;
    
    NSArray *results = [context executeFetchRequest:request error:&error];
    
    if (error != nil) {
        //Deal with failure
    }
    else {
        NSMutableArray * arr = [[NSMutableArray alloc]init];
        
        for (NSManagedObject * modele in results) {
            
            NSDictionary * dic = [self dataStructureFromManagedObject:modele];
            
            
            NSLog(@"get Inspection  :%@",dic);
            
            InspectionModel * i = [[InspectionModel alloc]init];
            
            NSData *data = [dic objectForKey:@"qrcode"];
            UIImage *image = [UIImage imageWithData:data];
            
            NSData *_data = [dic objectForKey:@"result"];
            
            NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:_data];
              //[inspection setValue:inspection.auditoriaResult forKey:@"result"];
            
            
            //    sizeMuestra
            //    status
            //    email
            
            i.auditor  = [dic objectForKey:@"auditos"];
            i.QRCode  = image;
            i.idIspection  = [dic objectForKey:@"idinspection"];
            i.date = [dic objectForKey:@"fecha"];
            i.sizeLot = [dic objectForKey:@"sizeMuestra"];
            i.status = [dic objectForKey:@"status"];
            i.email = [dic objectForKey:@"email"];
            i.auditoriaResult = array;
            
            
            
            [arr addObject:i];
        }
        
        return arr;
        
    }
    
    return @[];
}


+ (NSDictionary*)dataStructureFromManagedObject:(NSManagedObject*)managedObject
{
    NSDictionary *attributesByName        = [[managedObject entity] attributesByName];
    NSDictionary *relationshipsByName     = [[managedObject entity] relationshipsByName];
    NSMutableDictionary *valuesDictionary = [[managedObject dictionaryWithValuesForKeys:[attributesByName allKeys]] mutableCopy];
    [valuesDictionary setObject:[[managedObject entity] name] forKey:@"Product"];
    
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
