//
//  FireBaseManager.h
//  Exmaples
//
//  Created by Ricardo Rojas on 24/06/18.
//  Copyright © 2018 Ricardo Rojas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GenericProductModel.h"
#import "UserModel.h"
#import "LoteModel.h"



@import Firebase;
@protocol FirebaseManagerDelegate
-(void)userLostConectionFireBase;
@end

@interface FireBaseManager : NSObject{
       NSTimer *timer;
}

+(FIRDatabaseReference *)getReference;


-(void)saveGProduct:(GenericProductModel *)model completion:(void(^)(BOOL isOK))completion;
-(void)saveLiberation:(LoteModel *)model completion:(void(^)(BOOL isOK))completion;
-(void)registerUser:(UserModel *)user completion:(void(^)(BOOL isOK))completion;


@property (nonatomic, weak) id<FirebaseManagerDelegate> delegate;
-(void)getGProduct:(NSString *)model completion:(void(^)(BOOL isOK,BOOL Exist, GenericProductModel *newModel))completion;
-(void)getNumberOfPaletsFromModel:(NSString *)model lote:(NSString *)lote completion:(void(^)(BOOL isOK,BOOL Exist, LoteModel*  newModel))completion;
-(void)login:(NSString *)userCode pass:(NSString *)pass completion:(void(^)(BOOL isOK,BOOL userExist, UserModel *newModel))completion;

-(void)saveLote:(LoteModel *)model completion:(void(^)(BOOL isOK))completion;

-(void)getRealPartNumber:(NSString *)noParte completion:(void(^)(BOOL isOK, BOOL Exist,NSString * realNoParte))completion;
-(void)saveRealNoParte:(NSString *)noParte real:(NSString *)real completion:(void(^)(BOOL isOK))completion;

-(void)getLotes:(NSString *)model completion:(void(^)(BOOL isOK,BOOL Exist, NSDictionary *newModel))completion;

-(void )removeReception:(LoteModel *)model completion:(void(^)(BOOL isOK))completion;

-(void)getProdctStory:(NSString *)product Completion:(void(^)(BOOL isOK, NSDictionary * newModel))completion;

@end
