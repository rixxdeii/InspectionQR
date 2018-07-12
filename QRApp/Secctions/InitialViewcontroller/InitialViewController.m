//
//  InitialViewController.m
//  QRApp
//
//  Created by Ricardo Rojas on 05/06/18.
//  Copyright © 2018 Ricardo Rojas. All rights reserved.
//

#import "InitialViewController.h"
#import "ERProgressHud.h"
#import "Barcode.h"
#import "SettingsViewController.h"
#import "RegisterUserModalViewController.h"
#import "FireBaseManager.h"
#import "CustomNavigationControllerViewController.h"
#import "ERProgressHud.h"
#import "ConfirmViewController.h"

#import "BarCodeModel.h"
//#import "CoreDataManager.h"

@interface InitialViewController ()<FirebaseManagerDelegate,UITextFieldDelegate,UIAlertViewDelegate,registerUserDlegate>{
    BOOL isRememberme;
    BOOL existLote;
    LoteModel * loteExistente;
}
@property (weak, nonatomic) IBOutlet UIImageView *backGroundImage;
@property (weak, nonatomic) IBOutlet UILabel *userlabel;
@property (weak, nonatomic)  UIButton *inBuuton;


@property (strong, nonatomic) NSMutableArray * foundBarcodes;
@property (weak, nonatomic) IBOutlet UIView *previewView;

@property (nonatomic, strong)NSString * code;

@property (strong, nonatomic) SettingsViewController * settingsVC;

@property (weak, nonatomic) IBOutlet UISwitch *switchRememberme;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic)  NSString * noParteSave;

@end

@implementation InitialViewController{
    
    AVCaptureSession *_captureSession;
    AVCaptureDevice *_videoDevice;
    AVCaptureDeviceInput *_videoInput;
    AVCaptureVideoPreviewLayer *_previewLayer;
    BOOL _running;
    AVCaptureMetadataOutput *_metadataOutput;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _scrollView.center =self.view.center;   _scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height+100) ;
    
    self.title = @"";
    
    [self.userlabel setHidden:YES];
    [self.inBuuton setHidden:YES];
    [self setupCaptureSession];
    _previewLayer.frame = _previewView.bounds;
    [_previewView.layer addSublayer:_previewLayer];
    self.foundBarcodes = [[NSMutableArray alloc] init];
    
    // listen for going into the background and stop the session
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(applicationWillEnterForeground:)
     name:UIApplicationWillEnterForegroundNotification
     object:nil];
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(applicationDidEnterBackground:)
     name:UIApplicationDidEnterBackgroundNotification
     object:nil];
    
    // set default allowed barcode types, remove types via setings menu if you don't want them to be able to be scanned
    self.allowedBarcodeTypes = [NSMutableArray new];
    [self.allowedBarcodeTypes addObject:@"org.iso.QRCode"];
    [self.allowedBarcodeTypes addObject:@"org.iso.PDF417"];
    [self.allowedBarcodeTypes addObject:@"org.gs1.UPC-E"];
    [self.allowedBarcodeTypes addObject:@"org.iso.Aztec"];
    [self.allowedBarcodeTypes addObject:@"org.iso.Code39"];
    [self.allowedBarcodeTypes addObject:@"org.iso.Code39Mod43"];
    [self.allowedBarcodeTypes addObject:@"org.gs1.EAN-13"];
    [self.allowedBarcodeTypes addObject:@"org.gs1.EAN-8"];
    [self.allowedBarcodeTypes addObject:@"com.intermec.Code93"];
    [self.allowedBarcodeTypes addObject:@"org.iso.Code128"];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString * statusSW =[userDef objectForKey:@"swStatus"];
    
    [_switchRememberme setOn: [statusSW isEqualToString:@"YES"]];
    
    
    
    if ([_switchRememberme isOn]) {
        
        _userTxT.text = [userDef objectForKey:@"userDefcode"];
        _userPaSSTxT.text = [userDef objectForKey:@"userDefPass"];
        
        
    }
    
    [self.userTxT setDelegate:self];
    [self.userPaSSTxT setDelegate:self];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self startRunning];
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    
    
    [self stopRunning];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES];
    
}
- (IBAction)rememberme:(UISwitch *)sender {
    
    isRememberme =[sender isOn];
    
    if (!isRememberme) {
        [self.userTxT setText:@""];
        [self.userPaSSTxT setText:@""];
        NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
        
        [userDef setObject:nil forKey:@"userDefcode"];
        [userDef setObject:nil forKey:@"userDefPass"];
        
        [userDef setObject:@"NO" forKey:@"swStatus"];
        
    }
    
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
    [self stopRunning];
    
    if ([_userTxT.text isEqualToString:@""]
        ||[_userPaSSTxT.text isEqualToString:@""])
    {
        
        
        UIAlertView * alert =[[UIAlertView alloc]initWithTitle:@"Aviso" message:@"Falta llenar campos" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
        return;
    }else{
        
        [[ERProgressHud sharedInstance ] show];
        
        FireBaseManager * firebase = [[FireBaseManager alloc]init];
        firebase.delegate = self;
        [firebase login:_userTxT.text pass:_userPaSSTxT.text completion:^(BOOL isOK, BOOL userExist, UserModel *newModel)
         {
             NSString * text =nil;
             
             [[ERProgressHud sharedInstance ] hide];
             
             if (isOK) {
                 
                 if (userExist) {
                     
                     UIImage * image=[self getImageUser:newModel.userCode];
                     
                     CustomNavigationControllerViewController * cnc = (CustomNavigationControllerViewController *)self.navigationController;
                     [cnc setImageView:image];
                     
                     if (isRememberme) {
                         NSUserDefaults * userDef =[NSUserDefaults standardUserDefaults];
                         
                         [userDef setObject: _userTxT.text forKey:@"userDefcode"];
                         [userDef setObject: _userPaSSTxT.text forKey:@"userDefPass"];
                         [userDef setObject: isRememberme?@"YES":@"NO" forKey:@"swStatus"];
                         
                         
                     }
                     
                     
                     [self performSegueWithIdentifier:newModel.roll sender:nil];
                     
                     
                 }else{
                     
                     text = @"El usuario o la contraseña no existen.";
                 }
                 
                 
             }else{
                 
                 text = @"Error conexion servidor";
             }
             
             if (text)
             {
                 UIAlertView * alert =[[UIAlertView alloc]initWithTitle:@"Aviso" message:text delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                 [alert show];
                 
             }
             
             
         }];
    }
    
    
    
    
}

#pragma mark - AV capture methods

- (void)setupCaptureSession {
    // 1
    if (_captureSession) return;
    // 2
    _videoDevice = [AVCaptureDevice
                    defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (!_videoDevice) {
        NSLog(@"No video camera on this device!");
        return;
    }
    // 3
    _captureSession = [[AVCaptureSession alloc] init];
    // 4
    _videoInput = [[AVCaptureDeviceInput alloc]
                   initWithDevice:_videoDevice error:nil];
    // 5
    if ([_captureSession canAddInput:_videoInput]) {
        [_captureSession addInput:_videoInput];
    }
    // 6
    _previewLayer = [[AVCaptureVideoPreviewLayer alloc]
                     initWithSession:_captureSession];
    _previewLayer.videoGravity =
    AVLayerVideoGravityResizeAspectFill;
//        if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft ) {
//            [_previewLayer.connection setVideoOrientation:AVCaptureVideoOrientationLandscapeLeft];
//        }else{
//            [_previewLayer.connection setVideoOrientation:AVCaptureVideoOrientationLandscapeRight];
//        }
    
    
    // capture and process the metadata
    _metadataOutput = [[AVCaptureMetadataOutput alloc] init];
    dispatch_queue_t metadataQueue =
    dispatch_queue_create("com.1337labz.featurebuild.metadata", 0);
    [_metadataOutput setMetadataObjectsDelegate:self
                                          queue:metadataQueue];
    if ([_captureSession canAddOutput:_metadataOutput]) {
        [_captureSession addOutput:_metadataOutput];
    }
}

- (void)startRunning {
    if (_running) return;
    [_captureSession startRunning];
    _metadataOutput.metadataObjectTypes =
    _metadataOutput.availableMetadataObjectTypes;
    _running = YES;
}
- (void)stopRunning {
    if (!_running) return;
    [_captureSession stopRunning];
    _running = NO;
}

//  handle going foreground/background
- (void)applicationWillEnterForeground:(NSNotification*)note {
    [self startRunning];
}
- (void)applicationDidEnterBackground:(NSNotification*)note {
    [self stopRunning];
}

#pragma mark - Delegate functions

- (void)captureOutput:(AVCaptureOutput *)captureOutput
didOutputMetadataObjects:(NSArray *)metadataObjects
       fromConnection:(AVCaptureConnection *)connection
{
    [metadataObjects
     enumerateObjectsUsingBlock:^(AVMetadataObject *obj,
                                  NSUInteger idx,
                                  BOOL *stop)
     {
         if ([obj isKindOfClass:
              [AVMetadataMachineReadableCodeObject class]])
         {
             // 3
             AVMetadataMachineReadableCodeObject *code =
             (AVMetadataMachineReadableCodeObject*)
             [_previewLayer transformedMetadataObjectForMetadataObject:obj];
             // 4
             Barcode * barcode = [Barcode processMetadataObject:code];
             
             for(NSString * str in self.allowedBarcodeTypes){
                 if([barcode.getBarcodeType isEqualToString:str]){
                     [self validBarcodeFound:barcode];
                     return;
                 }
             }
         }
     }];
}

- (void) validBarcodeFound:(Barcode *)barcode{
    [self stopRunning];
    [self.foundBarcodes addObject:barcode];
    NSLog(@"codedesc. %@",[barcode getBarcodeData]);
    
    self.code = [barcode getBarcodeData];
    
    [self showBarcodeAlert:barcode];
    
    
}
- (void) showBarcodeAlert:(Barcode *)barcode{
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // [self performSegueWithIdentifier:@"inspectionSegue" sender:nil];
            
            
            NSArray * data = [self.code componentsSeparatedByString:@"-"];
            
            if (data.count != 12) {
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Aviso" message:@"Código fuera de control." delegate:self cancelButtonTitle:@"Aceptar" otherButtonTitles:nil, nil];
                [alert show];
                return ;
            }
            
            
            if ([[data firstObject]isEqualToString:@"FM"]) {//ControlFederal Mogul
                
                BarCodeModel * model = [[BarCodeModel alloc]init];
                
                model.noParte =[data objectAtIndex:1];
                model.noLote =[data objectAtIndex:2];
                model.palet =[data objectAtIndex:3];
                model.paquete =[data objectAtIndex:4];
                model.totalPalest =[data objectAtIndex:5];
                model.paquetesPorLote =[data objectAtIndex:6];
                model.cantidad =[data objectAtIndex:7];
                model.UM =[data objectAtIndex:8];
                model.proveedor =[data objectAtIndex:9];
                model.fechaRecibo =[data objectAtIndex:10];
                model.fechaCad =[data objectAtIndex:11];
                
                _noParteSave =model.noParte;
                FireBaseManager * fbm =[[FireBaseManager alloc]init];
                fbm.delegate =self;
                [[ERProgressHud sharedInstance ] show];
                
                [fbm getNumberOfPaletsFromModel: model.noParte lote:model.noLote completion:^(BOOL isOK,BOOL Exist ,LoteModel * newModel) {
                    
                    existLote = Exist;
                    if (isOK){
                        if (Exist) {
                            NSLog(@"Exist");
                            loteExistente = newModel;
                        }else{
                            NSLog(@"esxist == NO");
                        }
                        
                        [fbm getGProduct:_noParteSave completion:^(BOOL isOK, BOOL Exist, GenericProductModel *newModel)
                         {
                             [[ERProgressHud sharedInstance ] hide];
                             
                             if (isOK) {
                                 
                                 if (Exist){
                                     
                                     if (existLote) {
                                         [self performSegueWithIdentifier:@"productSegue" sender:@[model,newModel,loteExistente]];
                                     }else{
                                         [self performSegueWithIdentifier:@"productSegue" sender:@[model,newModel]];
                                     }
                                     
                                     
                                     
                                 }else{
                                     UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Aviso" message:@"Código fuera de control." delegate:self cancelButtonTitle:@"Aceptar" otherButtonTitles:nil, nil];
                                     [alert show];
                                     
                                 }
                                 
                             }else{
                                 [self userLostConectionFireBase];
                             }
                         }];
                        
                        
                    }else{
                        [self userLostConectionFireBase];
                        
                    }
                }];
            }else{
                
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Aviso" message:@"Código fuera de control." delegate:self cancelButtonTitle:@"Aceptar" otherButtonTitles:nil, nil];
                [alert show];
                
            }
            
            
        });
    });
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 0){
        //Code for Done button
        // TODO: Create a finished view
        [self startRunning];
    }
    if(buttonIndex == 1){
        //Code for Scan more button
        [self startRunning];
    }
}

- (void) settingsChanged:(NSMutableArray *)allowedTypes{
    for(NSObject * obj in allowedTypes){
        NSLog(@"%@",obj);
    }
    if(allowedTypes){
        self.allowedBarcodeTypes = [NSMutableArray arrayWithArray:allowedTypes];
    }
}
-(void)didFinishView:(NSDictionary *)data
{
    [self startRunning];
}

- (IBAction)registeruser:(id)sender
{
    RegisterUserModalViewController * GIVC = [[RegisterUserModalViewController alloc]init];
    [self stopRunning];
    GIVC.delegate =self;
    self.definesPresentationContext = YES; //self is presenting view controller
    GIVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:GIVC animated:YES completion:nil];
    
}

-(UIImage *)getImageUser:(NSString *)path
{
    NSString * imagePath = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"image_%@.jpg",path]];
    if (imagePath) {
        return  [UIImage imageWithData:[NSData dataWithContentsOfFile:imagePath]];
    }
    return [UIImage imageNamed:@"default-userNB"];
}

-(void)userLostConectionFireBase
{
    [[ERProgressHud sharedInstance]hide];
    
    UIAlertView * alert =[[UIAlertView alloc]initWithTitle:@"Error" message:@"No se pudo conctar con servidor" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    
}

- (IBAction)gesture:(id)sender {
    [_userTxT endEditing:YES];
    [_userPaSSTxT endEditing:YES];
}


//KeyBoard Manager
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    CGPoint pointInTable = [textField.superview convertPoint:textField.frame.origin toView:self.scrollView];
    CGPoint contentOffset = self.scrollView.contentOffset;
    
    contentOffset.y = (pointInTable.y -350);
    
    NSLog(@"contentOffset is: %@", NSStringFromCGPoint(contentOffset));
    [self.scrollView setContentOffset:contentOffset  animated:YES];
    return YES;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(NSArray *)sender{
    
    if ([segue.identifier isEqualToString:@"productSegue"])
    {
        ConfirmViewController * c = [segue destinationViewController];
        c.barcode = [sender firstObject];
        if (!existLote) {
            c.product = [sender lastObject];
        }else{
            c.lote = [sender lastObject];
            c.product = [sender objectAtIndex:1];
        }
        
        c.existLote =existLote;
    }
    
}
-(void)finishUserRegistration{
    [[ERProgressHud sharedInstance]hide];
    [self startRunning];
}

@end
