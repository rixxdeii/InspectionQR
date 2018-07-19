//
//  CustomNavigationControllerViewController.m
//  FederalMogulMovil
//
//  Created by Ricardo Rojas on 25/06/18.
//  Copyright © 2018 Ricardo Rojas. All rights reserved.
//

#import "CustomNavigationControllerViewController.h"
#import "UserModel.h"



@interface CustomNavigationControllerViewController ()
@property (strong, nonatomic) UILabel * greating;
@property (strong, nonatomic) UIImageView * userImage;
@property (strong, nonatomic) UIButton * loginButton;
@property BOOL isOpen;



@property (strong, nonatomic) UIView * loginView;


@end

@implementation CustomNavigationControllerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _isOpen =NO;
    UIImageView * LogoImage =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"itemNB.png"]];
    
    [LogoImage setFrame:CGRectMake(0, 0, 150, 100)];
    
    LogoImage.center =self.navigationBar.center;
    
    [self.navigationBar addSubview:LogoImage];
    
//    _greating = [[UILabel alloc]initWithFrame:CGRectMake(700, 10, 300, 50)];
//    _greating.text = @"Bienvenido Ricardo Rojas";
//    [self.navigationBar addSubview:_greating];;
    
    _userImage =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"default-userNB.png"]];
    
    _userImage.frame = CGRectMake(740, -0, 40, 40);
    _userImage.layer.backgroundColor=[[UIColor clearColor] CGColor];
//    _userImage.layer.cornerRadius=20;
//    _userImage.layer.borderWidth=0.5;
    //_userImage.layer.masksToBounds = YES;
    //_userImage.layer.borderColor=[[UIColor redColor] CGColor];
    [self.navigationBar addSubview:_userImage];;
    
    _loginButton =[[UIButton alloc]initWithFrame:CGRectMake(100, -10, 50, 50)];
    [_loginButton addTarget:self action:@selector(userDidPressLoginButon:) forControlEvents:UIControlEventTouchUpInside];
    
    [_loginButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.navigationBar addSubview:_loginButton];
    
    
    _loginView =[[UIView alloc ]initWithFrame:CGRectMake(0, 45, self.view.frame.size.width, 0)];
    [_loginView setBackgroundColor:[UIColor darkGrayColor]];
    
}


-(void)userDidPressLoginButon:(UIButton *)sender
{
    
    if (_isOpen){//Close
        _isOpen=NO;
        [self loginCloseView];
        
    }else{//ensta en open
        _isOpen=YES;
        CGRect frame =_loginView.frame;
        frame.size.height = 50;
        _loginView.alpha = 0.85;
        
         [self.navigationBar addSubview:_loginView];
        [UIView animateWithDuration:0.5 animations:^{
            _loginView.frame =frame;
            
        } completion:^(BOOL finished) {
        
        }];

    }  
}

-(void)loginCloseView{
    CGRect frame =_loginView.frame;
    frame.size.height = 0;
    _loginView.alpha = 0.85;
    
    [UIView animateWithDuration:0.5 animations:^{
        _loginView.frame =frame;
        
    } completion:^(BOOL finished) {
        [_loginView removeFromSuperview];
    }];
    
}

-(void)setImageView:(UIImage *)imageName
{
    [_userImage setImage:imageName];
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
