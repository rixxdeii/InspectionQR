//
//  FireBaseManager.h
//  Exmaples
//
//  Created by Ricardo Rojas on 24/06/18.
//  Copyright © 2018 Ricardo Rojas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SpecificProductModel.h"
#import "GenericProductModel.h"



@import Firebase;
@protocol FirebaseManagerDelegate
-(void)GPStatusChanged:(GenericProductModel *)newModel;
-(void)SPStatusChanged:(SpecificProductModel *)newModel;

@end

@interface FireBaseManager : NSObject

+(FIRDatabaseReference *)getReference;


+(void)saveGProduct:(GenericProductModel *)model;
+(void)saveSProduct:(SpecificProductModel *)model;

-(void)getGProduct:(NSString *)model completion:(void(^)(BOOL isOK, GenericProductModel *newModel))completion;
-(void)getSProduct:(NSString *)model lote:(NSString *)lote completion:(void(^)(BOOL isOK, SpecificProductModel *newModel))completion;

@end
