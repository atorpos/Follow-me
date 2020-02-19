//
//  ShipAddViewController.h
//  Follow-me
//
//  Created by Oskar Wong on 2/2/18.
//  Copyright © 2018 Oskar Wong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShipAddViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource>{
    CGFloat curwidth;
    CGFloat curheigh;
    NSArray *countrydata;
    NSMutableArray *countiesname;
    NSString *notevalue;
    NSString *countryvalue;
    NSString *emailvalue;
    NSString *phonevalue;
    NSString *postalvalue;
    NSString *statesvalue;
    NSString *townvalue;
    NSString *apsuitvalue;
    NSString *stressvalue;
    NSString *companyvalue;
    NSString *lasnamevalue;
    NSString *firsnamevalue;
    NSUserDefaults *standarduser;
    double subtotal;
    NSMutableArray *additioninfos;
}

@property (strong, nonatomic) IBOutlet UITableView *tableview;
@property (retain, nonatomic) IBOutlet UITextField *inputfieldfn;
@property (retain, nonatomic) IBOutlet UITextField *inputfieldln;
@property (retain, nonatomic) IBOutlet UITextField *inputfieldcn;
@property (retain, nonatomic) IBOutlet UITextField *inputfieldsa;
@property (retain, nonatomic) IBOutlet UITextField *inputfieldaos;
@property (retain, nonatomic) IBOutlet UITextField *inputfieldc;
@property (retain, nonatomic) IBOutlet UITextField *inputfieldst;
@property (retain, nonatomic) IBOutlet UITextField *inputfieldpzc;
@property (retain, nonatomic) IBOutlet UITextField *inputfieldCountry;
@property (retain, nonatomic) IBOutlet UITextField *inputfieldphone;
@property (strong, nonatomic) IBOutlet UITextField *inputfieldemail;
@property (strong, nonatomic) IBOutlet UITextField *inputfieldnote;
@property (retain, nonatomic) IBOutlet UIPickerView *inputpicker;

@end
