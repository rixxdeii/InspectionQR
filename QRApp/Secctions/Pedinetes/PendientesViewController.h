//
//  PendientesViewController.h
//  FederalMogulM
//
//  Created by Ricardo Rojas on 06/07/18.
//  Copyright © 2018 Ricardo Rojas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoteModel.h"

@interface PendientesViewController : UIViewController
@property (nonatomic,strong) NSArray * pendientes;
@property (nonatomic,strong) NSDictionary * pendientesRecepcion;
@property BOOL recepcion;

@end
