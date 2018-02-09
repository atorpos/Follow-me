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
    topview.backgroundColor = [UIColor lightGrayColor];
    
    UIButton *topimgad = [UIButton buttonWithType:UIButtonTypeCustom];
    topimgad.frame =CGRectMake(0, 0, topview.frame.size.width, topview.frame.size.height);
    [topimgad addTarget:self action:@selector(bMethod:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *topimgview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, topview.frame.size.width, topview.frame.size.height)];
    UIImage *topimg = [UIImage imageNamed:@"shophead.jpg"];
    topimgview.contentMode = UIViewContentModeScaleAspectFill;
    [topimgview setImage:topimg];
    [topimgad addSubview:topimgview];
    [topview addSubview:topimgad];
    
    [self.view addSubview:topview];
}

-(IBAction)aMethod:(id)sender {
    NSLog(@"testing");
}
-(IBAction)bMethod:(id)sender {
    productview = [self.storyboard instantiateViewControllerWithIdentifier:@"ProductDetailView"];
    productview.detailtitle = @"ElevationDock 4 for iPhone";
    productview.postid = @"3921";
    productview.postcontent = @"<div class=\"product-tabs-header\">\r\n<div>產品兼容性</div>\r\n<ul>\r\n \t<li>緊湊，最小的設計。</li>\r\n \t<li>這是首個通過蘋果MFi認證的獨立充電底坐。</li>\r\n \t<li>超精確的調整，可以完美適合你的iPhone 或 裝上保護外殼(最多達3毫米)。</li>\r\n \t<li>深度為18°，背部角度為±4°（最適合在桌面或床邊使用）。</li>\r\n \t<li>Lightning 連接器在高扭矩下彎曲，所以您的手機不會翻轉。</li>\r\n \t<li>高級用料：精準的CNC加工不銹鋼旋鈕，加鋅插入，完整的醫療級矽膠包覆，優質編織電纜。</li>\r\n \t<li>NanoPad底部通過微型吸氣鎖定光滑表面，並具有兩級保持力。</li>\r\n \t<li>充電比Qi感應充電快2-3倍。</li>\r\n \t<li>開箱即用 - 無需組裝。</li>\r\n \t<li>發貨： 7 - 14日<b> / </b><a href=\"https://goo.gl/2kyz3D\">聯絡我們</a></li>\r\n</ul>\r\nhttps://youtu.be/T67-2EVfx8g\r\n<div><img class=\"alignnone size-full wp-image-3914\" style=\"color: #555555;\" src=\"https://www.follow-me.pro/wp-content/uploads/2017/12/Dock4-lineup2-copy.jpg\" alt=\"\" width=\"1600\" height=\"1121\" /></div>\r\n</div>\r\n<img class=\"alignnone size-full wp-image-3915\" src=\"https://www.follow-me.pro/wp-content/uploads/2017/12/ED4-cnc-copy.jpg\" alt=\"\" width=\"2400\" height=\"1356\" />\r\n\r\n<img class=\"alignnone size-full wp-image-3917\" src=\"https://www.follow-me.pro/wp-content/uploads/2017/12/Dock4-finishes2-copy.jpg\" alt=\"\" width=\"1600\" height=\"932\" />\r\n\r\n<img class=\"alignnone size-full wp-image-3918\" src=\"https://www.follow-me.pro/wp-content/uploads/2017/12/Dock4-behind-copy.jpg\" alt=\"\" width=\"1600\" height=\"911\" />\r\n\r\n<img class=\"alignnone size-full wp-image-3919\" src=\"https://www.follow-me.pro/wp-content/uploads/2017/12/Dock4-angle-copy.jpg\" alt=\"\" width=\"1600\" height=\"846\" />\r\n\r\n<img class=\"alignnone size-full wp-image-3916\" src=\"https://www.follow-me.pro/wp-content/uploads/2017/12/Dock4-black-copy.jpg\" alt=\"\" width=\"1600\" height=\"1088\" />";
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
