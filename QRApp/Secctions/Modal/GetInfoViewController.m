//
//  GetInfoViewController.m
//  QRApp
//
//  Created by Ricardo Rojas on 12/06/18.
//  Copyright © 2018 Ricardo Rojas. All rights reserved.
//

#import "GetInfoViewController.h"


@interface GetInfoViewController ()

@end

@implementation GetInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    // Do any additional setup after loading the view from its nib.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    [self updateifo:self.datos];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)finish:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:^{
        
        [_delegate didFinishView:nil];
        
    }];
    
}
- (IBAction)gesture:(id)sender {
    
    [self.view endEditing:YES];
}

-(void)updateifo:(NSArray *)data
{
    if ([[data firstObject] isEqualToString:@"P"]) {
        [self.noParte setText:[data objectAtIndex:1]];
        [self.cantidad setText:[NSString stringWithFormat:@"%@ %@",[data objectAtIndex:2],[data objectAtIndex:3]]];
        [self.proveedor setText:[data objectAtIndex:5]];
        [self.noLote setText:[data objectAtIndex:4]];
        [self.fecha setText:[data objectAtIndex:6]];
        [self.estatus setText:@"Aun no se encuentra en control interno."];
        [self.estatus setHidden:NO];
    }else{
        [self.noParte setText:[data objectAtIndex:1]];
        [self.noLote setText:[data objectAtIndex:2]];
        [self.estatus setText:([[data firstObject] isEqualToString:@"L"])?@"liberado":@"rechazado"];
        [self.estatus setHidden:YES];
        
        [self.imageStatus setImage:[UIImage imageNamed:self.estatus.text]];
    }
    
    [self.imagenBack setImage:[self blurredImageWithImage:[UIImage imageNamed:@""]]];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
