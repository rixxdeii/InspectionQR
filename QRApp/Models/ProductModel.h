//
//  ProductModel.h
//  QRApp
//
//  Created by Ricardo Rojas on 09/06/18.
//  Copyright © 2018 Ricardo Rojas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductModel : NSObject

//****producto
//-idProduct : string
//-descrip : string
//-measures: array

@property (nonatomic , strong) NSString * idProduct;
@property (nonatomic , strong) NSString * descrip;
@property (nonatomic , strong) NSArray * measures;


@end
