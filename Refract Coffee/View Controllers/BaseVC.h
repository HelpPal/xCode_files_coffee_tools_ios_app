//
//  BaseVC.h
//  Refract Coffee
//
//  Created by Manish on 27/09/17.
//  Copyright © 2017 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kPinkColor colorWithRed:(246/255.0) green:(176/255.0) blue:(175/255.0) alpha:1.0
#define kGrayColor colorWithRed:(190/255.0) green:(190/255.0) blue:(190/255.0) alpha:1.0
#define kDarkColor colorWithRed:(46/255.0) green:(46/255.0) blue:(46/255.0) alpha:1.0


@interface BaseVC : UIViewController

-(void) setNavigationTitle:(NSString *)title;
-(void) setBackButton;
-(void) setAddButton;
-(void) setEditButton;
-(void) addButtonAction;
-(void) backButtonAction;
-(void) setShadow:(UIView *) view;
-(void) showAlert: (NSString *) message title:(NSString *) title;
-(void) setDefaults: (NSString *)value forKey:(NSString *) key;
-(NSString *) getDefaults: (NSString *) key;
-(void) removeDefault: (NSString *) key;
-(BOOL) isValidEmail:(NSString *)checkString;
@end


