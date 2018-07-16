//
//  BaseVC.m
//  Refract Coffee
//
//  Created by Manish on 27/09/17.
//  Copyright © 2017 Admin. All rights reserved.
//

#import "BaseVC.h"

@interface BaseVC ()

@end

@implementation BaseVC

#pragma mark Class Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma  mark Navigation Methods
-(void) setNavigationTitle:(NSString *)title {
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [self.navigationController setNavigationBarHidden:false];
    [self.navigationController.navigationBar setTranslucent:false];
    [[UINavigationBar appearance] setTintColor:[UIColor kDarkColor]];
    [[UINavigationBar appearance] setBarTintColor:[UIColor kDarkColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:[UIFont fontWithName:@"Avenir" size:16]}];
    self.navigationItem.title = title;
}

-(void)setBackButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, 0, 40, 40);
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = buttonItem;
}

-(void) setAddButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"plusWhite"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(addButtonAction) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, 0, 40, 40);
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = buttonItem;
}

-(void) setEditButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"editIcon"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(addButtonAction) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, 0, 40, 40);
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = buttonItem;
}


#pragma mark Navigation Actions
-(void) backButtonAction {

    [self.navigationController popViewControllerAnimated:true];
}

-(void) addButtonAction {
    
}

#pragma mark Set Shadow
-(void) setShadow:(UIView *) view {
    view.clipsToBounds = false;
    view.layer.shadowColor = [UIColor blackColor].CGColor;
    view.layer.shadowOffset = CGSizeMake(1,0),
    view.layer.shadowOpacity = 0.8;
}

#pragma mark UIAlert Methods
-(void) showAlert: (NSString *) message title:(NSString *) title {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDefault handler: nil]];
    [self presentViewController:alert animated:true completion:nil];
}

#pragma mark User Default Values
-(void) setDefaults: (NSString *)value forKey:(NSString *) key {
    [[NSUserDefaults standardUserDefaults] setValue:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(NSString *) getDefaults: (NSString *) key {
    return [[NSUserDefaults standardUserDefaults] valueForKey:key];
}

-(void) removeDefault: (NSString *) key {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark Validations
-(BOOL) isValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}


@end
