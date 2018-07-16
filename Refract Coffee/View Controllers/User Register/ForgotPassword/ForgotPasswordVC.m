//
//  ForgotPasswordVC.m
//  Refract Coffee
//
//  Created by Manish on 1/10/17.
//  Copyright © 2017 Admin. All rights reserved.
//

#import "ForgotPasswordVC.h"

@interface ForgotPasswordVC ()

@end

@implementation ForgotPasswordVC

#pragma mark: Class Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;

}

#pragma mark: IBActions
- (IBAction)sendButtonActio:(UIButton *)sender {
    if ([self.emailTextField.text isEqualToString:@""] || ([self isValidEmail:self.emailTextField.text] == false)) {
        [self showAlert:@"Please enter valid email address" title:@"Information"];
    }
    else {
        [self forgotPassword];
    }
}

- (IBAction)backButtonAction:(UIButton *)sender {
   [self.navigationController popViewControllerAnimated:true];
}

#pragma mark: Firebase Methods
-(void) forgotPassword {
    [SVProgressHUD show];
    [[FIRAuth auth] sendPasswordResetWithEmail:self.emailTextField.text completion:^(NSError *_Nullable error) {
        if (error != nil) {
            [SVProgressHUD dismiss];
            [self showAlert:error.localizedDescription title:@"Error"];
        }
        else {
            [SVProgressHUD dismiss];
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Success" message:@"Password reset link sent to your Email-ID" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self.navigationController popViewControllerAnimated:true];
            }]];
            [self presentViewController:alert animated:true completion:nil];
        }
    }];
}
@end
