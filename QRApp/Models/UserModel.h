//
//  UserModel.h
//  QRApp
//
//  Created by Ricardo Rojas on 23/06/18.
//  Copyright © 2018 Ricardo Rojas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    KCalidad,
    KAlmacen,
} TypeUser;

@interface UserModel : NSObject
+(id)sharedManager;

@property (nonatomic, strong) NSString * userName;
@property (nonatomic, strong) NSString * noUser;
@property (nonatomic, strong) NSString * email;
@property (nonatomic, strong) UIImage * imagen;



@end
