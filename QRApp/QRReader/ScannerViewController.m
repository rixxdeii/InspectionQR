//
//  ViewController.m
//  iOS7_BarcodeScanner
//
//  Created by Jake Widmer on 11/16/13.
//  Copyright (c) 2013 Jake Widmer. All rights reserved.
//


#import "ScannerViewController.h"
#import "SettingsViewController.h"
#import "InspectionViewController.h"
#import "Barcode.h"
#include "LMSideBarController.h"
#import "FireBaseManager.h"
#import "GetInfoViewController.h"
#import "LiberationPaper.h"
@import AVFoundation;   // iOS7 only import style

@interface ScannerViewController ()<GetInfoDelegate,FirebaseManagerDelegate>

@property (strong, nonatomic) NSMutableArray * foundBarcodes;
@property (weak, nonatomic) IBOutlet UIView *previewView;

@property (nonatomic, strong)NSString * code;

@property (strong, nonatomic) SettingsViewController * settingsVC;
@property (strong, nonatomic) InspectionViewController * insVC;

@end

@implementation ScannerViewController{
    /* Here’s a quick rundown of the instance variables (via 'iOS 7 By Tutorials'):
     
     1. _captureSession – AVCaptureSession is the core media handling class in AVFoundation. It talks to the hardware to retrieve, process, and output video. A capture session wires together inputs and outputs, and controls the format and resolution of the output frames.
     
     2. _videoDevice – AVCaptureDevice encapsulates the physical camera on a device. Modern iPhones have both front and rear cameras, while other devices may only have a single camera.
     
     3. _videoInput – To add an AVCaptureDevice to a session, wrap it in an AVCaptureDeviceInput. A capture session can have multiple inputs and multiple outputs.
     
     4. _previewLayer – AVCaptureVideoPreviewLayer provides a mechanism for displaying the current frames flowing through a capture session; it allows you to display the camera output in your UI.
     5. _running – This holds the state of the session; either the session is running or it’s not.
     6. _metadataOutput - AVCaptureMetadataOutput provides a callback to the application when metadata is detected in a video frame. AV Foundation supports two types of metadata: machine readable codes and face detection.
     7. _backgroundQueue - Used for showing alert using a separate thread.
     */
    AVCaptureSession *_captureSession;
    AVCaptureDevice *_videoDevice;
    AVCaptureDeviceInput *_videoInput;
    AVCaptureVideoPreviewLayer *_previewLayer;
    BOOL _running;
    AVCaptureMetadataOutput *_metadataOutput;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:NO];
    
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

    // Setup side bar controller


    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self startRunning];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self stopRunning];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft ) {
        [_previewLayer.connection setVideoOrientation:AVCaptureVideoOrientationLandscapeLeft];
    }else{
        [_previewLayer.connection setVideoOrientation:AVCaptureVideoOrientationLandscapeRight];
    }
    
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

#pragma mark - Button action functions
- (IBAction)settingsButtonPressed:(id)sender {
    [self performSegueWithIdentifier:@"toSettings" sender:self];
}
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    if ([[segue identifier] isEqualToString:@"toSettings"]) {
//        self.settingsVC = (SettingsViewController *)[self.storyboard instantiateViewControllerWithIdentifier: @"SettingsViewController"];
//        self.settingsVC = segue.destinationViewController;
//        self.settingsVC.delegate = self;
//    }else if ([[segue identifier] isEqualToString:@"inspectionSegue"])
//    {
//         self.insVC = (InspectionViewController *)[self.storyboard instantiateViewControllerWithIdentifier: @"InspectionViewController"];
//        self.insVC  = segue.destinationViewController;
//
//    }
//}


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
            
            
            NSArray * data = [self.code componentsSeparatedByString:@"-"];
            
            if ([[data firstObject] isEqualToString:@"P"]||[[data firstObject] isEqualToString:@"L"]||[[data firstObject] isEqualToString:@"N"]) {
                
                
                if ([[data firstObject] isEqualToString:@"P"]) {//iniciar inspeccion
                    
                    
                    
                    FireBaseManager  * fbm = [[FireBaseManager alloc]init];
                    
                    
                    
                    [fbm getGProduct:[data objectAtIndex:1] completion:^(BOOL isOK, GenericProductModel *newModel) {
                        
                        if (isOK) {//success
                            
                            
                            LiberationPaper * lpM =[[LiberationPaper alloc]init];
                            
                            lpM.noParte = newModel.noParte;
                            lpM.descript = newModel.descript;
                            lpM.nivelRevision = newModel.nivelRevision;
                            lpM.especificaciones = newModel.especificaciones;
                            lpM.muestra = newModel.muestra;
                            lpM.almacenaje =newModel.almacenaje;
                            lpM.tipoproducto = newModel.tipoproducto;
                            lpM.fechaLLegada  =[data objectAtIndex:6];
                            lpM.cantidad = [data objectAtIndex:2];
                            lpM.unidadMedida = [data objectAtIndex:3];
                            lpM.proveedor =[data objectAtIndex:5];
                            lpM.lote =[data objectAtIndex:4];
                            
                            NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
                            [dateFormatter setDateFormat:@"dd-MM-yyyy"];
                            
                            lpM.fechaInspeccion = [dateFormatter stringFromDate:[NSDate date]];
                            
                            [self performSegueWithIdentifier:@"inspectionSegue" sender:lpM];
                            
                            
                        }else{//error
                            
                            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Aviso" message:@"No se logoró recuperar informacion de Servidor." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                            [alert show];
                            
                        }
                    }];
                    
                    
                }else{
                    GetInfoViewController * GIVC = [[GetInfoViewController alloc]init];
                    GIVC.delegate =self;
                    GIVC.datos = data;
                    
                    
                    self.definesPresentationContext = YES; //self is presenting view controller
                    GIVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
                    [self presentViewController:GIVC animated:YES completion:nil];
                    
                }
                
                
                

                
                
            }else
            {
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Aviso" message:@"No esta registrado en la compania." delegate:self cancelButtonTitle:@"Aceptar" otherButtonTitles:@"", nil];
                [alert show];
                [self startRunning];
                
            }
            
            
            
            
            NSLog(@"que pàsa aqui");
            
            
        });
    });
            
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 0){
        //Code for Done button
        // TODO: Create a finished view
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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(LiberationPaper *)sender{
    if ([segue.identifier isEqualToString:@"inspectionSegue"]) {
        InspectionViewController * VC = [segue destinationViewController];
        VC.liberationPaper =sender;
        
    }
}


-(void)GPStatusChanged:(GenericProductModel *)newModel
{

}

@end


