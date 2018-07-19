//
//  PusNotificationManager.m
//  FederalMogulM
//
//  Created by Ricardo Rojas on 16/07/18.
//  Copyright © 2018 Ricardo Rojas. All rights reserved.
//

#import "PusNotificationManager.h"

@implementation PusNotificationManager

- (NSString*)stringWithDeviceToken:(NSData*)deviceToken {
    const char* data = [deviceToken bytes];
    NSMutableString* token = [NSMutableString string];
    
    for (int i = 0; i < [deviceToken length]; i++) {
        [token appendFormat:@"%02.2hhX", data[i]];
    }
    
    return [token copy] ;
}

@end
