//
//  AchiveViewerViewController.h
//  FederalMogulM
//
//  Created by Ricardo Rojas on 27/06/18.
//  Copyright © 2018 Ricardo Rojas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AchiveViewerViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIWebView *webview;
@property (strong,nonatomic ) NSString * url;

@end
