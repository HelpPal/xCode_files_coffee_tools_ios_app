//
//  HomeVC.h
//  Refract Coffee
//
//  Created by Manish on 27/09/17.
//  Copyright © 2017 Admin. All rights reserved.
//

#import "BaseVC.h"
#import "CoffeeDataCell.h"

@interface HomeVC : BaseVC <UITableViewDelegate, UITableViewDataSource>
- (IBAction)measureCoffeeAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIView *playView;
@property (weak, nonatomic) IBOutlet UITableView *recentTableView;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *noRecentLabel;

@property (strong, nonatomic) FIRDatabaseReference *ref;
@end
