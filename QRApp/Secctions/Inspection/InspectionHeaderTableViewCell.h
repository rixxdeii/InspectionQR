//
//  InspectionHeaderTableViewCell.h
//  FederalMogulM
//
//  Created by Ricardo Rojas on 28/06/18.
//  Copyright © 2018 Ricardo Rojas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InspectionHeaderTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *textFielReal;
@property (weak, nonatomic) IBOutlet UILabel *labelReal;
@property (weak, nonatomic) IBOutlet UILabel *UM;
@property (weak, nonatomic) IBOutlet UILabel *Toleracias;
@property (weak, nonatomic) IBOutlet UILabel *especificacion;
@property (weak, nonatomic) IBOutlet UISwitch *sw;
@property (weak, nonatomic) IBOutlet UILabel *tipoInsturmento;

@end
