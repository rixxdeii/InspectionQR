//
//  InspectionViewController.h
//  QRApp
//
//  Created by Ricardo Rojas on 09/06/18.
//  Copyright © 2018 Ricardo Rojas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LiberationPaper.h"

@interface InspectionViewController : UIViewController

@property (nonatomic,weak) IBOutlet UILabel * infolabel;
@property (weak, nonatomic) IBOutlet UITableView *inspectionTableView;
@property (weak, nonatomic) IBOutlet UITableView *LoteTableView;

@property (nonatomic, strong)LiberationPaper * liberationPaper;
@property (weak, nonatomic) IBOutlet UIButton *btnContinue;
@property (weak, nonatomic) IBOutlet UILabel *pageIndicatorTXT;

@end
