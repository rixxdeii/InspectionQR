//
//  QRCollectionViewCell.h
//  FederalMogulM
//
//  Created by Ricardo Rojas on 16/07/18.
//  Copyright © 2018 Ricardo Rojas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QRCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *noParte;
@property (weak, nonatomic) IBOutlet UILabel *noLote;
@property (weak, nonatomic) IBOutlet UILabel *noPalet;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewQR;
@property (weak, nonatomic) IBOutlet UILabel *noFactura;

@end
