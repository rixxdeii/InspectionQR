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
    
    [[[ref child:@"genericProduct"] child:model.noParte] setValue:dicTosend withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
        
        [timer invalidate];
        if (!error) {
            completion(YES);;
        }else{
            completion(NO);;
        }
    
    }];
    


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
                                 @"noPalet":model.noPalet,
                                 @"fechaCaducidad":model.fechaCaducidad,
                                 @"totalPalets":model.totalPalets,
                                 @"muestreo":model.muestreo,
                                 @"estatusLiberacion":model.estatusLiberacion,
                                 @"noPaquetesPorPalet":model.noPaquetesPorPalet,
                                 @"FechaLlegada":[dateFormatter stringFromDate:[NSDate date]]
                                 };
    FIRDatabaseReference * ref = [[FIRDatabase database] reference];
    
    [[[[ref child:@"genericProduct"] child:model.noParte] child:model.noLote]setValue:dicTosend withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
        
        [timer invalidate];
        if (!error) {
            completion(YES);;
        }else{
            completion(NO);;
        }
        
    }];

}



-(void)getGProduct:(NSString *)model completion:(void(^)(BOOL isOK,BOOL Exist, GenericProductModel *newModel))completion //valida:(blockGP)valida
{
    timer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(sinInternet) userInfo:nil repeats:NO] ;
    
    FIRDatabaseReference * ref = [[FIRDatabase database] reference];
    [[[ref child:@"genericProduct"] child:model] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
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
    [[[[ref child:@"genericProduct"] child:[NSString stringWithFormat:@"%@",model] ]child:[NSString stringWithFormat:@"%@",lote]] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        // Get user value
        [timer invalidate];
          if (snapshot.exists) {
        LoteModel * _lote = [[LoteModel alloc]init];
        
//        @property (nonatomic, strong) NSString * noParte;
//        @property (nonatomic, strong) NSString * noLote;
//        @property (nonatomic, strong) NSString * estatusLiberacion;
//        @property (nonatomic, strong) NSMutableDictionary * muestreo;
//        @property (nonatomic, strong) NSString * fechaCaducidad;
//        @property (nonatomic, strong) NSString *fechaManufactura;
//        @property (nonatomic, strong) NSString *proveedor;
//        @property (nonatomic, strong) NSString *cantidadTotalporLote;
//        @property (nonatomic, strong) NSString *unidadMedida;
//        @property (nonatomic, strong) NSString * ubicacion;
//
//        @property  NSString * noPalet;
//        @property NSString * noPaquetesPorPalet;
//        @property NSString * totalPalets;
    
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

-(void)sinInternet
{
    [_delegate userLostConectionFireBase];
}


@end
