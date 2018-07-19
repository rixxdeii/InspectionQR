//
//  ItemViewController.m
//  QRApp
//
//  Created by Ricardo Rojas on 06/06/18.
//  Copyright © 2018 Ricardo Rojas. All rights reserved.
//

#import "ItemViewController.h"
#import "UserModel.h"
#import "ERProgressHud.h"
#import "CoreDataManager.h"
#import "PendientesViewController.h"
#import "FireBaseManager.h"
#import "ERProgressHud.h"
#import "ConfiguratinCalidadViewController.h"

@interface ItemViewController ()<FirebaseManagerDelegate>{
    
    BOOL isRecepcion;
}
@property (nonatomic, strong)NSArray * pendinetes;
@property (nonatomic, strong)NSDictionary * materialRecepcion;
@property (weak, nonatomic) IBOutlet UILabel *labelPenidentes;
@property (weak, nonatomic) IBOutlet UIView *backGorundView;
@property (weak, nonatomic) IBOutlet UILabel *labelRecepcion;


@end

@implementation ItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.inspectorLabel setText:[NSString stringWithFormat:@"Hola %@",[[UserModel sharedManager] userName]]];
    
    self.labelPenidentes.layer.masksToBounds = YES;
    self.labelPenidentes.layer.cornerRadius = 15;
    self.labelRecepcion.layer.masksToBounds = YES;
    self.labelRecepcion.layer.cornerRadius = 15;
    
}



-(void)viewWillAppear:(BOOL)animated
{
    
    _pendinetes = [CoreDataManager getLotesPedinetes];
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:NO];
    self.title =@"";
    NSString * pendienteText = [NSString stringWithFormat:@"%lu",(unsigned long)_pendinetes.count];
    
    self.labelPenidentes.hidden=(_pendinetes.count == 0);
    
    [self.labelPenidentes setText:pendienteText];
    
    FireBaseManager * fbm =[[FireBaseManager alloc]init];
    [[ERProgressHud sharedInstance]show];
    [fbm getLotes:nil completion:^(BOOL isOK, BOOL Exist, NSDictionary *newModel) {
        [[ERProgressHud sharedInstance]hide];
        
        if (isOK) {
            
                _materialRecepcion =newModel;
                
                NSString * recepcionCount = [NSString stringWithFormat:@"%lu",(unsigned long)_materialRecepcion.count];
                self.labelRecepcion.hidden=(_materialRecepcion.count == 0);
                [self.labelRecepcion setText:recepcionCount];
        
        }else{
            [self userLostConectionFireBase];
        }
        
    }];
    
    
    
    
}

- (UIImage *)blurredImageWithImage:(UIImage *)sourceImage{
    
    //  Create our blurred image
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [CIImage imageWithCGImage:sourceImage.CGImage];
    
    //  Setting up Gaussian Blur
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    [filter setValue:[NSNumber numberWithFloat:6.0f] forKey:@"inputRadius"];
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

#pragma mark - navigationmethods

- (IBAction)pendientesRecepcion:(id)sender
{
    isRecepcion =YES;
    if (_materialRecepcion.count < 1) {
        UIAlertView * alert =[[UIAlertView alloc]initWithTitle:@"Aviso" message:@"No tienes material en recepción." delegate:self cancelButtonTitle:@"Aceptar" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        [self performSegueWithIdentifier:@"pendienteSegue" sender:nil];
    }
    
}

- (IBAction)pendientes:(id)sender
{
    isRecepcion=NO;
    if (_pendinetes.count < 1) {
        UIAlertView * alert =[[UIAlertView alloc]initWithTitle:@"Aviso" message:@"No tiene Pendientes" delegate:self cancelButtonTitle:@"Aceptar" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        [self performSegueWithIdentifier:@"pendienteSegue" sender:_pendinetes];
    }
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(NSArray * )sender{
    if ([segue.identifier isEqualToString:@"pendienteSegue"]) {
        PendientesViewController *P = [segue destinationViewController ];
        
        P.recepcion = isRecepcion;
        if (isRecepcion)
        {
            P.pendientesRecepcion =_materialRecepcion;
        }else{
            P.pendientes =_pendinetes;
        }
    }
}
#pragma mark - firebaseMethods
- (void)userLostConectionFireBase {
    [[ERProgressHud sharedInstance] hide];
    UIAlertView * alert =[[UIAlertView alloc]initWithTitle:@"Error" message:@"No se puido conectar con servidor." delegate:self cancelButtonTitle:@"Aceptar" otherButtonTitles:nil, nil];
    
    [alert show];
    
}

- (IBAction)settings:(id)sender
{
    ConfiguratinCalidadViewController * archive = [[ConfiguratinCalidadViewController alloc]init];
    self.definesPresentationContext = YES; //self is presenting view controller
    archive.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:archive animated:YES completion:nil];
    
}

@end
