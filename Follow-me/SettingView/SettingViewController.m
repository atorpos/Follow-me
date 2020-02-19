//
//  SettingViewController.m
//  Follow-me
//
//  Created by Oskar Wong on 2017/11/20.
//  Copyright © 2017 Oskar Wong. All rights reserved.
//

#import "SettingViewController.h"
#import "LoginViewController.h"
#import "WebViewController.h"

@interface SettingViewController ()

@end

@implementation SettingViewController
@synthesize tableview;

- (void)viewDidLoad {
    [super viewDidLoad];
    curwidth = [UIScreen mainScreen].bounds.size.width;
    curheigh = [UIScreen mainScreen].bounds.size.height;
    // Do any additional setup after loading the view.
    standardUser = [NSUserDefaults standardUserDefaults];
    self.navigationController.navigationBar.topItem.title = @"會員";
    [self.navigationController.navigationBar setTranslucent:YES];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.95 green:0.74 blue:0.29 alpha:0.5]];
    tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, curwidth, curheigh) style:UITableViewStyleGrouped];
    tableview.delegate = self;
    tableview.dataSource = self;
    [self.view addSubview:tableview];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidAppear:(BOOL)animated {
    NSLog(@"%@", [standardUser objectForKey:@"username"]);
    [tableview reloadData];
}
-(void)cancelallsession:(id)sender
{
    [standardUser removeObjectForKey:@"username"];
    [standardUser removeObjectForKey:@"display_name"];
    [standardUser removeObjectForKey:@"user_ID"];
    [standardUser removeObjectForKey:@"useremail"];
    [tableview reloadData];
}
-(IBAction)editviewopen:(id)sender {
    NSLog(@"open edit view");
}

#pragma mark Table view methods
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    int noofsection;
    noofsection = 2;
    return noofsection;
}
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int noofrowsection;
    switch (section) {
        case 0:
            noofrowsection = 2;
            break;
        default:
            noofrowsection = 1;
            break;
    }
    return noofrowsection;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    static NSString *ViewCellIdentifier = @"ViewCell";
    UITableViewCell *cell = nil;
    cell = [tableview dequeueReusableCellWithIdentifier:ViewCellIdentifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    switch (indexPath.section) {
        case 0:
            {
                if(![standardUser objectForKey:@"username"]) {
                    switch (indexPath.row) {
                        case 0:
                        {
                            UIButton *signinbutton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                            signinbutton.frame = CGRectMake(8, 5, curwidth-16, 30);
                            signinbutton.titleLabel.font = [UIFont systemFontOfSize:13];
                            [signinbutton setTitle:@"會員登入" forState:UIControlStateNormal];
                            [signinbutton addTarget:self action:@selector(loginview:) forControlEvents:UIControlEventTouchUpInside];
                            
                            [cell.contentView addSubview:signinbutton];
                            break;
                        }
                            
                        case 1:
                        {
                            registbutton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                            registbutton.frame = CGRectMake(8, 5, curwidth-16, 30);
                            registbutton.titleLabel.font = [UIFont systemFontOfSize:13];
                            [registbutton setTitle:@"建立會員賬戶" forState:UIControlStateNormal];
                            [registbutton addTarget:self action:@selector(webview:) forControlEvents:UIControlEventTouchUpInside];
                            
                            [cell.contentView addSubview:registbutton];
                            break;
                        }
                        default:
                            break;
                    }
                } else {
                    switch (indexPath.row) {
                        case 0:
                            {
                                logoutbutton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                                logoutbutton.frame = CGRectMake(8,5, curwidth-16, 30);
                                logoutbutton.titleLabel.font = [UIFont systemFontOfSize:13];
                                [logoutbutton setTitle:@"登出" forState:UIControlStateNormal];
                                [logoutbutton addTarget:self action:@selector(cancelallsession:) forControlEvents:UIControlEventTouchUpInside];
                                [cell.contentView addSubview:logoutbutton];
                            }
                            break;
                        case 1:
                            {
                                UIButton *editbutton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                                editbutton.frame = CGRectMake(8, 5, curwidth-16, 30);
                                editbutton.titleLabel.font = [UIFont systemFontOfSize:13];
                                [editbutton setTitle:@"編輯賬戶" forState:UIControlStateNormal];
                                [editbutton addTarget:self action:@selector(editviewopen:) forControlEvents:UIControlEventTouchUpInside];
                                
                                [cell.contentView addSubview:editbutton];
                            }
                            break;
                            
                        default:
                            break;
                    }
                    
                }
            }
            break;
            
        default:
            break;
    }
    return cell;
}
-(IBAction)loginview:(id)sender {
    NSLog(@"webmethod");
    loginview = [self.storyboard instantiateViewControllerWithIdentifier:@"loginview"];
    [self.navigationController presentViewController:loginview animated:YES completion:nil];
}
-(IBAction)webview:(id)sender {
    //mainController = (ViewController *)self.parentViewController;
    webview = [self.storyboard instantiateViewControllerWithIdentifier:@"webview"];
    webview.weblinkstring = @"https://www.follow-me.pro/weblogin.php";
    [self presentViewController:webview animated:NO completion:nil];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *sectionName;
    switch (section) {
        case 0:
            sectionName = @"賬戶";
            break;
        case 1:
            sectionName = @"你的過往交易記錄";
            break;
        default:
            break;
    }
    return sectionName;
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
