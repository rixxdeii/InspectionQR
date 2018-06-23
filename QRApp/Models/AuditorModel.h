//
//  AuditorModel.h
//  QRApp
//
//  Created by Ricardo Rojas on 08/06/18.
//  Copyright © 2018 Ricardo Rojas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AuditorModel : NSObject

+(id)sharedManager;

@property (nonatomic, strong) NSString * nombre;
@property (nonatomic, strong) NSString * idAuditor;


@end
