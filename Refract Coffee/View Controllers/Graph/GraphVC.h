//
//  GraphVC.h
//  Refract Coffee
//
//  Created by Manish on 30/09/17.
//  Copyright © 2017 Admin. All rights reserved.
//

#import "BaseVC.h"
#import <CRRulerControl/CRRulerControl.h>
#import "CoffeeDataCell.h"
#import <Social/Social.h>
#import <MessageUI/MessageUI.h>

@interface GraphVC : BaseVC <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, MFMailComposeViewControllerDelegate, UIGestureRecognizerDelegate, MFMailComposeViewControllerDelegate>

@property (strong, nonatomic) UIView *myView;
@property (weak, nonatomic) IBOutlet UILabel *extractionLabel;
@property (weak, nonatomic) IBOutlet UIButton *coffeeButton;
@property (weak, nonatomic) IBOutlet UIButton *espressoButton;
- (IBAction)changeTypeButtonAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIImageView *cupImageView;
@property (weak, nonatomic) IBOutlet CRRulerControl *extractionSlider;
@property (weak, nonatomic) IBOutlet UILabel *tdsLabel;
@property (weak, nonatomic) IBOutlet UILabel *coffeeLabel;
@property (weak, nonatomic) IBOutlet UILabel *brewWaterLabel;
@property (weak, nonatomic) IBOutlet CRRulerControl *tdsSlider;
@property (weak, nonatomic) IBOutlet CRRulerControl *doseSlider;
@property (weak, nonatomic) IBOutlet CRRulerControl *bvSlider;
@property (strong, nonatomic) IBOutlet UIView *searchView; //Height 300
@property (strong, nonatomic) IBOutlet UIView *editView; //Height 300
@property (strong, nonatomic) IBOutlet UIView *settingsView;
@property (weak, nonatomic) IBOutlet UITableView *recipeTableView;
@property (strong, nonatomic) IBOutlet UIView *shareView;

@property (weak, nonatomic) IBOutlet UITextField *recipeTextField;

- (IBAction)recipeSearchAction:(UIButton *)sender;

- (IBAction)shareButtonAction:(UIButton *)sender;
- (IBAction)sliderValueChanged:(CRRulerControl *)sender;

- (IBAction)feedbackButtonAction:(UIButton *)sender;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sliderHeightConstraint;

@property (strong, nonatomic) NSString *type;
@property (assign, nonatomic) BOOL isEdit;
@property (strong, nonatomic) NSDictionary *myCoffeeDict;
@property (strong, nonatomic) NSMutableArray *coffeeArray;

@property (weak, nonatomic) IBOutlet UILabel *lrrLabel;
@property (weak, nonatomic) IBOutlet UISlider *lrrSlider;

@property (weak, nonatomic) IBOutlet UIButton *brewWaterButton;
@property (weak, nonatomic) IBOutlet UIButton *bevWeightButton;

@property (weak, nonatomic) IBOutlet UILabel *brewLabel;

- (IBAction)sliderValueChangedAction:(id)sender;


- (IBAction)changeTypeAction:(UIButton *)sender;



@end
