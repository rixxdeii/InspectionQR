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


-(void)saveGProduct:(GenericProductModel *)model completion:(void(^)(BOOL isOK))completion
{
    timer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(sinInternet) userInfo:nil repeats:NO] ;
    
    NSDictionary * dicTosend = @{@"noParte":model.noParte,
                                 @"descript":model.descript,
                                 @"nivelRevision":model.nivelRevision,
                                 @"almacenajeFrio":model.almacenaje,
                                 @"especificaciones":[model.especificaciones objectForKey:@"especificaciones"],
                                 @"muestra":model.muestra,
                                 @"tipoproducto":model.tipoproducto
                                 };
    FIRDatabaseReference * ref = [[FIRDatabase database] reference];
    
    [[[ref child:@"calidad"] child:model.noParte] setValue:dicTosend withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
        
        [timer invalidate];
        if (!error) {
            completion(YES);;
        }else{
            completion(NO);;
        }
    
    }];
    


}

-(void)saveLote:(LoteModel *)model completion:(void(^)(BOOL isOK))completion
{
    timer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(sinInternet) userInfo:nil repeats:NO] ;
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    // or @"yyyy-MM-dd hh:mm:ss a" if you prefer the time with AM/PM
    NSLog(@"%@",[dateFormatter stringFromDate:[NSDate date]]);
    
    NSDictionary * dicTosend = @{@"noParte":model.noParte,
                                 @"noLote":model.noLote,
                                 @"proveedor":model.proveedor,
                                 @"cantidadTotalporLote":model.cantidadTotalporLote,
                                 @"unidadMedida":model.unidadMedida,
                                 @"totalPalets":model.totalPalets,
                                 @"noPaquetesPorPalet":model.noPaquetesPorPalet,
                                 @"fechaLlegada":model.fechaLlegada,
                                 @"noFactura":model.noFactura
                                 
                                 };
    FIRDatabaseReference * ref = [[FIRDatabase database] reference];
    
    [[[[ref child:@"recepcion"] child:model.noParte] child:model.noLote]setValue:dicTosend withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
        
        [timer invalidate];
        if (!error) {
            completion(YES);;
        }else{
            completion(NO);;
        }
        
    }];
    
    
//    [[[[ref child:@"recepcion"] child:model.noParte] child:@"cantidadGlobal"]observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
//        [timer invalidate];
//
//
//        if (snapshot.exists) {
//            NSString * value =snapshot.value;
//
//            NSInteger  lastint = [self integerFromString:value] + [self integerFromString:model.cantidadTotalporLote ];
//
//            NSString * result =[NSString stringWithFormat:@"%ld",(long)lastint];
//
//
//            [[[[ref child:@"recepcion"] child:model.noParte] child:@"cantidadGlobal"]setValue:result withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
//
//                [timer invalidate];
//                if (!error) {
//
//                }else{
//
//                }
//
//            }];
//
//
//
//        }
//
//
//    } withCancelBlock:^(NSError * _Nonnull error) {
//        [timer invalidate];
//        NSLog(@"%@", error.localizedDescription);
//
//    }];

    
    

    
}



-(NSInteger)integerFromString:(NSString *)string
{
    NSNumberFormatter *formatter=[[NSNumberFormatter alloc]init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber *numberObj = [formatter numberFromString:string];
    return [numberObj integerValue];
}

-(void)saveLiberation:(LoteModel *)model completion:(void(^)(BOOL isOK))completion
{
    timer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(sinInternet) userInfo:nil repeats:NO] ;
    
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    // or @"yyyy-MM-dd hh:mm:ss a" if you prefer the time with AM/PM
    NSLog(@"%@",[dateFormatter stringFromDate:[NSDate date]]);

    NSDictionary * dicTosend = @{@"noLote":model.noLote,
                                 @"proveedor":model.proveedor,
                                 @"cantidadTotalporLote":model.cantidadTotalporLote,
                                 @"unidadMedida":model.unidadMedida,
                                 @"palet":model.noPalet,
                                 @"paquete":model.paquete,
                                 @"fechaCaducidad":model.fechaCaducidad,
                                 @"totalPalets":model.totalPalets,
                                 @"totalPaquetes":model.noPaquetesPorPalet,
                                 @"muestreo":model.muestreo,
                                 @"estatusLiberacion":model.estatusLiberacion,
                                 @"noPaquetesPorPalet":model.noPaquetesPorPalet,
                                 @"fechaLlegada":model.fechaLlegada,
                                 @"tipoProducto":model.tipoPorducto
                                 };
    FIRDatabaseReference * ref = [[FIRDatabase database] reference];
    

    if  ([model.tipoPorducto isEqualToString:@"Químico"])
    {
        NSString *childName =[NSString stringWithFormat:@"%@-%@",model.noParte,model.noLote];
        NSString *subChildname =[NSString stringWithFormat:@"%@-%@",model.noPalet,model.paquete];
        
        [[[[ref child:@"liberationQuimico"] child:childName]child:subChildname] setValue:dicTosend withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
            
            [timer invalidate];
            if (!error) {
                completion(YES);;
            }else{
                completion(NO);;
            }
            
        }];
        
        
        
        [[[ref child:@"liberationQuimico"] child:childName] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            [timer invalidate];
            
            if (snapshot.exists) {
                        NSInteger  total = [model.noPaquetesPorPalet integerValue] * [model.totalPalets integerValue];
                
                NSDictionary * dic = snapshot.value;
                
                if (dic.count >= total) {
                    [[[[ref child:@"recepcion"] child:model.noParte] child:model.noLote] removeValueWithCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
            
                    }];
                    
                }
                
            }else{
                
            }
        
        } withCancelBlock:^(NSError * _Nonnull error) {
            
            NSLog(@"%@", error.localizedDescription);
            
            
        }];
        
        
        
        
        
        
    }else{
        
        [[[[ref child:@"liberation"] child:model.noParte] child:model.noLote]setValue:dicTosend withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
            
            [timer invalidate];
            if (!error) {
                completion(YES);;
            }else{
                completion(NO);;
            }
            
        }];
        
        
        [[[[ref child:@"recepcion"] child:model.noParte] child:model.noLote] removeValueWithCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
            
            
        }];
        
        
    }
    
}

-(void)getLotes:(NSString *)model completion:(void(^)(BOOL isOK,BOOL Exist, NSDictionary *newModel))completion //valida:(blockGP)valida
{
    timer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(sinInternet) userInfo:nil repeats:NO] ;
    
    
    FIRDatabaseReference * ref = [[FIRDatabase database] reference];
    [[ref child:@"recepcion"]observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        [timer invalidate];
        
        if (snapshot.exists) {
            NSDictionary * dic =snapshot.value;
             completion(YES,snapshot.exists,dic );
        }else{
            completion(YES,snapshot.exists,nil );
        }
        
        
        
        
    } withCancelBlock:^(NSError * _Nonnull error) {
        [timer invalidate];
        NSLog(@"%@", error.localizedDescription);
        //[delegate GPStatusChanged:nil];
        completion(NO,NO,nil);
        
    }];
    
}

-(void)getGProduct:(NSString *)model completion:(void(^)(BOOL isOK,BOOL Exist, GenericProductModel *newModel))completion //valida:(blockGP)valida
{
    timer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(sinInternet) userInfo:nil repeats:NO] ;
    
    
    
    
    FIRDatabaseReference * ref = [[FIRDatabase database] reference];
    [[[ref child:@"calidad"] child:model] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        [timer invalidate];
        
        GenericProductModel * GP = [[GenericProductModel alloc]init];
        
        if (snapshot.exists) {
            
            GP.noParte = snapshot.value[@"noParte"];
            GP.descript  =snapshot.value[@"descript"];
            GP.nivelRevision  =@"nivelRevision";
            GP.especificaciones  =snapshot.value[@"especificaciones"];
            GP.muestra  =snapshot.value[@"muestra"];
            GP.almacenaje  =snapshot.value[@"almacenajeFrio"];
            GP.tipoproducto = snapshot.value[@"tipoproducto"];
            
        }
    
        completion(YES,snapshot.exists, GP);
       
        
    } withCancelBlock:^(NSError * _Nonnull error) {
        [timer invalidate];
        NSLog(@"%@", error.localizedDescription);
        //[delegate GPStatusChanged:nil];
        completion(NO,NO,nil);
        
    }];

}

-(void)getNumberOfPaletsFromModel:(NSString *)model lote:(NSString *)lote completion:(void(^)(BOOL isOK,BOOL Exist, LoteModel*  newModel))completion
{
     timer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(sinInternet) userInfo:nil repeats:NO] ;
    FIRDatabaseReference * ref = [[FIRDatabase database] reference];
    [[[[ref child:@"calidad"] child:[NSString stringWithFormat:@"%@",model] ]child:[NSString stringWithFormat:@"%@",lote]] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        // Get user value
        [timer invalidate];
          if (snapshot.exists) {
        LoteModel * _lote = [[LoteModel alloc]init];
    
        _lote.fechaCaducidad = snapshot.value[@"fechaCaducidad"];
        _lote.proveedor = snapshot.value[@"noLote"];
        _lote.cantidadTotalporLote = snapshot.value[@"proveedor"];
        _lote.unidadMedida = snapshot.value[@"unidadMedida"];
        _lote.noPalet =snapshot.value[@"noPalet"];
        //_lote.noPaquetesPorPalet =snapshot.value[@"noLote"];
        //_lote.totalPalets = snapshot.value[@"noLote"];
        _lote.ubicacion =snapshot.value[@"noLote"];
        completion(YES,snapshot.exists, _lote);
          }
        
         completion(YES,snapshot.exists, nil);
        // ...
    } withCancelBlock:^(NSError * _Nonnull error) {
        [timer invalidate];
        NSLog(@"%@", error.localizedDescription);
       
        completion(NO, NO,0);
    }];
    
}

-(void)registerUser:(UserModel *)user completion:(void(^)(BOOL isOK))completion
{
    timer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(sinInternet) userInfo:nil repeats:NO] ;
    FIRDatabaseReference * ref = [[FIRDatabase database] reference];
    
    NSDictionary * dic =@{@"userName":user.userName,
                          @"userCode":user.userCode,
                          @"userEmail":user.userEmail,
                          @"userRoll":user.roll,
                          };
    [[[ref child:@"user"] child:[NSString stringWithFormat:@"%@-%@",user.userCode,user.userPassWord ]]
     setValue:dic withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
         [timer invalidate];
         if (!error) {
             completion(YES);;
         }else{
             completion(NO);;
         }
     }];
    
}

-(void)login:(NSString *)userCode pass:(NSString *)pass completion:(void(^)(BOOL isOK, BOOL userExist, UserModel *newModel))completion
{
 
    
    timer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(sinInternet) userInfo:nil repeats:NO] ;
    
    FIRDatabaseReference * ref = [[FIRDatabase database] reference];
    [[[ref child:@"user"] child:[NSString stringWithFormat:@"%@-%@",userCode,pass]] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        [timer invalidate];
        UserModel * user =[UserModel sharedManager];
        if (snapshot.exists) {
            
            
            user.userName =snapshot.value[@"userName"];
            user.userCode =snapshot.value[@"userCode"];
            user.userEmail =snapshot.value[@"userEmail"];
            user.roll =snapshot.value[@"userRoll"];
            
        }
        
        completion(YES, snapshot.exists,user);
    
    } withCancelBlock:^(NSError * _Nonnull error) {
        [timer invalidate];
        NSLog(@"%@", error.localizedDescription);
        
        completion(NO, NO,nil);
    }];
    
    
}

-(void)getRealPartNumber:(NSString *)noParte completion:(void(^)(BOOL isOK, BOOL Exist,NSString * realNoParte))completion
{
    
    
    timer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(sinInternet) userInfo:nil repeats:NO] ;
    
    FIRDatabaseReference * ref = [[FIRDatabase database] reference];
    [[[ref child:@"relacionNoParte"] child:[NSString stringWithFormat:@"%@",noParte]] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        [timer invalidate];
    
        if (snapshot.exists) {
            completion(YES, YES,snapshot.value);
        }else{
            completion(YES, snapshot.exists,nil);
        }
        
        
        
    } withCancelBlock:^(NSError * _Nonnull error) {
        [timer invalidate];
        NSLog(@"%@", error.localizedDescription);
        
        completion(NO, NO,nil);
    }];
    
    
}

-(void)saveRealNoParte:(NSString *)noParte real:(NSString *)real completion:(void(^)(BOOL isOK))completion
{
    
        timer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(sinInternet) userInfo:nil repeats:NO] ;
        FIRDatabaseReference * ref = [[FIRDatabase database] reference];
        
        NSDictionary * dic =@{noParte:real};
    [[ref child:@"relacionNoParte"]
         setValue:dic withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
             [timer invalidate];
             if (!error) {
                 completion(YES);;
             }else{
                 completion(NO);;
             }
         }];

    
    
}

#pragma mark - removeMethods

-(void )removeReception:(LoteModel *)model completion:(void(^)(BOOL isOK))completion
{
    timer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(sinInternet) userInfo:nil repeats:NO] ;
    FIRDatabaseReference * ref = [[FIRDatabase database] reference];
    [[[[ref child:@"recepcion"] child:model.noParte] child:model.noLote] removeValueWithCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
           [timer invalidate];

            completion(!error);
    }];
    
    
    [[[[ref child:@"recepcion"] child:model.noParte] child:@"cantidadGlobal"]observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        [timer invalidate];
        
        
        if (snapshot.exists) {
            NSString * value =snapshot.value;
            
            NSInteger  lastint = [self integerFromString:value] - [self integerFromString:model.cantidadTotalporLote ];
            
            NSString * result =[NSString stringWithFormat:@"%ld",(long)lastint];
            
            
            [[[[ref child:@"recepcion"] child:model.noParte] child:@"cantidadGlobal"]setValue:result withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
                
                [timer invalidate];
                if (!error) {
                    
                }else{
                    
                }
                
            }];
            
            
            
        }
        
        
    } withCancelBlock:^(NSError * _Nonnull error) {
        [timer invalidate];
        NSLog(@"%@", error.localizedDescription);
        
    }];

    
    
    
    
}


-(void)getProdctStory:(NSString *)product Completion:(void(^)(BOOL isOK, NSDictionary * newModel))completion
{
    
    timer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(sinInternet) userInfo:nil repeats:NO] ;
    
    FIRDatabaseReference * ref = [[FIRDatabase database] reference];
    [[ref child:product]  observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        [timer invalidate];
        
        if (snapshot.exists) {
            
            NSDictionary * dic = [snapshot value];
            completion(YES,dic);
        }else{
            completion(NO,nil);
        }
        
        
    } withCancelBlock:^(NSError * _Nonnull error) {
        [timer invalidate];
        NSLog(@"%@", error.localizedDescription);
        
        completion(NO,nil);
    }];
    
    
}



-(void)sinInternet
{
    [_delegate userLostConectionFireBase];
}




@end
