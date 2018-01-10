//
//  SecondViewController.m
//  Follow-me
//
//  Created by Oskar Wong on 11/15/17.
//  Copyright © 2017 Oskar Wong. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    curwidth = [UIScreen mainScreen].bounds.size.width;
    curheigh = [UIScreen mainScreen].bounds.size.height;
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationController.navigationBar.topItem.title = @"商店";
    [self.navigationController.navigationBar setTranslucent:YES];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.49 green:0.67 blue:0.91 alpha:0.6]];
    [self createui];
}
-(void)createui {
    mainview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, curwidth, curheigh)];
    mainview.backgroundColor = [UIColor whiteColor];
    mainview.showsVerticalScrollIndicator = YES;
    mainview.scrollEnabled = YES;
    mainview.userInteractionEnabled = YES;
    mainview.contentSize = CGSizeMake(curwidth, 2*curwidth+curwidth/2);
    mainview.showsVerticalScrollIndicator = NO;
    
    [self contentview];
    [self.view addSubview:mainview];
}
-(void)contentview {
    topview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, curwidth, curwidth/2)];
    topview.backgroundColor = [UIColor lightGrayColor];
    
    UIImageView *topimgview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, topview.frame.size.width, topview.frame.size.height)];
    UIImage *topimg = [UIImage imageNamed:@"shophead.jpg"];
    topimgview.contentMode = UIViewContentModeScaleAspectFill;
    [topimgview setImage:topimg];
    
    [topview addSubview:topimgview];
    
    UIButton *firstbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    firstbutton.frame = CGRectMake(0, curwidth/2, curwidth/2, curwidth/2);
    [firstbutton setTitle:[NSString stringWithFormat:@"電腦"] forState:UIControlStateNormal];
    firstbutton.layer.borderColor = [UIColor blackColor].CGColor;
    firstbutton.layer.borderWidth = 0.5f;
    
    UIButton *secondbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    secondbutton.frame = CGRectMake(curwidth/2, curwidth/2, curwidth/2, curwidth/2);
    [secondbutton setTitle:[NSString stringWithFormat:@"電腦"] forState:UIControlStateNormal];
    secondbutton.layer.borderColor = [UIColor blackColor].CGColor;
    secondbutton.layer.borderWidth = 0.5f;
    
    UIButton *thirdbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    thirdbutton.frame = CGRectMake(0, curwidth, curwidth/2, curwidth/2);
    [thirdbutton setTitle:[NSString stringWithFormat:@"電腦"] forState:UIControlStateNormal];
    thirdbutton.layer.borderColor = [UIColor blackColor].CGColor;
    thirdbutton.layer.borderWidth = 0.5f;
    
    UIButton *forthbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    forthbutton.frame = CGRectMake(curwidth/2, curwidth, curwidth/2, curwidth/2);
    [forthbutton setTitle:[NSString stringWithFormat:@"電腦"] forState:UIControlStateNormal];
    forthbutton.layer.borderColor = [UIColor blackColor].CGColor;
    forthbutton.layer.borderWidth = 0.5f;
    
    UIButton *fifthbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    fifthbutton.frame = CGRectMake(0, 3*curwidth/2, curwidth/2, curwidth/2);
    [fifthbutton setTitle:[NSString stringWithFormat:@"電腦"] forState:UIControlStateNormal];
    fifthbutton.layer.borderColor = [UIColor blackColor].CGColor;
    fifthbutton.layer.borderWidth = 0.5f;
    
    UIButton *sixthbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    sixthbutton.frame = CGRectMake(curwidth/2, 3*curwidth/2, curwidth/2, curwidth/2);
    [sixthbutton setTitle:[NSString stringWithFormat:@"電腦"] forState:UIControlStateNormal];
    sixthbutton.layer.borderColor = [UIColor blackColor].CGColor;
    sixthbutton.layer.borderWidth = 0.5f;
    
    [mainview addSubview:firstbutton];
    [mainview addSubview:secondbutton];
    [mainview addSubview:thirdbutton];
    [mainview addSubview:forthbutton];
    [mainview addSubview:fifthbutton];
    [mainview addSubview:sixthbutton];
    [mainview addSubview:topview];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
