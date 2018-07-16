//
//  UserRegisterVC.m
//  Refract Coffee
//
//  Created by Manish on 1/10/17.
//  Copyright © 2017 Admin. All rights reserved.
//

#import "UserRegisterVC.h"
#import "HomeVC.h"
#import "ForgotPasswordVC.h"


@interface UserRegisterVC ()
{
    NSString *imageData;
}

@end

@implementation UserRegisterVC

#pragma mark Class Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    self.ref = [[FIRDatabase database] reference];
    [self customiseUI];
}

-(void) viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.loginView.frame = CGRectMake(0, 0, self.view.frame.size.width, 280);
    [self.addView addSubview:self.loginView];
    CGRect frame = self.addView.frame;
    frame.size.height = 280;
    self.addView.frame = frame;
    imageData = [self encodeToBase64String:self.profileImageButton.imageView.image];
}

#pragma mark Custom UI
-(void) customiseUI {
    [self.navigationController setNavigationBarHidden:true];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;

    self.picker = [[UIImagePickerController alloc]init];
    self.picker.delegate = self;
}

#pragma mark IBActions
- (IBAction)loginSignupAction:(UIButton *)sender {
    
    if (sender.tag == 1) {  //Login
        [_loginButton setTitleColor:[UIColor kPinkColor] forState:UIControlStateNormal];
        [_registerButton setTitleColor:[UIColor kGrayColor] forState:UIControlStateNormal];
        [self.signupView removeFromSuperview];
        [self.loginView removeFromSuperview];
        [self.signupView setHidden:true];
        [self.loginView setHidden:false];
        self.loginView.frame = CGRectMake(0, 0, self.view.frame.size.width, 280);
        [self.addView addSubview:self.loginView];
        self.heightCostant.constant = 280;
    }
    else {  //Signup
        [_registerButton setTitleColor:[UIColor kPinkColor] forState:UIControlStateNormal];
        [_loginButton setTitleColor:[UIColor kGrayColor] forState:UIControlStateNormal];
        [self.signupView removeFromSuperview];
        [self.loginView removeFromSuperview];
        [self.loginView setHidden:true];
        [self.signupView setHidden:false];
        self.signupView.frame = CGRectMake(0, 0, self.view.frame.size.width, 500);
        [self.addView addSubview:self.signupView];
        self.heightCostant.constant = 500;
    }
}

#pragma mark Login Actions
- (IBAction)loginButtonAction:(UIButton *)sender {
    if ([self.emailTextView.text isEqualToString:@""] || ([self isValidEmail:self.emailTextView.text] == false)) {
        [self showAlert:@"Please enter valid email address" title:@"Information"];
    }
    else if ([self.emailTextView.text isEqualToString:@""]) {
        [self showAlert:@"Password enter password" title:@"Information"];
    }
    else {
        [self loginWithFirebase];
    }
}

- (IBAction)forgotPasswordButtonAction:(UIButton *)sender {
    ForgotPasswordVC *nxtObj = [self.storyboard instantiateViewControllerWithIdentifier:@"ForgotPasswordVC"];
    [self.navigationController pushViewController:nxtObj animated:true];
}

#pragma mark Signup Actions
- (IBAction)profileImageButtonAction:(UIButton *)sender {

    UIAlertController *alert = [UIAlertController  alertControllerWithTitle:@"Pick Image" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"Gallery" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.picker.allowsEditing = false;
        self.picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:self.picker animated:true completion:nil];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.picker.allowsEditing = false;
        self.picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:self.picker animated:true completion:nil];

    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDestructive handler:nil]];
    [self presentViewController:alert animated:true completion:nil];

}

- (IBAction)signupButtonAction:(UIButton *)sender {
    if ([self.signupEmailTextView.text isEqualToString:@""] || ([self isValidEmail:self.signupEmailTextView.text] == false)) {
        [self showAlert:@"Please enter valid email address" title:@"Information"];
    }
    else if ([self.signupPasswordTextView.text isEqualToString:@""] || (self.signupPasswordTextView.text.length < 4)) {
        [self showAlert:@"Password must be of minimum 4 characters" title:@"Information"];
    }
    else if (![self.signupPasswordTextView.text isEqualToString: self.signupConfirmPasswordTextView.text]) {
        [self showAlert:@"Password and Confirm Password doesnot match" title:@"Information"];
    }
    else {
        [self signupWithFirebase];
    }
}

#pragma mark UIImagePicker Delegates
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [self dismissViewControllerAnimated:true completion:nil];
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    [_profileImageButton setImage:image forState:UIControlStateNormal];
    _profileImageButton.layer.cornerRadius = 40;
    _profileImageButton.layer.masksToBounds = true;
    _profileImageButton.layer.borderColor = [UIColor kGrayColor].CGColor;
    _profileImageButton.layer.borderWidth = 2.0;
    [self.profileImageButton setContentMode:UIViewContentModeScaleAspectFit];
    imageData = [self encodeToBase64String:image];
}

- (NSString *)encodeToBase64String:(UIImage *)image {
    return [UIImageJPEGRepresentation(image, 0.5) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}

#pragma mark Firebase Methods

#pragma mark Signup Firabse
-(void) signupWithFirebase {
    [SVProgressHUD show];
    [[FIRAuth auth] createUserWithEmail:self.signupEmailTextView.text password: self.signupPasswordTextView.text completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
        if (error != nil) {
            [SVProgressHUD dismiss];
            [self showAlert:error.localizedDescription title:@"Error"];
        }
        else {
            NSString* userId = user.uid;
            [[[self.ref child:USERS] child: userId] setValue:@{PROFILEIMAGE: imageData}];
            dispatch_async(dispatch_get_main_queue(), ^(void){
                [SVProgressHUD dismiss];
                [self setDefaults:userId forKey:USERID];
                [self setDefaults:imageData forKey:PROFILEIMAGE];
                [self setDefaults:user.email forKey:EMAIL];
                HomeVC *nxtObj = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeVC"];
                [self.navigationController pushViewController:nxtObj animated:true];
            });
        }
    }];
}

-(void) loginWithFirebase {
    [SVProgressHUD show];
    [[FIRAuth auth] signInWithEmail:self.emailTextView.text password:self.passwordTextView.text completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
        if (error != nil) {
            [SVProgressHUD dismiss];
            [self showAlert:error.localizedDescription title:@"Error"];
        }
        else {
            NSString* userId = user.uid;
            [[[self.ref child:USERS] child:userId] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
                NSString *image = snapshot.value[PROFILEIMAGE];
                [self setDefaults:image forKey:PROFILEIMAGE];
                [self setDefaults:userId forKey:USERID];
                [self setDefaults:user.email forKey:EMAIL];
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    HomeVC *nxtObj = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeVC"];
                    [self.navigationController pushViewController:nxtObj animated:true];
                    [SVProgressHUD dismiss];
                });
            }];
        }
    }];
}


@end
