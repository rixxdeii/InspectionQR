//
//  RegisterUserModalViewController.m
//  QRApp
//
//  Created by Ricardo Rojas on 23/06/18.
//  Copyright © 2018 Ricardo Rojas. All rights reserved.
//

#import "RegisterUserModalViewController.h"
#import "FireBaseManager.h"
#import "ERProgressHud.h"

@interface RegisterUserModalViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,FirebaseManagerDelegate>{
    UIImage *imagenSaved;
    
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation RegisterUserModalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setRoundedView:self.image.imageView toDiameter:self.image.frame.size.width];
    UserModel * user =[UserModel sharedManager] ;
    user.roll =@"calidad";
}

- (IBAction)cancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil] ;
}

- (IBAction)didUserRegisterUser:(id)sender {
    
    
    if ([_nombre.text isEqualToString:@""]
        ||[_IDEmpleado.text isEqualToString:@""]
        ||[_contrasenaa.text isEqualToString:@""]
        ||[_email.text isEqualToString:@""]
        ) {
        
        UIAlertView * alert =[[UIAlertView alloc]initWithTitle:@"Aviso" message:@"Faltan campos por llenar" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return;
        
    }else{
        
        
        UserModel * user =[UserModel sharedManager];
        user.userName = _nombre.text;
        user.userCode =_IDEmpleado.text;
        user.userPassWord = _contrasenaa.text;
        user.userEmail = _email.text;
        
        [self savePicture:imagenSaved];
        [[ERProgressHud sharedInstance]show];
        FireBaseManager * fbm = [[FireBaseManager alloc]init];
        fbm.delegate=self;
        
        [fbm registerUser:user completion:^(BOOL isOK) {
            
            if (isOK) {
                
                [self dismissViewControllerAnimated:YES completion:^{
                    [_delegate finishUserRegistration];
                }] ;
            }else{
                UIAlertView * alert =[[UIAlertView alloc]initWithTitle:@"Error" message:@"No se pudo conectar con el servidor " delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }
            
        }];
        
        
        
    }
    
    
}

-(void)setRoundedView:(UIImageView *)roundedView toDiameter:(float)newSize;
{
    CGPoint saveCenter = roundedView.center;
    CGRect newFrame = CGRectMake(roundedView.frame.origin.x, roundedView.frame.origin.y, newSize, newSize);
    roundedView.frame = newFrame;
    roundedView.layer.cornerRadius = newSize / 2.0;
    roundedView.center = saveCenter;
    
}
- (IBAction)selectTypeUser:(UISegmentedControl *)sender {
    
    UserModel * user =[UserModel sharedManager] ;
    
    if (sender.selectedSegmentIndex ==0) {
        user.roll =@"calidad";
    }else{
        user.roll =@"almacen";
    }
    
    
    
}

- (IBAction)takePicture:(id)sender {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:@"Device has no camera"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        
        [myAlertView show];
        
    } else {
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self presentViewController:picker animated:YES completion:NULL];
        
    }
}



- (IBAction)selectPhoto:(UIButton *)sender {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
    
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    
    
    [picker dismissViewControllerAnimated:YES completion:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.image setImage:chosenImage forState:UIControlStateNormal];
            imagenSaved = chosenImage ;
        });
        
    }];
    
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

#pragma mark TextFiel delegates




- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}


-(void)savePicture:(UIImage *)image{
    NSData *imageData = UIImageJPEGRepresentation(image, 1);
    
    // Get image path in user's folder and store file with name image_CurrentTimestamp.jpg (see documentsPathForFileName below)
    NSString *imagePath = [self documentsPathForFileName:[NSString stringWithFormat:@"image_%@.jpg",_IDEmpleado.text ]];
    
    // Write image data to user's folder
    [imageData writeToFile:imagePath atomically:YES];
    
    // Store path in NSUserDefaults
    [[NSUserDefaults standardUserDefaults] setObject:imagePath forKey:[NSString stringWithFormat:@"image_%@.jpg",_IDEmpleado.text ]];
    
    // Sync user defaults
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)documentsPathForFileName:(NSString *)name {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    
    return [documentsPath stringByAppendingPathComponent:name];
}

//KeyBoard Manager
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    CGPoint pointInTable = [textField.superview convertPoint:textField.frame.origin toView:self.scrollView];
    CGPoint contentOffset = self.scrollView.contentOffset;
    
    contentOffset.y = (pointInTable.y -200 );
    
    NSLog(@"contentOffset is: %@", NSStringFromCGPoint(contentOffset));
    [self.scrollView setContentOffset:contentOffset  animated:YES];
    return YES;
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    
    [self.scrollView setContentOffset:CGPointZero  animated:YES];
    
    
    return YES;
}
- (IBAction)gestureR:(id)sender {
    [self.view endEditing:YES];
}

-(void)userLostConectionFireBase{
    [[ERProgressHud sharedInstance]hide];
    
    UIAlertView * alert =[[UIAlertView alloc]initWithTitle:@"Error" message:@"No se pudo conctar con servidor" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    
    
}

@end
