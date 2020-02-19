//
//  SecondViewController.m
//  Follow-me
//
//  Created by Oskar Wong on 11/15/17.
//  Copyright © 2017 Oskar Wong. All rights reserved.
//

#import "SecondViewController.h"
#import "ProductDetailViewController.h"
#import "SubSecViewController.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    curwidth = [UIScreen mainScreen].bounds.size.width;
    curheigh = [UIScreen mainScreen].bounds.size.height;
    catname = [[NSMutableArray alloc] init];
    catnum = [[NSMutableArray alloc] init];
    showitem = [[NSArray alloc] init];
    standardUsers = [NSUserDefaults standardUserDefaults];
    // Do any additional setup after loading the view, typically from a nib.
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *checkfile = [documentsDirectory stringByAppendingPathComponent:@"catjson.json"];
    
    NSData *favdata = [NSData dataWithContentsOfFile:checkfile];
    [self performSelectorOnMainThread:@selector(fetchitem:) withObject:favdata waitUntilDone:YES];
    self.navigationController.navigationBar.topItem.title = @"商店";
    [self.navigationController.navigationBar setTranslucent:YES];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.49 green:0.67 blue:0.91 alpha:0.6]];
    [self createui];
}

-(void)viewDidAppear:(BOOL)animated {
    
}

-(void)fetchitem:(NSData *)responseData {
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    showitem = [json valueForKeyPath:@"not_rev"];
    NSArray *temcatname = [[NSArray alloc] init];
    NSArray *temcatnum = [[NSArray alloc] init];
    temcatname =[json valueForKeyPath:@"name"];
    temcatnum = [json valueForKeyPath:@"term_id"];
    for (int i=0; i < [showitem count]; i++) {
        if([[showitem objectAtIndex:i] integerValue] != 1) {
            [catname addObject:[temcatname objectAtIndex:i]];
            [catnum addObject:[temcatnum objectAtIndex:i]];
        }
    }
    NSLog(@"%@", catname);
}
-(void)createui {
    mainview = [[UITableView alloc] initWithFrame:CGRectMake(0, curwidth/2+64, curwidth, curheigh-curwidth/2-64) style:UITableViewStylePlain];
    
    mainview.delegate = self;
    mainview.dataSource = self;
    
    mainview.backgroundColor = [UIColor whiteColor];
    mainview.showsVerticalScrollIndicator = YES;
    mainview.scrollEnabled = YES;
    mainview.userInteractionEnabled = YES;
    mainview.showsVerticalScrollIndicator = NO;
    
    [self contentview];
    [self.view addSubview:mainview];
}
-(void)contentview {
    topview = [[UIView alloc] initWithFrame:CGRectMake(0, 64, curwidth, curwidth/2)];
    topview.backgroundColor = [UIColor whiteColor];
    
    UIButton *topimgad = [UIButton buttonWithType:UIButtonTypeCustom];
    topimgad.frame =CGRectMake(0, 0, topview.frame.size.width, topview.frame.size.height);
    [topimgad addTarget:self action:@selector(bMethod:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *topimgview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, topview.frame.size.width, topview.frame.size.height)];
    [topimgview sd_setImageWithURL:[NSURL URLWithString:[standardUsers objectForKey:@"shop_front_img"]] placeholderImage:[UIImage imageNamed:@"shophead.jpg"]];
    //[topimgview sd_setImageWithURL:[NSURL URLWithString:adimgurl[0]] placeholderImage:[UIImage imageNamed:@"welcome.jpg"]];
    //UIImage *topimg = [UIImage imageNamed:@"shophead.jpg"];
    topimgview.contentMode = UIViewContentModeScaleAspectFill;
    //[topimgview setImage:topimg];
    [topimgad addSubview:topimgview];
    [topview addSubview:topimgad];
    
    [self.view addSubview:topview];
}

-(IBAction)aMethod:(id)sender {
    NSLog(@"testing");
}
-(IBAction)bMethod:(id)sender {
    productview = [self.storyboard instantiateViewControllerWithIdentifier:@"ProductDetailView"];
    productview.detailtitle = [standardUsers objectForKey:@"shop_front_name"];
    productview.postid = [standardUsers objectForKey:@"shop_front_id"];
    productview.postcontent = [standardUsers objectForKey:@"shop_front_description"];;
    [self.navigationController pushViewController:productview animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Table view methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [catname count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    static NSString *ViewCellIdentifier = @"ViewCell";
    UITableViewCell *cell = nil;
    cell = [mainview dequeueReusableCellWithIdentifier:ViewCellIdentifier];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.textLabel.text = [catname objectAtIndex:indexPath.row];
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 160;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    subsecview = [self.storyboard instantiateViewControllerWithIdentifier:@"SecSubView"];
    subsecview.catnum = [catnum objectAtIndex:indexPath.row];
    subsecview.catname = [catname objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:subsecview animated:YES];
    [mainview deselectRowAtIndexPath:indexPath animated:YES];
}

@end
