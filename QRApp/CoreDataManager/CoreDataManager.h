//
//  CoreDataManager.h
//  QRApp
//
//  Created by Ricardo Rojas on 09/06/18.
//  Copyright © 2018 Ricardo Rojas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "InspectionModel.h"
#import "ProductModel.h"
#import "AppDelegate.h"

#import "ERProgressHud.h"

@interface CoreDataManager : NSObject

+(void)saveIspection:(InspectionModel *)inspection;
+(void)saveProduct:(ProductModel *)product;

+(NSArray *)getProductModel;
+(NSArray *)getIspectionModel;


@end
