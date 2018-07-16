//
//  UserRegisterVC.h
//  Refract Coffee
//
//  Created by Manish on 1/10/17.
//  Copyright © 2017 Admin. All rights reserved.
//

#import "BaseVC.h"


@interface UserRegisterVC : BaseVC <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

//Main View
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
- (IBAction)loginSignupAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIView *addView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightCostant;

//Login View
@property (strong, nonatomic) IBOutlet UIView *loginView; // 280 Height
@property (weak, nonatomic) IBOutlet UITextField *emailTextView;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextView;
- (IBAction)loginButtonAction:(UIButton *)sender;
- (IBAction)forgotPasswordButtonAction:(UIButton *)sender;

//Signup View
@property (strong, nonatomic) IBOutlet UIView *signupView; //500 Height
@property (weak, nonatomic) IBOutlet UITextField *signupEmailTextView;
@property (weak, nonatomic) IBOutlet UITextField *signupPasswordTextView;
@property (weak, nonatomic) IBOutlet UITextField *signupConfirmPasswordTextView;
@property (weak, nonatomic) IBOutlet UIButton *profileImageButton;
- (IBAction)profileImageButtonAction:(UIButton *)sender;
- (IBAction)signupButtonAction:(UIButton *)sender;

//Variables
@property (strong, nonatomic) UIImagePickerController *picker;
@property (strong, nonatomic) FIRDatabaseReference *ref;


@end
