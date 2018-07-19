//
//  ConfrimAlmacenViewController.h
//  FederalMogulM
//
//  Created by Ricardo Rojas on 16/07/18.
//  Copyright © 2018 Ricardo Rojas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoteModel.h"

@interface ConfrimAlmacenViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *noParte;
@property (weak, nonatomic) IBOutlet UILabel *noLote;
@property (strong, nonatomic) NSArray * data;
@property (strong, nonatomic) LoteModel * lote;

@end
