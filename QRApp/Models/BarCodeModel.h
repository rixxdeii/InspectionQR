//
//  BarCodeModel.h
//  QRApp
//
//  Created by Ricardo Rojas on 22/06/18.
//  Copyright © 2018 Ricardo Rojas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BarCodeModel : NSObject
@property (weak, nonatomic)  NSString *noParte;
@property (weak, nonatomic)  NSString *noLote;
@property (weak, nonatomic)  NSString *cantidad;
@property (weak, nonatomic)  NSString *proveedor;
@property (weak, nonatomic)  NSString *fecha;


@end
