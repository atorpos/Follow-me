//
//  SuccessViewController.m
//  Follow-me
//
//  Created by Oskar Wong on 2018/01/31.
//  Copyright © 2018 Oskar Wong. All rights reserved.
//

#import "SuccessViewController.h"

@interface SuccessViewController ()

@end

@implementation SuccessViewController
@synthesize responsevalue, responsestring;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    curwidth = [UIScreen mainScreen].bounds.size.width;
    curheigh = [UIScreen mainScreen].bounds.size.height;
    NSLog(@"value = %@, string = %@", responsevalue, responsestring);
}
-(void)viewDidAppear:(BOOL)animated {
    defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"chooseitemid"];
    [defaults removeObjectForKey:@"chooseitemno"];
    [defaults removeObjectForKey:@"choseitemimg"];
    [defaults removeObjectForKey:@"choseitemtitle"];
    [defaults removeObjectForKey:@"chooseitemprice"];
    
    UIImageView *successimgview = [[UIImageView alloc] initWithFrame:CGRectMake(curwidth/2-150, curheigh/2-150, 300, 300)];
    UIImage *successimg = [UIImage imageNamed:@"success"];
    [successimgview setImage:successimg];
    
    UIButton *confirmbutton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    confirmbutton.frame = CGRectMake(5, curheigh/4*3+20, curwidth-10, 30);
    [confirmbutton setTitle:@"close" forState:UIControlStateNormal];
    confirmbutton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [confirmbutton addTarget:self action:@selector(closeveiw:) forControlEvents:UIControlEventTouchUpInside];
    [[confirmbutton layer] setCornerRadius:5.0f];
    [[confirmbutton layer] setMasksToBounds:YES];
    [[confirmbutton layer] setBorderWidth:1.0f];
    [[confirmbutton layer] setBorderColor:[UIColor lightGrayColor].CGColor];
    [self.view addSubview:successimgview];
    [self.view addSubview:confirmbutton];
    
}
-(IBAction)closeveiw:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
