//
//  ForgotPasswordVC.h
//  Refract Coffee
//
//  Created by Manish on 1/10/17.
//  Copyright © 2017 Admin. All rights reserved.
//

#import "BaseVC.h"

@interface ForgotPasswordVC : BaseVC


@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
- (IBAction)sendButtonActio:(UIButton *)sender;
- (IBAction)backButtonAction:(UIButton *)sender;

@end
