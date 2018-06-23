//
//  InitialViewController.m
//  QRApp
//
//  Created by Ricardo Rojas on 05/06/18.
//  Copyright © 2018 Ricardo Rojas. All rights reserved.
//

#import "InitialViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "AuditorModel.h"
#import "ERProgressHud.h"

//#import "CoreDataManager.h"

@interface InitialViewController ()<FBSDKLoginButtonDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *backGroundImage;
@property (weak, nonatomic) IBOutlet UILabel *userlabel;
@property (weak, nonatomic) IBOutlet UIButton *inBuuton;


@end

@implementation InitialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.userlabel setHidden:YES];
    [self.inBuuton setHidden:YES];
    
    [[ERProgressHud sharedInstance] showWithBlurView];
    if ([FBSDKAccessToken currentAccessToken]) {
        
        [[[FBSDKGraphRequest alloc]initWithGraphPath:@"me" parameters:nil] startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
            [[ERProgressHud sharedInstance] hide];
            NSDictionary * auditor = (NSDictionary *)result;
            
            [[AuditorModel sharedManager] setNombre: [auditor objectForKey:@"name"]];
            [[AuditorModel sharedManager] setIdAuditor: [auditor objectForKey:@"id"]];
            
            NSLog(@"go to nexVC");
            
            [self.userlabel setHidden:NO];
            [self.inBuuton setHidden:NO];
            [self.userlabel setText:[auditor objectForKey:@"name"]];
            
        }];
        
    }
    [[ERProgressHud sharedInstance] hide];
    FBSDKLoginButton * lBFB = [[FBSDKLoginButton alloc]init];
    lBFB.center = self.view.center;
    lBFB.delegate = self;
    
    [self.view addSubview:lBFB];
    
    
    
    
    
    
    
    [self.navigationController setNavigationBarHidden:YES];
    [NSTimer scheduledTimerWithTimeInterval:1.0
                                     target:self
                                   selector:@selector(setBlur)
                                   userInfo:nil
                                    repeats:NO];
    
    //  [self RunCoreDataExample];
    
}


-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES];
}


- (void)loginButton:(FBSDKLoginButton *)loginButton
didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result
              error:(NSError *)error
{
    
    NSLog(@"result : %@",result);
    
    [[ERProgressHud sharedInstance] showWithBlurView];
    [[[FBSDKGraphRequest alloc]initWithGraphPath:@"me" parameters:nil] startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        [[ERProgressHud sharedInstance] hide];
        NSDictionary * auditor = (NSDictionary *)result;
        
        [[AuditorModel sharedManager] setNombre: [auditor objectForKey:@"name"]];
        [[AuditorModel sharedManager] setIdAuditor: [auditor objectForKey:@"id"]];
        
        [self.userlabel setHidden:NO];
        [self.inBuuton setHidden:NO];
        [self.userlabel setText:[auditor objectForKey:@"name"]];
        
    }];
    
    
}




- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton {
    NSLog(@"logOut");
    [self.userlabel setHidden:YES];
    [self.inBuuton setHidden:YES];
    [self.userlabel setText:@""];
    [[AuditorModel sharedManager] setNombre:@""];
    [[AuditorModel sharedManager] setIdAuditor: @""];
    
}





-(void)setBlur{
    
    [UIView animateWithDuration:5 animations:^{
        [self.backGroundImage setImage: [self blurredImageWithImage:[UIImage imageNamed:@"loginBG"]]];
    }];
    
    
}





- (UIImage *)blurredImageWithImage:(UIImage *)sourceImage{
    
    //  Create our blurred image
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [CIImage imageWithCGImage:sourceImage.CGImage];
    
    //  Setting up Gaussian Blur
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    [filter setValue:[NSNumber numberWithFloat:3.0f] forKey:@"inputRadius"];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    
    /*  CIGaussianBlur has a tendency to shrink the image a little, this ensures it matches
     *  up exactly to the bounds of our original image */
    CGImageRef cgImage = [context createCGImage:result fromRect:[inputImage extent]];
    
    UIImage *retVal = [UIImage imageWithCGImage:cgImage];
    
    if (cgImage) {
        CGImageRelease(cgImage);
    }
    
    return retVal;
}
- (IBAction)goToScanViewer:(id)sender
{
    
    
}

- (IBAction)enter:(id)sender
{
    
    [self performSegueWithIdentifier:@"itemSegue" sender:nil];
    
    
    
}

//-(void)RunCoreDataExample
//{
//    ProductModel * product = [[ProductModel alloc]init];
//    //****producto
//    //-idProduct : string
//    //-descrip : string
//    //-measures: array
//    
//    product.idProduct = @"id=123jaja";
//    product.descrip = @"descrip1";
//    product.measures = @[@"hola",@"1"];
//    
//    [CoreDataManager saveProduct:product];
//    
//    [CoreDataManager getProductModel];
//    
//    
//}


@end
