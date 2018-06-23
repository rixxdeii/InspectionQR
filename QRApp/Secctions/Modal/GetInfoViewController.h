//
//  GetInfoViewController.h
//  QRApp
//
//  Created by Ricardo Rojas on 12/06/18.
//  Copyright © 2018 Ricardo Rojas. All rights reserved.
//


#import <UIKit/UIKit.h>
@protocol GetInfoDelegate
-(void)didFinishView:(NSDictionary *)data;
@end

@interface GetInfoViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *noParte;
@property (weak, nonatomic) IBOutlet UILabel *noLote;
@property (weak, nonatomic) IBOutlet UILabel *cantidad;
@property (weak, nonatomic) IBOutlet UILabel *proveedor;
@property (weak, nonatomic) IBOutlet UILabel *fecha;
@property (weak, nonatomic) IBOutlet UILabel *estatus;
@property (strong, nonatomic)  NSArray *datos;
@property (weak, nonatomic) IBOutlet UIImageView *imgageProduct;
@property (weak, nonatomic) IBOutlet UIImageView *imageStatus;
@property (weak, nonatomic) IBOutlet UIImageView *imagenBack;


@property (weak, nonatomic) id<GetInfoDelegate> delegate;


@end
