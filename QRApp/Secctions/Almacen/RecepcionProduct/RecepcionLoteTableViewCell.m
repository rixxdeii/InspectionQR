//
//  RecepcionLoteTableViewCell.m
//  FederalMogulM
//
//  Created by Ricardo Rojas on 15/07/18.
//  Copyright © 2018 Ricardo Rojas. All rights reserved.
//

#import "RecepcionLoteTableViewCell.h"

@implementation RecepcionLoteTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)userdidTapPrintLot:(UIButton *)sender
{
    [_delegate printLotAtIndex:self.tag];
}

@end
