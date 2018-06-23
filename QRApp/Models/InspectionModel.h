//
//  InspectionModel.h
//  QRApp
//
//  Created by Ricardo Rojas on 09/06/18.
//  Copyright © 2018 Ricardo Rojas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AuditorModel.h"

@interface InspectionModel : NSObject

//***inspeccion
//-QRCode : imagen
//-idInspection : string
//-status: liberado, liberado por desviación, Rechazado
//-Fecha : date
//-auditor : nombre- id
//-tamañoMuestra- int

@property (nonatomic, strong) UIImage * QRCode ;
@property (nonatomic, strong) NSString * idIspection;
@property (nonatomic, strong) NSString * status;
@property (nonatomic, strong) NSDate * date;
@property (nonatomic, strong) AuditorModel * auditor;
@property (nonatomic, strong) NSString * sizeLot;
@property (nonatomic, strong) NSString * email;

@property (nonatomic,strong ) NSMutableArray * auditoriaResult;


@end
