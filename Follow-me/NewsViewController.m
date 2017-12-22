//
//  NewsViewController.m
//  Follow-me
//
//  Created by Oskar Wong on 11/23/17.
//  Copyright © 2017 Oskar Wong. All rights reserved.
//

#import "NewsViewController.h"

@interface NewsViewController ()

@end

@implementation NewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    curwidth = [UIScreen mainScreen].bounds.size.width;
    curheigh = [UIScreen mainScreen].bounds.size.height;
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBar.topItem.title = @"新聞";
    [self.navigationController.navigationBar setTranslucent:YES];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.92 green:0.33 blue:0.34 alpha:0.6]];
    [self createui];
    
}
-(void)createui {
    mainview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, curwidth, curheigh)];
    mainview.backgroundColor = [UIColor whiteColor];
    mainview.showsVerticalScrollIndicator = YES;
    mainview.scrollEnabled = YES;
    mainview.userInteractionEnabled = YES;
    mainview.contentSize = CGSizeMake(curwidth, 2*curheigh/5+3*curwidth+180);
    
    UISegmentedControl *topiccontroller = [[UISegmentedControl alloc] initWithItems:@[@"熱門", @"科技", @"電玩", @"生活"]];
    topiccontroller.frame = CGRectMake(0, 0, curwidth, 40);
    [topiccontroller addTarget:self action:@selector(segmentedControlValueDidChange:) forControlEvents:UIControlEventValueChanged];
    [topiccontroller setSelectedSegmentIndex:0];
    [mainview addSubview:topiccontroller];
    
    [self contentview];
    [self.view addSubview:mainview];
}
-(void)segmentedControlValueDidChange:(UISegmentedControl *)segment {
    switch (segment.selectedSegmentIndex) {
        case 0:
            {
                NSLog(@"selected the hottest");
            }
            break;
        case 1:
        {
            NSLog(@"selected the technology");
        }
            break;
        case 2:
        {
            NSLog(@"the gaming");
        }
            break;
        case 3:
        {
            NSLog(@"the life");
        }
            break;
        default:
            break;
    }
}
-(void)contentview {
    topview = [[UIView alloc] initWithFrame:CGRectMake(0, 40, curwidth, curwidth/3)];
    topview.backgroundColor = [UIColor lightGrayColor];
    
    [mainview addSubview:topview];
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
