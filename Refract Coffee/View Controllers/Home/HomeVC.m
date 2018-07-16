//
//  HomeVC.m
//  Refract Coffee
//
//  Created by Manish on 27/09/17.
//  Copyright © 2017 Admin. All rights reserved.
//

#import "HomeVC.h"
#import "GraphVC.h"
#import "AddDataVC.h"


@interface HomeVC () {
    NSMutableArray *coffeeArray;
}
@end

@implementation HomeVC

#pragma mark - View Controller Delegates
- (void)viewDidLoad {
    [super viewDidLoad];
    self.ref = [[FIRDatabase database] reference];
    
    if ([[NSUserDefaults standardUserDefaults] valueForKey:WATERTYPE] == nil) {
        [[NSUserDefaults standardUserDefaults] setValue:BREW forKey:WATERTYPE];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self customiseUI];
    [self getCoffeDataFromFirebase];

}

-(void) viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [self setShadow:_playView];
}

- (void) customiseUI {
    [self setNavigationTitle:@"PROFILE"];
    [self.navigationController setNavigationBarHidden:true];
    _recentTableView.delegate = self;
    _recentTableView.dataSource = self;
    _recentTableView.tableFooterView = [[UIView alloc] init];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    if ([self getDefaults:PROFILEIMAGE] != nil) {
        UIImage *image = [self decodeBase64ToImage:[self getDefaults:PROFILEIMAGE]];
        self.profileImageView.image = image;
        self.profileImageView.clipsToBounds = true;
        self.profileImageView.layer.cornerRadius = 25.0;
        self.profileImageView.layer.borderColor = [UIColor kGrayColor].CGColor;
        self.profileImageView.layer.borderWidth = 2.0;
    }
}

#pragma mark DeCode Image
- (UIImage *)decodeBase64ToImage:(NSString *)strEncodeData {
    NSData *data = [[NSData alloc]initWithBase64EncodedString:strEncodeData options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [UIImage imageWithData:data];
}

#pragma mark - IBActions
- (IBAction)measureCoffeeAction:(UIButton *)sender {
    GraphVC *nxtObj = [self.storyboard instantiateViewControllerWithIdentifier:@"GraphVC"];
    nxtObj.type = COFFEE;
    nxtObj.coffeeArray = coffeeArray;
    nxtObj.isEdit = false;
    [self.navigationController pushViewController:nxtObj animated:true];

}

#pragma UITableView Delegates
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return coffeeArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CoffeeDataCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CoffeeDataCell"];
    cell.nameLabel.text = coffeeArray[indexPath.row][NAME];
    cell.tdsLabel.text = coffeeArray[indexPath.row][TDS];
    cell.doseLabel.text = coffeeArray[indexPath.row][DOSE];
    cell.brewWaterLabel.text = coffeeArray[indexPath.row][BW];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return true;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    GraphVC *nxtObj = [self.storyboard instantiateViewControllerWithIdentifier:@"GraphVC"];
    nxtObj.type = coffeeArray[indexPath.row][TYPE];
    nxtObj.coffeeArray = coffeeArray;
    nxtObj.isEdit = true;
    nxtObj.myCoffeeDict = coffeeArray[indexPath.row];
    [self.navigationController pushViewController:nxtObj animated:true];
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"           " handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        [tableView reloadData];
        AddDataVC *nxtObj = [self.storyboard instantiateViewControllerWithIdentifier:@"AddDataVC"];
        nxtObj.isEdit = true;
        nxtObj.coffeeDict = coffeeArray[indexPath.row];
        [self.navigationController pushViewController:nxtObj animated:true];
    }];
    UITableViewCell *commentCell = (UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    CGFloat height = commentCell.frame.size.height;
    UIImage *backgroundImage = [self deleteImageForHeight:height];
    deleteAction.backgroundColor = [UIColor colorWithPatternImage:backgroundImage];
    return @[deleteAction];
}

- (UIImage*)deleteImageForHeight:(CGFloat)height {
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


#pragma mark Firebase Methods
-(void) getCoffeDataFromFirebase {
    [SVProgressHUD show];
    coffeeArray = [[NSMutableArray alloc] init];
    NSString *userId = [self getDefaults:USERID];
    [[[self.ref child:COFFEE] child:userId] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
        NSDictionary *coffeeDict = snapshot.value;
        if (coffeeDict != (id)[NSNull null]) {
            NSArray *keyArray = coffeeDict.allKeys;
            for (NSString *key in keyArray) {
                NSString *brewWater = coffeeDict[key][BW];
                NSString *dose = coffeeDict[key][DOSE];
                NSString *tds = coffeeDict[key][TDS];
                NSString *date = coffeeDict[key][DATE];
                NSString *type = coffeeDict[key][TYPE];
                
                NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                dict[NAME] = key;
                dict[DOSE] = dose;
                dict[TDS] = tds;
                dict[BW] = brewWater;
                dict[DATE] = [NSNumber numberWithDouble:[date doubleValue]];
                dict[TYPE] = type;
                [coffeeArray addObject:dict];
            }
            dispatch_async(dispatch_get_main_queue(), ^(void){
                [SVProgressHUD dismiss];
                if (coffeeArray.count == 0) {
                    [self.noRecentLabel setHidden:false];
                }
                else {
                    [self.noRecentLabel setHidden:true];
                    [self.recentTableView reloadData];
                }
            });
        }
        else {
            [SVProgressHUD dismiss];
            [self.noRecentLabel setHidden:false];
        }
    }];
}

@end
