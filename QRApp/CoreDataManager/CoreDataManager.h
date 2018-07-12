//
//  CoreDataManager.h
//  QRApp
//
//  Created by Ricardo Rojas on 09/06/18.
//  Copyright © 2018 Ricardo Rojas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "ERProgressHud.h"
#import "LoteModel.h"

@interface CoreDataManager : NSObject

+(void)loteStatusPendiente:(LoteModel *)lote;
//+(void)saveProduct:(ProductModel *)product;

+(NSArray *)getLotesPedinetes;

+(void)deleteLote:(int)indexselected;


@end
