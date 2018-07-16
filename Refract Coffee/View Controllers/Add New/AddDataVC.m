//
//  AddDataVC.m
//  Refract Coffee
//
//  Created by Manish on 1/10/17.
//  Copyright © 2017 Admin. All rights reserved.
//

#import "AddDataVC.h"

@interface AddDataVC ()

@end

@implementation AddDataVC

#pragma mark: Code Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.ref = [[FIRDatabase database] reference];
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    [self customiseUI];
}

#pragma mark: Custom Methods
-(void) customiseUI {
    if (self.isEdit) {
        [self setNavigationTitle:@"Edit Recipe"];
        self.recipeNameTextField.text = self.coffeeDict[NAME];
        [self.recipeNameTextField setUserInteractionEnabled:false];
        [self.removeButton setHidden:false];
    }
    else {
        [self.removeButton setHidden:true];
        [self setNavigationTitle:@"Add New Recipe"];
    }
    [self setBackButton];
    self.tdsTextField.text = self.coffeeDict[TDS];
    self.doseTextField.text = self.coffeeDict[DOSE];
    self.brewWaterTextField.text = self.coffeeDict[BW];
}

#pragma mark: IBActions
- (IBAction)removeRecipeAction:(UIButton *)sender {
    if (self.isEdit) {
        _alertView.frame = self.view.bounds;
        [self.view addSubview:_alertView];
    }
}

- (IBAction)saveRecipeAction:(UIButton *)sender {
    if ([self.recipeNameTextField.text isEqualToString:@""] || (self.recipeNameTextField.text.length < 2)) {
        [self showAlert:@"Name must be of minimum 2 characters" title:@"Information"];
    }
    else {
        [self saveRecipe];
    }
}

- (IBAction)cancelButtonAction:(UIButton *)sender {
    [_alertView removeFromSuperview];
}

- (IBAction)yesButtonAction:(UIButton *)sender {
    [_alertView removeFromSuperview];
    [self removeRecipeFromFirebase];
}


#pragma mark: Firebase Methods
-(void) saveRecipe {
    NSString *userId = [self getDefaults:USERID];
    double date = [[NSDate date] timeIntervalSince1970];
    [[[[self.ref child:COFFEE] child:userId] child:self.recipeNameTextField.text] setValue:@{TDS: self.tdsTextField.text, DOSE: self.doseTextField.text, BW: self.brewWaterTextField.text, TYPE: self.coffeeDict[TYPE], DATE:[NSString stringWithFormat:@"%f",date]}];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Success" message:@"Recipe Saved succesfully" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        for (UIViewController *controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[HomeVC class]]) {
                
                [self.navigationController popToViewController:controller
                                                      animated:YES];
                break;
            }
        }
    }]];
    [self presentViewController:alert animated:true completion:nil];
}

-(void) removeRecipeFromFirebase {
    NSString *userId = [self getDefaults:USERID];
    [[[[self.ref child:COFFEE] child:userId] child:self.recipeNameTextField.text] removeValue];
    [self.navigationController popViewControllerAnimated:true];
}

@end
