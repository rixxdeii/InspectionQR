//
//  RecepcionLoteTableViewCell.h
//  FederalMogulM
//
//  Created by Ricardo Rojas on 15/07/18.
//  Copyright © 2018 Ricardo Rojas. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol printDelegate
-(void)printLotAtIndex:(long )index;
@end
@interface RecepcionLoteTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *noParteTXT;
@property (weak, nonatomic) IBOutlet UILabel *noLoteTXT;
@property (weak, nonatomic) IBOutlet UILabel *noFacturaTXT;



@property (nonatomic, weak)id <printDelegate> delegate;





@end
