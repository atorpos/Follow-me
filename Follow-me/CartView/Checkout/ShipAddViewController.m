//
//  ShipAddViewController.m
//  Follow-me
//
//  Created by Oskar Wong on 2/2/18.
//  Copyright © 2018 Oskar Wong. All rights reserved.
//

#import "ShipAddViewController.h"

@interface ShipAddViewController ()

@end

@implementation ShipAddViewController
@synthesize tableview, inputfieldc, inputfieldcn, inputfieldfn, inputfieldln, inputfieldsa, inputfieldst, inputfieldaos, inputfieldpzc, inputfieldnote, inputfieldemail, inputfieldphone, inputfieldCountry, inputpicker;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    curwidth = [UIScreen mainScreen].bounds.size.width;
    curheigh = [UIScreen mainScreen].bounds.size.height;
    standarduser = [NSUserDefaults standardUserDefaults];
    countrydata = [[NSArray alloc] initWithObjects:@"Australia", @"Canada",@"Hong Kong", @"Japan", @"United Kingdom", @"United States", nil];
    NSLog(@"countries array %lu", (unsigned long)[countiesname count]);
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardDidHide:)];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.title = [NSString stringWithFormat:@"Shipping Address"];
    
    tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, curwidth, curheigh) style:UITableViewStyleGrouped];
    //tableview.frame = CGRectMake(0, 0, curwidth, curheigh);
    tableview.delegate = self;
    tableview.dataSource = self;
    [self.view addSubview:tableview];
    [self.view addGestureRecognizer:tap];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidAppear:(BOOL)animated {
    [tableview reloadData];
    
}
-(void)viewDidDisappear:(BOOL)animated {
    [tableview reloadData];
    NSLog(@"testin disp");
    
}
#pragma mark Table view methods
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 12;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = [NSString stringWithFormat:@"%ld_%ld",(long)indexPath.section,(long)indexPath.row];
    
    //static NSString *ViewCellIdentifier = @"ViewCell";
    UITableViewCell *cell = nil;
    
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    switch (indexPath.row) {
        case 0:
        {
            if ([[standarduser objectForKey:@"shipname"] length] != 0) {
                firsnamevalue = [standarduser objectForKey:@"shipname"];
            }
        
            cell.textLabel.text = @"First name";
            inputfieldfn  = [[UITextField alloc] initWithFrame:CGRectMake(curwidth/2, 2, curwidth/2-5, 36)];
            inputfieldfn.font = [UIFont systemFontOfSize:13];
            inputfieldfn.textColor = [UIColor colorWithRed:0.25 green:0.97 blue:0.60 alpha:1];
            //inputfieldfn.returnKeyType = UIReturnKeyNext;
            inputfieldfn.delegate = self;
            inputfieldfn.placeholder = @"Required";
            inputfieldfn.keyboardType = UIKeyboardTypeASCIICapable;
            inputfieldfn.autocorrectionType = NO;
            inputfieldfn.spellCheckingType = NO;
            if(![firsnamevalue isEqual:NULL]) {
                inputfieldfn.text = firsnamevalue;
            }
            [cell.contentView addSubview:inputfieldfn];
        }
        break;
        case 1:
        {
            
            if ([[standarduser objectForKey:@"shiplname"] length] != 0) {
                lasnamevalue = [standarduser objectForKey:@"shiplname"];
            }
            cell.textLabel.text = @"Last name";
            inputfieldln  = [[UITextField alloc] initWithFrame:CGRectMake(curwidth/2, 2, curwidth/2-5, 36)];
            inputfieldln.font = [UIFont systemFontOfSize:13];
            inputfieldln.textColor = [UIColor colorWithRed:0.25 green:0.97 blue:0.60 alpha:1];
            inputfieldln.placeholder = @"Required";
            inputfieldln.delegate = self;
            inputfieldln.keyboardType = UIKeyboardTypeASCIICapable;
            inputfieldln.autocorrectionType = NO;
            inputfieldln.spellCheckingType = NO;
            
            if (![lasnamevalue isEqual:NULL]) {
                inputfieldln.text = lasnamevalue;
            }
            [cell.contentView addSubview:inputfieldln];
        }
            break;
        case 2:
        {

            if ([[standarduser objectForKey:@"shipcompany"] length] != 0) {
                companyvalue = [standarduser objectForKey:@"shipcompany"];
            }
            cell.textLabel.text = @"Company Name";
            inputfieldcn  = [[UITextField alloc] initWithFrame:CGRectMake(curwidth/2, 2, curwidth/2-5, 36)];
            inputfieldcn.font = [UIFont systemFontOfSize:13];
            inputfieldcn.textColor = [UIColor colorWithRed:0.25 green:0.97 blue:0.60 alpha:1];
            inputfieldcn.placeholder = @"Optional";
            inputfieldcn.delegate = self;
            inputfieldcn.keyboardType = UIKeyboardTypeASCIICapable;
            inputfieldcn.autocorrectionType = NO;
            inputfieldcn.spellCheckingType = NO;
            
            if(![companyvalue isEqual:NULL]) {
                inputfieldcn.text = companyvalue;
            }
            [cell.contentView addSubview:inputfieldcn];
        }
            break;
        case 3:
        {
            
            if ([[standarduser objectForKey:@"shipaddress"] length] != 0) {
                companyvalue = [standarduser objectForKey:@"shipaddress"];
            }
            cell.textLabel.text = @"Street Address";
            inputfieldsa  = [[UITextField alloc] initWithFrame:CGRectMake(curwidth/2, 2, curwidth/2-5, 36)];
            inputfieldsa.font = [UIFont systemFontOfSize:13];
            inputfieldsa.textColor = [UIColor colorWithRed:0.25 green:0.97 blue:0.60 alpha:1];
            inputfieldsa.placeholder = @"必須";
            inputfieldsa.delegate = self;
            inputfieldsa.keyboardType = UIKeyboardTypeASCIICapable;
            inputfieldsa.autocorrectionType = NO;
            inputfieldsa.spellCheckingType = NO;
            
            if(![stressvalue isEqual:NULL]) {
                inputfieldsa.text = stressvalue;
            }
            [cell.contentView addSubview:inputfieldsa];
        }
            break;
        case 4:
        {
            if ([[standarduser objectForKey:@"shipaptnsuit"] length] != 0) {
                apsuitvalue = [standarduser objectForKey:@"shipaptnsuit"];
            }
        
            cell.textLabel.text = @"Apt. or Suit";
            inputfieldaos  = [[UITextField alloc] initWithFrame:CGRectMake(curwidth/2, 2, curwidth/2-5, 36)];
            inputfieldaos.font = [UIFont systemFontOfSize:13];
            inputfieldaos.textColor = [UIColor colorWithRed:0.25 green:0.97 blue:0.60 alpha:1];
            inputfieldaos.placeholder = @"Optional";
            inputfieldaos.delegate = self;
            inputfieldaos.keyboardType = UIKeyboardTypeASCIICapable;
            inputfieldaos.autocorrectionType = NO;
            inputfieldaos.spellCheckingType = NO;
            
            if (![apsuitvalue isEqual:NULL]) {
                inputfieldaos.text = apsuitvalue;
            }
            [cell.contentView addSubview:inputfieldaos];
            
        }
            break;
        case 5:
        {
            
            if ([[standarduser objectForKey:@"shipcity"] length] != 0) {
                townvalue = [standarduser objectForKey:@"shipcity"];
            }
            
            cell.textLabel.text = @"Town/City";
            inputfieldc  = [[UITextField alloc] initWithFrame:CGRectMake(curwidth/2, 2, curwidth/2-5, 36)];
            inputfieldc.font = [UIFont systemFontOfSize:13];
            inputfieldc.textColor = [UIColor colorWithRed:0.25 green:0.97 blue:0.60 alpha:1];
            inputfieldc.placeholder = @"Required (ie. Ottawa)";
            inputfieldc.delegate = self;
            inputfieldc.keyboardType = UIKeyboardTypeASCIICapable;
            inputfieldc.autocorrectionType = NO;
            inputfieldc.spellCheckingType = NO;
            if(![townvalue isEqual:NULL]) {
                inputfieldc.text = townvalue;
            }
            [cell.contentView addSubview:inputfieldc];
            break;
        }
        case 6:
        {
            
            if ([[standarduser objectForKey:@"shipstates"] length] != 0) {
                statesvalue = [standarduser objectForKey:@"shipstates"];
            }
            
            cell.textLabel.text = @"State";
            inputfieldst  = [[UITextField alloc] initWithFrame:CGRectMake(curwidth/2, 2, curwidth/2-5, 36)];
            inputfieldst.font = [UIFont systemFontOfSize:13];
            inputfieldst.textColor = [UIColor colorWithRed:0.25 green:0.97 blue:0.60 alpha:1];
            inputfieldst.placeholder = @"Required (ie. ON)";
            inputfieldst.delegate = self;
            inputfieldst.keyboardType = UIKeyboardTypeASCIICapable;
            inputfieldst.autocorrectionType = NO;
            inputfieldst.spellCheckingType = NO;
            if(![statesvalue isEqual:NULL]) {
                inputfieldst.text = statesvalue;
            }
            [cell.contentView addSubview:inputfieldst];
            break;
        }
        case 7:
        {
            
            if ([[standarduser objectForKey:@"shippostal"] length] != 0) {
                postalvalue = [standarduser objectForKey:@"shippostal"];
            }
            
            cell.textLabel.text = @"Postal/Zip Code";
            inputfieldpzc  = [[UITextField alloc] initWithFrame:CGRectMake(curwidth/2, 2, curwidth/2-5, 36)];
            inputfieldpzc.font = [UIFont systemFontOfSize:13];
            inputfieldpzc.textColor = [UIColor colorWithRed:0.25 green:0.97 blue:0.60 alpha:1];
            inputfieldpzc.placeholder = @"選擇 (ie. K2A 5M4)";
            inputfieldpzc.delegate = self;
            inputfieldpzc.keyboardType = UIKeyboardTypeASCIICapable;
            inputfieldpzc.autocorrectionType = NO;
            inputfieldpzc.spellCheckingType = NO;
            if(![postalvalue isEqual:NULL]) {
                inputfieldpzc.text = postalvalue;
            }
            [cell.contentView addSubview:inputfieldpzc];
            break;
        }
        case 8:
        {
            
            if ([[standarduser objectForKey:@"shipcountry"] length] != 0) {
                countryvalue = [standarduser objectForKey:@"shipcountry"];
            }
            
            cell.textLabel.text = @"Country";
            inputfieldCountry  = [[UITextField alloc] initWithFrame:CGRectMake(curwidth/2, 2, curwidth/2-5, 36)];
            inputfieldCountry.font = [UIFont systemFontOfSize:13];
            inputfieldCountry.textColor = [UIColor colorWithRed:0.25 green:0.97 blue:0.60 alpha:1];
            inputfieldCountry.placeholder = @"Required (ie. Canada)";
            if (![countryvalue isEqual:NULL]) {
                inputfieldCountry.text = countryvalue;
            }
            inputpicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, curwidth, 150)];
            [inputpicker setDataSource:self];
            [inputpicker setDelegate:self];
            inputpicker.showsSelectionIndicator = YES;
            inputfieldCountry.inputView = inputpicker;
            [cell.contentView addSubview:inputfieldCountry];
            break;
        }
        case 9:
        {
            
            if ([[standarduser objectForKey:@"shiptel"] length] != 0) {
                phonevalue = [standarduser objectForKey:@"shiptel"];
            }
            
            cell.textLabel.text = @"Phone";
            inputfieldphone  = [[UITextField alloc] initWithFrame:CGRectMake(curwidth/2, 2, curwidth/2-5, 36)];
            inputfieldphone.font = [UIFont systemFontOfSize:13];
            inputfieldphone.textColor = [UIColor colorWithRed:0.25 green:0.97 blue:0.60 alpha:1];
            inputfieldphone.placeholder = @"Required";
            inputfieldphone.delegate = self;
            inputfieldphone.keyboardType = UIKeyboardTypePhonePad;
            inputfieldphone.autocorrectionType = NO;
            inputfieldphone.spellCheckingType = NO;
            if(![phonevalue isEqual:NULL]) {
                inputfieldphone.text = phonevalue;
            }
            [cell.contentView addSubview:inputfieldphone];
            break;
        }
        case 10:
        {
            
            if ([[standarduser objectForKey:@"shipemail"] length] != 0) {
                emailvalue = [standarduser objectForKey:@"shipemail"];
            }
            
            cell.textLabel.text = @"Email";
            inputfieldemail  = [[UITextField alloc] initWithFrame:CGRectMake(curwidth/2, 2, curwidth/2-5, 36)];
            inputfieldemail.font = [UIFont systemFontOfSize:13];
            inputfieldemail.textColor = [UIColor colorWithRed:0.25 green:0.97 blue:0.60 alpha:1];
            inputfieldemail.placeholder = @"Required";
            inputfieldemail.delegate = self;
            inputfieldemail.keyboardType = UIKeyboardTypeEmailAddress;
            inputfieldemail.autocorrectionType = NO;
            inputfieldemail.spellCheckingType = NO;
            if (![emailvalue isEqual:NULL]) {
                inputfieldemail.text = emailvalue;
            }
            [cell.contentView addSubview:inputfieldemail];
            break;
        }
        case 11:
        {
            
            if ([[standarduser objectForKey:@"shipnote"] length] != 0) {
                notevalue = [standarduser objectForKey:@"shipnote"];
            }
            
            cell.textLabel.text = @"Notes";
            inputfieldnote = [[UITextField alloc] initWithFrame:CGRectMake(curwidth/2, 2, curwidth/2-5, 36)];
            inputfieldnote.font = [UIFont systemFontOfSize:13];
            inputfieldnote.textColor = [UIColor colorWithRed:0.25 green:0.97 blue:0.60 alpha:1];
            inputfieldnote.placeholder = @"Optional";
            inputfieldnote.delegate = self;
            inputfieldnote.keyboardType = UIKeyboardTypeAlphabet;
            inputfieldnote.autocorrectionType = NO;
            inputfieldnote.spellCheckingType = NO;
            if (![notevalue isEqual:NULL]) {
                inputfieldnote.text = notevalue;
            }
            [cell.contentView addSubview:inputfieldnote];
            break;
        }
        default:
            break;
    }
    return cell;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Shipping address";
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 60;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 120;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //[self.navigationController popViewControllerAnimated:YES];
    
    [tableview deselectRowAtIndexPath:indexPath animated:YES];
}
-(void)keyboardDidShow:(NSNotification *) notif {
    NSLog(@"show keyboard");
    CGSize keyboardSize = [[[notif userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    [UITableView beginAnimations:nil context:nil];
    [UITableView setAnimationDuration:0.5];
    tableview.frame = CGRectMake(0, 0, curwidth, curheigh-keyboardSize.height);
    [UITableView commitAnimations];
}
-(void)keyboardDidHide:(NSNotification *) notif {
    [inputfieldfn resignFirstResponder];
    [inputfieldln resignFirstResponder];
    [inputfieldc resignFirstResponder];
    [inputfieldcn resignFirstResponder];
    [inputfieldsa resignFirstResponder];
    [inputfieldst resignFirstResponder];
    [inputfieldaos resignFirstResponder];
    [inputfieldpzc resignFirstResponder];
    [inputfieldnote resignFirstResponder];
    [inputfieldemail resignFirstResponder];
    [inputfieldphone resignFirstResponder];
    [inputfieldCountry resignFirstResponder];
    [UITableView beginAnimations:nil context:nil];
    [UITableView setAnimationDuration:0.5];
    tableview.frame = CGRectMake(0, 0, curwidth, curheigh);
    [UITableView commitAnimations];
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [countrydata count];
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    inputfieldCountry.text = countrydata[row];
    countryvalue = inputfieldCountry.text;
    return countrydata[row];
}
-(void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == inputfieldnote) {
        notevalue = inputfieldnote.text;
    } else if (textField == inputfieldCountry) {
        countryvalue = inputfieldCountry.text;
        NSLog(@"country %@", countryvalue);
    } else if (textField == inputfieldemail) {
        emailvalue = inputfieldemail.text;
    } else if (textField == inputfieldphone) {
        phonevalue = inputfieldphone.text;
    } else if (textField == inputfieldpzc) {
        postalvalue = inputfieldpzc.text;
    } else if (textField == inputfieldaos) {
        apsuitvalue = inputfieldaos.text;
    } else if (textField == inputfieldst) {
        statesvalue = inputfieldst.text;
    } else if (textField == inputfieldsa) {
        stressvalue = inputfieldsa.text;
    } else if (textField == inputfieldc) {
        townvalue = inputfieldc.text;
    } else if (textField == inputfieldcn) {
        companyvalue = inputfieldcn.text;
    } else if (textField == inputfieldln) {
        lasnamevalue = inputfieldln.text;
    } else if (textField == inputfieldfn) {
        firsnamevalue = inputfieldfn.text;
    }
    //[tableview reloadData];
    NSLog(@"note value %@", notevalue);
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, curwidth, 120)  ];
    UIButton *savebutton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    savebutton.frame = CGRectMake(curwidth/2-120, 20, 240, 40);
    savebutton.backgroundColor = [UIColor colorWithRed:0.41 green:0.85 blue:0.38 alpha:0.8];
    savebutton.layer.cornerRadius = 20;
    [savebutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [savebutton setTitle:@"Save" forState:UIControlStateNormal];
    [savebutton addTarget:self action:@selector(saveaddress:) forControlEvents:UIControlEventTouchUpInside];
    [[savebutton layer] setBorderWidth:1.0f];
    [[savebutton layer] setBorderColor:[UIColor whiteColor].CGColor];
    [footerview addSubview:savebutton];
    
    return footerview;
}
-(IBAction)saveaddress:(id)sender {
    
    
    if ([firsnamevalue length] == 0) {
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Information is Required"
                                      message:@"Please fill in Required information"
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        [self presentViewController:alert animated:YES completion:nil];
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
        [alert addAction:ok];
    } else if ([lasnamevalue length] == 0) {
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Information is Required"
                                      message:@"Please fill in Required information"
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        [self presentViewController:alert animated:YES completion:nil];
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
        [alert addAction:ok];
    } else if ([stressvalue length] == 0) {
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Information is Required"
                                      message:@"Please fill in Required information"
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        [self presentViewController:alert animated:YES completion:nil];
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
        [alert addAction:ok];
    } else if ([townvalue length] == 0) {
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Information is Required"
                                      message:@"Please fill in Required information"
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        [self presentViewController:alert animated:YES completion:nil];
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
        [alert addAction:ok];
    } else if ([statesvalue length] == 0) {
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Information is Required"
                                      message:@"Please fill in Required information"
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        [self presentViewController:alert animated:YES completion:nil];
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
        [alert addAction:ok];
    } else if ([countryvalue length] == 0) {
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Information is Required"
                                      message:@"Please fill in Required information"
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        [self presentViewController:alert animated:YES completion:nil];
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
        [alert addAction:ok];
    } else if ([phonevalue length] == 0) {
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Information is Required"
                                      message:@"Please fill in Required information"
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        [self presentViewController:alert animated:YES completion:nil];
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
        [alert addAction:ok];
    } else if ([emailvalue length] == 0) {
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Information is Required"
                                      message:@"Please fill in Required information"
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        [self presentViewController:alert animated:YES completion:nil];
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
        [alert addAction:ok];
    } else {
            [standarduser setObject:stressvalue forKey:@"shipaddress"];
            [standarduser setObject:townvalue forKey:@"shipcity"];
            [standarduser setObject:firsnamevalue forKey:@"shipname"];
            [standarduser setObject:lasnamevalue forKey:@"shiplname"];
            [standarduser setObject:companyvalue forKey:@"shipcompany"];
            [standarduser setObject:statesvalue forKey:@"shipstates"];
            [standarduser setObject:apsuitvalue forKey:@"shipaptnsuit"];
            [standarduser setObject:countryvalue forKey:@"shipcountry"];
            [standarduser setObject:phonevalue forKey:@"shiptel"];
            [standarduser setObject:emailvalue forKey:@"shipemail"];
            [standarduser setObject:notevalue forKey:@"shipnote"];
            [standarduser setObject:postalvalue forKey:@"shippostal"];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
