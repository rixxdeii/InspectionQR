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
@property (nonatomic, strong) NSString * userCode;
@property (nonatomic, strong) NSString * userEmail;
@property (nonatomic, strong) NSString * roll;
@property (nonatomic, strong) NSString * userPassWord;
@property (nonatomic, strong) UIImage * imagen;
@property BOOL hardCore;


@end
