//
//  GraphVC.m
//  Refract Coffee
//
//  Created by Manish on 30/09/17.
//  Copyright © 2017 Admin. All rights reserved.
//

#import "GraphVC.h"
#import "AddDataVC.h"
#import <sys/utsname.h>

@interface GraphVC () {
    
    double tdsStart, tdsEnd, doseStart, doseEnd, bwStart, bwEnd, brewWater, bevWeight;
    CGFloat tdsValue, coffeValue, brewValue, dTDSc, dDOSEc, dBREWc, dTDSe, dDOSEe, dBREWe;
    
    NSArray *dataArray;
    BOOL isFilter, isFirstCoffee, isFirstEspresso, canCoffeeChanged, canEspressoChanged;
    NSArray *filterArray;
    NSString *name;
}
@end

@implementation GraphVC

#pragma mark: Class Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:DATE ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:descriptor];
    dataArray = [self.coffeeArray sortedArrayUsingDescriptors:sortDescriptors];
    isFilter = false;
    [self.recipeTextField addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    [self customiseUI];
}

-(void) viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    if (self.isEdit ==  false) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if ([self.type isEqualToString:COFFEE]) {
                if (isFirstCoffee == false) {
                    isFirstCoffee = true;
                    canCoffeeChanged = true;
                    self.tdsLabel.text = [NSString stringWithFormat:@"%.02f",dTDSc];
                    self.coffeeLabel.text = [NSString stringWithFormat:@"%.01f",dDOSEc];
                    self.brewWaterLabel.text = [NSString stringWithFormat:@"%d",(int)ceilf(dBREWc)];
                    self.tdsSlider.value = dTDSc-tdsValue;
                    self.doseSlider.value = dDOSEc-coffeValue;
                    self.bvSlider.value = dBREWc-brewValue;
                }
            }
            else {
                if (isFirstEspresso == false) {
                    isFirstEspresso = true;
                    canEspressoChanged = true;
                    self.tdsLabel.text = [NSString stringWithFormat:@"%.02f",dTDSe];
                    self.coffeeLabel.text = [NSString stringWithFormat:@"%.01f",dDOSEe];
                    self.brewWaterLabel.text = [NSString stringWithFormat:@"%d",(int)ceilf(dBREWe)];
                    self.tdsSlider.value = dTDSe-tdsValue;
                    self.doseSlider.value = dDOSEe-coffeValue;
                    self.bvSlider.value = dBREWe-brewValue;
                }
            }
        });
    }
    
    [self setGradientToSlider];

}

#pragma mark: Customise UI
-(void) customiseUI {
    dTDSc = 1.25;
    dDOSEc = 23.0;
    dBREWc = 400.0;
    
    dTDSe = 10.00;
    dDOSEe = 18.0;
    dBREWe= 34.0;
    
    [self setNavigationTitle:@"Extration Graph"];
    [self setBackButton];
    [self setAddButton];
    if (self.isEdit) {
        [self  setEditButton];
    }
    [self setupData];
    self.recipeTextField.delegate = self;
    
    self.sliderHeightConstraint.constant = 190;
    NSString *device = [self deviceName];
    if ([device isEqualToString:@"i5"]) {
        self.sliderHeightConstraint.constant = 180;
    }
    else if ([device isEqualToString:@"i6"]) {
        self.sliderHeightConstraint.constant = 190;
    }
    else if ([device isEqualToString:@"i6+"]) {
        self.sliderHeightConstraint.constant = 190;
    }
    [self.view layoutIfNeeded];
    
    self.recipeTableView.tableFooterView = [UIView new];
    
}

-(void) addButtonAction {
    AddDataVC *nxtObj = [self.storyboard instantiateViewControllerWithIdentifier:@"AddDataVC"];
    
    nxtObj.coffeeDict = [[NSMutableDictionary alloc] initWithDictionary:@{NAME: name, TDS: self.tdsLabel.text, DOSE: self.coffeeLabel.text, BW: [NSString stringWithFormat:@"%d", (int)ceilf(brewWater)], TYPE: self.type}];
    nxtObj.isEdit = self.isEdit;
    [self.navigationController pushViewController:nxtObj animated:true];
}


#pragma mark: Setup Slider and Cup
-(void) setupData {
    
    tdsValue  = -0.08;
    coffeValue = -1.70;
    brewValue = -1.96;
    NSString *device = [self deviceName];
    if ([device isEqualToString:@"i5"]) {
        tdsValue  = -0.23;
        coffeValue = -4.68;
        brewValue = -5.62;
    }
    else if ([device isEqualToString:@"i6"]) {
        tdsValue  = -0.08;
        coffeValue = -1.71;
        brewValue = -1.96;
    }
    else if ([device isEqualToString:@"i6+"]) {
        tdsValue  = -0.02;
        coffeValue = -0.25;
        brewValue = -0.29;
    }
    
    
    if ([self.type isEqualToString:COFFEE]) {
        
        [_coffeeButton setTitleColor:[UIColor kDarkColor] forState:UIControlStateNormal];
        [_espressoButton setTitleColor:[UIColor kGrayColor] forState:UIControlStateNormal];

        
        tdsStart = 0.8;
        tdsEnd = 2.0;
        doseStart = 10.0;
        doseEnd = 200;
        bwStart = 120;
        bwEnd = 2000;
        
        self.tdsLabel.text = [NSString stringWithFormat:@"%.02f",dTDSc];
        self.coffeeLabel.text = [NSString stringWithFormat:@"%.01f",dDOSEc];
        self.brewWaterLabel.text = [NSString stringWithFormat:@"%d",(int)ceilf(dBREWc)];
        self.tdsSlider.value = dTDSc-tdsValue;
        self.doseSlider.value = dDOSEc-coffeValue;
        self.bvSlider.value = dBREWc-brewValue;

        
        [UIView animateWithDuration:0.5 animations:^{
            [self.view layoutIfNeeded];
            [_cupImageView setImage:[UIImage imageNamed:@"coffeeCup"]];
        }];
    }
    else {
        
        [_coffeeButton setTitleColor:[UIColor kGrayColor] forState:UIControlStateNormal];
        [_espressoButton setTitleColor:[UIColor kDarkColor] forState:UIControlStateNormal];

        
        tdsStart = 7.5;
        tdsEnd = 13.0;
        doseStart = 10.0;
        doseEnd = 25;
        bwStart = 10;
        bwEnd = 75;
        
        self.tdsLabel.text = [NSString stringWithFormat:@"%.02f",dTDSe];
        self.coffeeLabel.text = [NSString stringWithFormat:@"%.01f",dDOSEe];
        self.brewWaterLabel.text = [NSString stringWithFormat:@"%d",(int)ceilf(dBREWe)];
        self.tdsSlider.value = dTDSe-tdsValue;
        self.doseSlider.value = dDOSEe-coffeValue;
        self.bvSlider.value = dBREWe-brewValue;
        
        [UIView animateWithDuration:0.5 animations:^{
            [self.view layoutIfNeeded];
            [_cupImageView setImage:[UIImage imageNamed:@"espressoCup"]];
        }];
    }
    
    name = @"";
    if (self.isEdit) {
        self.tdsLabel.text = self.myCoffeeDict[TDS];
        self.coffeeLabel.text = self.myCoffeeDict[DOSE];
        self.brewWaterLabel.text = self.myCoffeeDict[BW];
        brewWater = [self.brewWaterLabel.text doubleValue];
        name = self.myCoffeeDict[NAME];
        
        self.tdsSlider.value = [self.tdsLabel.text doubleValue]-tdsValue;
        self.doseSlider.value = [self.coffeeLabel.text doubleValue]-coffeValue;
        self.bvSlider.value = [self.brewWaterLabel.text doubleValue]-brewValue;
    }
    else {
        if ([self.type isEqualToString:COFFEE]) {
            brewWater = 400;
        }
        else {
            brewWater = 34;
        }

    }
    [self setExtraction];
    brewWater = [self.brewWaterLabel.text doubleValue];

    double lrRatio = [self.coffeeLabel.text doubleValue] * [self.lrrLabel.text doubleValue];
    bevWeight = brewWater - lrRatio;

}

#pragma mark: Setup Extraction
-(void) setExtraction {
    
    double lrRatio = [self.coffeeLabel.text doubleValue] * [self.lrrLabel.text doubleValue];
    bevWeight = brewWater - lrRatio;

    double extraction;
    if ([self.type isEqualToString:COFFEE]) {
        extraction = [self.tdsLabel.text doubleValue] * bevWeight / [self.coffeeLabel.text doubleValue];
    }
    else {
        extraction = [self.tdsLabel.text doubleValue] * [self.brewWaterLabel.text doubleValue] / [self.coffeeLabel.text doubleValue];
    }
    
    if isnan(extraction) {
    }
    else {
        if (extraction < 15.0) {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"15.0" forKey:@"value"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"positionChaged" object:nil userInfo:userInfo];
//            _extractionSlider.value = 15.0;
        }
        else if (extraction > 23) {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"23.0" forKey:@"value"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"positionChaged" object:nil userInfo:userInfo];

            //            _extractionSlider.value = 23.0;
        }
        else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%f",extraction] forKey:@"value"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"positionChaged" object:nil userInfo:userInfo];
//            _extractionSlider.value = extraction;
        }
//        [self.extractionSlider layoutIfNeeded];
        self.extractionLabel.text = [NSString stringWithFormat:@"%.02f",extraction];
    }
}

#pragma IBActions
- (IBAction)changeTypeButtonAction:(UIButton *)sender {
    if (sender.tag == 1) {
        self.type = COFFEE;
    }
    else {
        self.type = ESPRESSO;
        [[NSUserDefaults standardUserDefaults] setValue:BREW forKey:WATERTYPE];
        [[NSUserDefaults standardUserDefaults] synchronize];
        self.brewLabel.text = @"Brew Water (g)";
        [self.brewWaterButton setBackgroundImage:[UIImage imageNamed:@"buttonBackground"] forState:UIControlStateNormal];
        [self.brewWaterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [self.bevWeightButton setBackgroundImage:nil forState:UIControlStateNormal];
        [self.bevWeightButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        
        double lrRatio = [self.coffeeLabel.text doubleValue] * [self.lrrLabel.text doubleValue];
        brewWater = bevWeight+lrRatio;
        
        self.brewWaterLabel.text = [NSString stringWithFormat:@"%d", (int)ceilf(brewWater)];
        self.bvSlider.value = brewWater-brewValue;

    }
    [self setupData];
}

- (IBAction)addNewAction:(UIButton *)sender {
    [self removeView];
    [self addButtonAction];
}


- (IBAction)tabRecentAction:(UIButton *)sender {
    _myView = [[UIView alloc] initWithFrame:self.view.bounds];
    _myView.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeView)];
    tapGesture.delegate = self;
    _myView.gestureRecognizers = @[tapGesture];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imageView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.8];
    [_myView addSubview:imageView];

    if ([self.type isEqualToString:ESPRESSO]) {
        _settingsView.frame = CGRectMake(0, self.view.frame.size.height-250, self.view.frame.size.width, 250);
        [_myView addSubview:_settingsView];
        [self setShadow:_settingsView];
    }
    else {
        _searchView.frame = CGRectMake(0, self.view.frame.size.height-400, self.view.frame.size.width, 400);
        [_myView addSubview:_searchView];
        [self setShadow:_searchView];
    }
    [self.view addSubview:_myView];
}
- (IBAction)tabShareAction:(UIButton *)sender {
    _myView = [[UIView alloc] initWithFrame:self.view.bounds];
    _myView.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeView)];
    tapGesture.delegate = self;

    _myView.gestureRecognizers = @[tapGesture];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imageView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.8];
    [_myView addSubview:imageView];
    _shareView.frame = CGRectMake(0, self.view.frame.size.height-240, self.view.frame.size.width, 240);
    [_myView addSubview:_shareView];
    [self setShadow:_shareView];
    [self.view addSubview:_myView];
}

- (IBAction)editButtonAction:(UIButton *)sender {
    _myView = [[UIView alloc] initWithFrame:self.view.bounds];
    _myView.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeView)];
    tapGesture.delegate = self;

    _myView.gestureRecognizers = @[tapGesture];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imageView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.8];
    [_myView addSubview:imageView];
    _editView.frame = CGRectMake(0, self.view.frame.size.height-300, self.view.frame.size.width, 300);
    [_myView addSubview:_editView];
    [self setShadow:_editView];
    [self.view addSubview:_myView];
}

- (IBAction)recipeSearchAction:(UIButton *)sender {
    self.recipeTextField.text = @"";
    [self.recipeTextField becomeFirstResponder];
}

- (IBAction)shareButtonAction:(UIButton *)sender {
    if (sender.tag == 5) { // Facebook Share
        if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
            SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
            
            [controller setInitialText:[NSString stringWithFormat:@"Refract Coffee Set Extraction %@, for %@, with values TDS: %@, DOSE: %@, BREWWATER: %@", self.extractionLabel.text, self.type, self.tdsLabel.text, self.coffeeLabel.text, self.brewWaterLabel.text]];
            [self presentViewController:controller animated:YES completion:Nil];
        }
        else {
            [self showAlert:@"Please Enable Facebook from settings to share data" title:@"Information"];
        }
    }
    else if (sender.tag == 6) { //Email Share
        if([MFMailComposeViewController canSendMail]) {
            [self sendEmail];
        }
        else {
            [self showAlert:@"Please Enable Mail from settings to share data" title:@"Information"];
        }
    }
    else if (sender.tag == 7) { //Twitter Share
        if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
        {
            SLComposeViewController *tweetSheet = [SLComposeViewController
                                                   composeViewControllerForServiceType:SLServiceTypeTwitter];
            [tweetSheet setInitialText:[NSString stringWithFormat:@"Refract Coffee Set Extraction %@, for %@, with values TDS: %@, DOSE: %@, BREWWATER: %@", self.extractionLabel.text, self.type, self.tdsLabel.text, self.coffeeLabel.text, self.brewWaterLabel.text]];
            [self presentViewController:tweetSheet animated:YES completion:nil];
        }
        else {
            [self showAlert:@"Please Enable Twitter from settings to share data" title:@"Information"];
        }
    }
}


#pragma mark: Gesutre Delegates

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isDescendantOfView:self.recipeTableView] || [touch.view isDescendantOfView:self.lrrSlider] || [touch.view isDescendantOfView:self.brewWaterButton] || [touch.view isDescendantOfView:self.bevWeightButton]) {
        return NO;
    }
    return YES;
}

#pragma mark: Mail Configuration Messages
- (void)sendEmail {
    if ([MFMailComposeViewController canSendMail]) {
        NSString *emailTitle = @"Refract Coffee";
        NSString *messageBody = [NSString stringWithFormat:@"Refract Coffee Set Extraction %@, for %@, with values TDS: %@, DOSE: %@, BREWWATER: %@", self.extractionLabel.text, self.type, self.tdsLabel.text, self.coffeeLabel.text, self.brewWaterLabel.text];
        MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
        mc.mailComposeDelegate = self;
        [mc setSubject:emailTitle];
        [mc setMessageBody:messageBody isHTML:NO];
        [self presentViewController:mc animated:YES completion:NULL];
    }
    else {
        [self showAlert:@"Please Configure Mail in your iPhone" title:@"Information"];
    }
    
}

- (void)sendFeedback {
    if ([MFMailComposeViewController canSendMail]) {
        NSString *emailTitle = @"Refract Coffee";
        MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
        mc.mailComposeDelegate = self;
        [mc setSubject:emailTitle];
        [mc setToRecipients:[[NSArray alloc] initWithObjects:@"help@kaleo.design", nil]];
        [self presentViewController:mc animated:YES completion:NULL];
    }
    else {
        [self showAlert:@"Please Configure Mail in your iPhone" title:@"Information"];
    }
    
}


- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:NULL];
}

-(void) removeView {
    [_myView removeFromSuperview];
    [_shareView removeFromSuperview];
    [_editView removeFromSuperview];
    [_searchView removeFromSuperview];
    isFilter = false;
}

-(void)textChanged:(UITextField *)textField
{
        filterArray = [dataArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF['name'] contains[cd] %@", textField.text]];
        
        if ([textField.text isEqualToString:@""]) {
            filterArray = dataArray;
        }
        [self.recipeTableView reloadData];
}

- (IBAction)sliderValueChanged:(CRRulerControl *)sender {
    if (sender.tag == 10) {
        _tdsLabel.text = [NSString stringWithFormat:@"%.02f",sender.value+tdsValue];
        if ((sender.value+tdsValue) > tdsEnd ) {
            self.tdsSlider.value = tdsEnd-tdsValue;
            _tdsLabel.text = [NSString stringWithFormat:@"%.02f",tdsEnd];
            [self.tdsSlider layoutIfNeeded];
        }
        else if ((sender.value+tdsValue) < tdsStart) {
            self.tdsSlider.value = tdsStart-tdsValue;
            _tdsLabel.text = [NSString stringWithFormat:@"%.02f",tdsStart];
            [self.tdsSlider layoutIfNeeded];
        }
        
        if ([self.type isEqualToString:COFFEE]) {
            if (canCoffeeChanged) {
                dTDSc = sender.value+tdsValue;
            }
        }
        else {
            if (canEspressoChanged) {
                dTDSe = sender.value+tdsValue;
            }
        }
        
    }
    else if (sender.tag == 11) {
        _coffeeLabel.text = [NSString stringWithFormat:@"%.01f",sender.value+coffeValue];
        if ((sender.value+coffeValue) > doseEnd) {
            self.doseSlider.value = doseEnd-coffeValue;
            _coffeeLabel.text = [NSString stringWithFormat:@"%.01f",doseEnd];
            [self.doseSlider layoutIfNeeded];
        }
        else if ((sender.value+coffeValue) < doseStart) {
            self.doseSlider.value = doseStart-coffeValue;
            _coffeeLabel.text = [NSString stringWithFormat:@"%.01f",doseStart];
            [self.doseSlider layoutIfNeeded];
        }
        
        if ([self.type isEqualToString:COFFEE]) {
            if (canCoffeeChanged) {
                dDOSEc = sender.value+coffeValue;
            }
        }
        else {
            if (canEspressoChanged) {
                dDOSEe = sender.value+coffeValue;
            }
        }

    }
    else if (sender.tag == 12) {
        if ([[[NSUserDefaults standardUserDefaults] valueForKey:WATERTYPE] isEqualToString:BREW]) {
            brewWater = sender.value+brewValue;
        }
        else {
            double lrRatio = [self.coffeeLabel.text doubleValue] * [self.lrrLabel.text doubleValue];
            brewWater = sender.value+brewValue + lrRatio;
        }
        if ((sender.value+brewValue) > bwEnd ) {
            self.bvSlider.value = bwEnd-brewValue;
            if ([[[NSUserDefaults standardUserDefaults] valueForKey:WATERTYPE] isEqualToString:BREW]) {
                brewWater = bwEnd;
            }
            else {
                double lrRatio = [self.coffeeLabel.text doubleValue] * [self.lrrLabel.text doubleValue];
                brewWater = bwEnd + lrRatio;
            }
            [self.bvSlider layoutIfNeeded];
        }
        else if ((sender.value+brewValue) < bwStart) {
            self.bvSlider.value = bwStart-brewValue;
            if ([[[NSUserDefaults standardUserDefaults] valueForKey:WATERTYPE] isEqualToString:BREW]) {
                brewWater = bwStart;
            }
            else {
                double lrRatio = [self.coffeeLabel.text doubleValue] * [self.lrrLabel.text doubleValue];
                brewWater = bwStart + lrRatio;
            }
            [self.bvSlider layoutIfNeeded];
        }
        
        if ([self.type isEqualToString:COFFEE]) {
            if (canCoffeeChanged) {
                dBREWc = sender.value+brewValue;
            }
        }
        else {
            if (canEspressoChanged) {
                dBREWe = sender.value+brewValue;
            }
        }
        
        if ([[[NSUserDefaults standardUserDefaults] valueForKey:WATERTYPE] isEqualToString:BREW]) {
            self.brewWaterLabel.text = [NSString stringWithFormat:@"%d",(int)ceilf(brewWater)];
        }
        else {
            double lrRatio = [self.coffeeLabel.text doubleValue] * [self.lrrLabel.text doubleValue];
            bevWeight = brewWater - lrRatio;

            self.brewWaterLabel.text = [NSString stringWithFormat:@"%d",(int)ceilf(bevWeight)];
        }


    }
    [self setExtraction];
}

- (IBAction)feedbackButtonAction:(UIButton *)sender {
    [self sendFeedback];
}

-(NSString *) deviceName{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *string = [NSString stringWithCString:systemInfo.machine
                                          encoding:NSUTF8StringEncoding];
    NSString *device;
    if ([string isEqualToString:@"iPhone5,1"] || [string isEqualToString:@"iPhone5,2"] || [string isEqualToString:@"iPhone5,3"] || [string isEqualToString:@"iPhone5,4"] || [string isEqualToString:@"iPhone6,1"] || [string isEqualToString:@"iPhone6,2"] || [string isEqualToString:@"iPhone8,4"]) {
        device = @"i5";
    }
    else if ([string isEqualToString:@"iPhone7,2"] || [string isEqualToString:@"iPhone8,1"] || [string isEqualToString:@"iPhone9,1"] || [string isEqualToString:@"iPhone9,3"] || [string isEqualToString:@"iPhone10,1"] || [string isEqualToString:@"iPhone10,4"]) {
        device = @"i6";
    }
    else if ([string isEqualToString:@"iPhone7,1"] || [string isEqualToString:@"iPhone8,2"] || [string isEqualToString:@"iPhone9,2"] || [string isEqualToString:@"iPhone9,4"] || [string isEqualToString:@"iPhone10,2"] || [string isEqualToString:@"iPhone10,5"]) {
        device = @"i6+";
    }
    else  {
        device = @"x";
    }
    
    return device;
}

#pragma mark: Setup Extraction


#pragma mark: uitableview delegates
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (isFilter == false) {
        if (dataArray.count > 10) {
            return 10;
        }
        else {
            return dataArray.count;
        }
    }
    return filterArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CoffeeDataCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CoffeeDataCell"];
    cell.nameLabel.text = dataArray[indexPath.row][NAME];
    cell.tdsLabel.text = dataArray[indexPath.row][TDS];
    cell.doseLabel.text = dataArray[indexPath.row][DOSE];
    cell.brewWaterLabel.text = dataArray[indexPath.row][BW];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.recipeTableView) {
        self.type = dataArray[indexPath.row][TYPE];
        self.isEdit = true;
        self.myCoffeeDict = dataArray[indexPath.row];
    }
    else {
        if (isFilter == false) {
            self.type = dataArray[indexPath.row][TYPE];
            self.isEdit = true;
            self.myCoffeeDict = dataArray[indexPath.row];
        }
        else {
            self.type = filterArray[indexPath.row][TYPE];
            self.isEdit = true;
            self.myCoffeeDict = filterArray[indexPath.row];
        }
    }
    [self setEditButton];
    [self setupData];
    [self removeView];
}

#pragma mark: UITextField Delegates
-(void)textFieldDidEndEditing:(UITextField *)textField {
    isFilter = false;
    [self.recipeTableView reloadData];
    textField.text = @"Recipes";
}

-(void) textFieldDidBeginEditing:(UITextField *)textField {
    isFilter = true;
    textField.text = @"";
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}


- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"           " handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        [tableView reloadData];
        [self removeView];
        AddDataVC *nxtObj = [self.storyboard instantiateViewControllerWithIdentifier:@"AddDataVC"];
        nxtObj.isEdit = true;
        nxtObj.coffeeDict = dataArray[indexPath.row];
        [self.navigationController pushViewController:nxtObj animated:true];
    }];
    
    UITableViewCell *commentCell = (UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    CGFloat height = commentCell.frame.size.height;
    
    UIImage *backgroundImage = [self deleteImageForHeight:height];
    
    deleteAction.backgroundColor = [UIColor colorWithPatternImage:backgroundImage];
    
    return @[deleteAction];
}

- (UIImage*)deleteImageForHeight:(CGFloat)height{
    
    CGRect frame = CGRectMake(0, 0, height, height);
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(height, height), NO, [UIScreen mainScreen].scale);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
    CGContextFillRect(context, frame);
    
    UIImage *image = [UIImage imageNamed:@"editButton"];
    
    [image drawInRect: frame];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}



- (IBAction)sliderValueChangedAction:(UISlider*)sender {
    self.lrrLabel.text = [NSString stringWithFormat:@"%.01f", sender.value];
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:WATERTYPE] isEqualToString:BREW]) {
        double lrRatio = [self.coffeeLabel.text doubleValue] * [self.lrrLabel.text doubleValue];
        brewWater = bevWeight+lrRatio;
        
        self.brewWaterLabel.text = [NSString stringWithFormat:@"%d", (int)ceilf(brewWater)];
        self.bvSlider.value = brewWater-brewValue;
    }
    else {
        double lrRatio = [self.coffeeLabel.text doubleValue] * [self.lrrLabel.text doubleValue];
        bevWeight = brewWater - lrRatio;
        
        self.brewWaterLabel.text = [NSString stringWithFormat:@"%d", (int)ceilf(bevWeight)];
        self.bvSlider.value = bevWeight-brewValue;
    }
    [self setExtraction];
}

- (IBAction)changeTypeAction:(UIButton *)sender {
    if (sender.tag == 88) { //Brew Water
        [[NSUserDefaults standardUserDefaults] setValue:BREW forKey:WATERTYPE];
        [[NSUserDefaults standardUserDefaults] synchronize];
        self.brewLabel.text = @"Brew Water (g)";
        [self.brewWaterButton setBackgroundImage:[UIImage imageNamed:@"buttonBackground"] forState:UIControlStateNormal];
        [self.brewWaterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [self.bevWeightButton setBackgroundImage:nil forState:UIControlStateNormal];
        [self.bevWeightButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        
        double lrRatio = [self.coffeeLabel.text doubleValue] * [self.lrrLabel.text doubleValue];
        brewWater = bevWeight+lrRatio;
        
        self.brewWaterLabel.text = [NSString stringWithFormat:@"%d", (int)ceilf(brewWater)];
        self.bvSlider.value = brewWater-brewValue;

        
    }
    else  { //Bev Weight
        [[NSUserDefaults standardUserDefaults] setValue:BEV forKey:WATERTYPE];
        [[NSUserDefaults standardUserDefaults] synchronize];
        self.brewLabel.text = @"Bev. Weight (g)";
        [self.bevWeightButton setBackgroundImage:[UIImage imageNamed:@"buttonBackground"] forState:UIControlStateNormal];
        [self.bevWeightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [self.brewWaterButton setBackgroundImage:nil forState:UIControlStateNormal];
        [self.brewWaterButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        
        double lrRatio = [self.coffeeLabel.text doubleValue] * [self.lrrLabel.text doubleValue];
        bevWeight = brewWater - lrRatio;
        
        self.brewWaterLabel.text = [NSString stringWithFormat:@"%d", (int)ceilf(bevWeight)];
        self.bvSlider.value = bevWeight-brewValue;
    }
    
    [self setExtraction];

    
}

- (void)setGradientToSlider{
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.lrrSlider.bounds;
    gradientLayer.colors = @[ (__bridge id)[UIColor colorWithRed:(231.0/255.0) green:(225.0/255.0) blue:(184.0/255.0) alpha:1.0].CGColor,
                              (__bridge id)[UIColor colorWithRed:(245.0/255.0) green:(175.0/255.0) blue:(175.0/255.0) alpha:1.0].CGColor ];
    gradientLayer.startPoint = CGPointMake(0.0, 0.5);
    gradientLayer.endPoint = CGPointMake(1.0, 0.5);
    UIImage *trackImage = [[self imageFromLayer:gradientLayer] resizableImageWithCapInsets:UIEdgeInsetsZero];
    [self.lrrSlider setMinimumTrackImage:trackImage forState:UIControlStateNormal];
}

- (UIImage *)imageFromLayer:(CALayer *)layer
{
    UIGraphicsBeginImageContext(layer.bounds.size);
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *gradientImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return gradientImage;
}

@end
