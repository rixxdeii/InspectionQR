//
//  GenericProductModel.h
//  Exmaples
//
//  Created by Ricardo Rojas on 24/06/18.
//  Copyright © 2018 Ricardo Rojas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface GenericProductModel : NSObject
@property (nonatomic, strong) NSString * noParte;
@property (nonatomic, strong) NSString * descript;

@property (nonatomic, strong) NSString * nivelRevision;

@property (nonatomic, strong) NSDictionary * especificaciones;
@property (nonatomic, strong) NSString * muestra;

@property (nonatomic, strong) NSString * almacenaje;

@property (nonatomic, strong) NSArray * urlsDocumentos;

@property (nonatomic, strong) UIImage * QRImageProduct;
@property (nonatomic, strong) NSString * tipoproducto;


@end
