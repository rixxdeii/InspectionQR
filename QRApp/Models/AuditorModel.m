//
//  AuditorModel.m
//  QRApp
//
//  Created by Ricardo Rojas on 08/06/18.
//  Copyright © 2018 Ricardo Rojas. All rights reserved.
//

#import "AuditorModel.h"

@implementation AuditorModel

+ (id)sharedManager {
    static AuditorModel *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {
    }
    return self;
}


@end
