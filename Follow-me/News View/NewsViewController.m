//
//  NewsViewController.m
//  Follow-me
//
//  Created by Oskar Wong on 11/23/17.
//  Copyright © 2017 Oskar Wong. All rights reserved.
//

#import "NewsViewController.h"
#import "NewsDetailViewController.h"

@interface NewsViewController ()

@end

@implementation NewsViewController
@synthesize contentname, contentid, contentdate, imgurl;
- (void)viewDidLoad {
    [super viewDidLoad];
    curwidth = [UIScreen mainScreen].bounds.size.width;
    curheigh = [UIScreen mainScreen].bounds.size.height;
    // Do any additional setup after loading the view.
    jsonurl_str = @"https://www.follow-me.info/parsejson_cat.php";
    imgurl = [[NSMutableArray alloc] init];
    contentname = [[NSMutableArray alloc] init];
    contentdate = [[NSMutableArray alloc] init];
    contentid = [[NSMutableArray alloc] init];
    fronttitle = @"【最新消息】 ";
    readpage = 0;
    readtext = 0;
    stringID = @"461";
    [self performSelectorOnMainThread:@selector(getserverfile:) withObject:readpage waitUntilDone:YES];

    
    self.navigationController.navigationBar.topItem.title = @"新聞";
    [self.navigationController.navigationBar setTranslucent:YES];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.92 green:0.33 blue:0.34 alpha:0.6]];
    [self createui];
    [self contentview];
    
}
-(void)viewDidAppear:(BOOL)animated {

}
-(void)createui {
    if ((int)curheigh == 812) {
        NSLog(@"test");
        mainview = [[UITableView alloc] initWithFrame:CGRectMake(0, 128, curwidth, curheigh-144)];
    } else {
        NSLog(@"test2");
        mainview = [[UITableView alloc] initWithFrame:CGRectMake(0, 104, curwidth, curheigh-128)];
    }
    mainview.backgroundColor = [UIColor whiteColor];
    mainview.delegate = self;
    mainview.dataSource = self;
    
    [self.view addSubview:mainview];
}
-(void)segmentedControlValueDidChange:(UISegmentedControl *)segment {
    [mainview scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
    switch (segment.selectedSegmentIndex) {
        case 0:
            {
                NSLog(@"selected the hottest");
                stringID = @"461";
                readpage = 0;
                fronttitle = @"【最新消息】 ";
                [self performSelectorOnMainThread:@selector(getserverfile:) withObject:readpage waitUntilDone:YES];
            }
            break;
        case 1:
        {
            NSLog(@"selected the technology");
            stringID = @"3";
            readpage = 0;
            fronttitle = @"【電話資訊】 ";
            [self performSelectorOnMainThread:@selector(getserverfile:) withObject:readpage waitUntilDone:YES];
        }
            break;
        case 2:
        {
            NSLog(@"the gaming");
            stringID = @"2";
            readpage =0;
            fronttitle = @"【有用教學】 ";
            [self performSelectorOnMainThread:@selector(getserverfile:) withObject:readpage waitUntilDone:YES];
        }
            break;
        case 3:
        {
            NSLog(@"the life");
            stringID = @"23";
            readpage = 0;
            fronttitle = @"【生活知識】 ";
            [self performSelectorOnMainThread:@selector(getserverfile:) withObject:readpage waitUntilDone:YES];
        }
            break;
        default:
            break;
    }
}
-(void)getserverfile:(NSString *)loadpage{
    NSString *sentoproustrting = [NSString stringWithFormat:@"cid=%@&lastitem=%@", stringID,loadpage];
    NSLog(@"%@", sentoproustrting);
    NSData *postdata = [sentoproustrting dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *stringlength = [NSString stringWithFormat:@"%lu", (unsigned long)[sentoproustrting length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:jsonurl_str]];
    [request setHTTPMethod:@"POST"];
    [request setValue:stringlength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postdata];
    [request setTimeoutInterval:10.0];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (response &&! error) {
            self->readtext = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            
            if (![self->readtext isEqualToString:@"no value"]) {
                if(loadpage == 0) {
                    [self performSelectorOnMainThread:@selector(fetchproducts:) withObject:data waitUntilDone:YES];
                } else {
                    [self performSelectorOnMainThread:@selector(fetchaddproducts:) withObject:data waitUntilDone:YES];
                }
            } else {
                NSLog(@"no value");
            }
        }
    }];
    
    [task resume];
}

-(void)fetchproducts:(NSData *)responseData {
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    
    contentname = nil;
    NSMutableArray *servername = [[NSMutableArray alloc] init];
    servername = [[[json valueForKeyPath:@"object_id"] valueForKeyPath:@"post_title"] objectAtIndex:0];
    self.contentname = [NSMutableArray arrayWithArray:servername];
    
    contentid = nil;
    NSMutableArray *servcerid = [[NSMutableArray alloc] init];
    servcerid = [[[json valueForKeyPath:@"object_id"] valueForKeyPath:@"ID"] objectAtIndex:0];
    
    self.contentid = [NSMutableArray arrayWithArray:servcerid];
    
    contentdate = nil;
    NSMutableArray *serverdate = [[NSMutableArray alloc] init];
    serverdate = [[[json valueForKeyPath:@"object_id"] valueForKeyPath:@"post_date"] objectAtIndex:0];
    self.contentdate = [NSMutableArray arrayWithArray:serverdate];
    
    imgurl = nil;
    NSMutableArray *serverimg = [[NSMutableArray alloc] init];
    serverimg = [[[json valueForKeyPath:@"object_id"] valueForKeyPath:@"imgurl"] objectAtIndex:0];
    self.imgurl = [NSMutableArray arrayWithArray:serverimg];
    [mainview reloadData];
}
-(void)fetchaddproducts:(NSData *)responseData {
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    NSLog(@"the page id %@", stringID);
    if ([json valueForKeyPath:@"object_id"] != nil) {
        NSLog(@"larger than 0");
    } else {
        NSLog(@"it is zero");
    }
    NSMutableArray *tempname = [[NSMutableArray alloc] initWithArray:contentname];
    contentname = nil;
    NSMutableArray *servername = [[NSMutableArray alloc] init];
    servername = [[[json valueForKeyPath:@"object_id"] valueForKeyPath:@"post_title"] objectAtIndex:0];
    self.contentname = [NSMutableArray arrayWithArray:[tempname arrayByAddingObjectsFromArray:servername]];
    
    NSMutableArray *tempid = [[NSMutableArray alloc] initWithArray:contentid];
    contentid = nil;
    NSMutableArray *servcerid = [[NSMutableArray alloc] init];
    servcerid = [[[json valueForKeyPath:@"object_id"] valueForKeyPath:@"ID"] objectAtIndex:0];
    self.contentid = [NSMutableArray arrayWithArray:[tempid arrayByAddingObjectsFromArray:servcerid]];
    
    NSMutableArray *tempdate = [[NSMutableArray alloc] initWithArray:contentdate];
    contentdate = nil;
    NSMutableArray *serverdate = [[NSMutableArray alloc] init];
    serverdate = [[[json valueForKeyPath:@"object_id"] valueForKeyPath:@"post_date"] objectAtIndex:0];
    self.contentdate = [NSMutableArray arrayWithArray:[tempdate arrayByAddingObjectsFromArray:serverdate]];
    
    NSMutableArray *tempimg = [[NSMutableArray alloc] initWithArray:imgurl];
    imgurl = nil;
    NSMutableArray *serverimg = [[NSMutableArray alloc] init];
    serverimg = [[[json valueForKeyPath:@"object_id"] valueForKeyPath:@"imgurl"] objectAtIndex:0];
    self.imgurl = [NSMutableArray arrayWithArray:[tempimg arrayByAddingObjectsFromArray:serverimg]];
    [mainview reloadData];
}

-(void)contentview {
    UISegmentedControl *topiccontroller = [[UISegmentedControl alloc] initWithItems:@[@"最新", @"手機", @"教學", @"生活"]];
    topiccontroller.backgroundColor = [UIColor colorWithRed:0.92 green:0.33 blue:0.34 alpha:0.6];
    topiccontroller.layer.borderColor = [UIColor colorWithRed:0.92 green:0.33 blue:0.34 alpha:0.6].CGColor;

    topiccontroller.tintColor = [UIColor whiteColor];
    if ((int)curheigh == 812) {
        topiccontroller.frame = CGRectMake(0, 88, curwidth, 40);
    } else {
        topiccontroller.frame = CGRectMake(0, 64, curwidth, 40);
    }
    
    [topiccontroller addTarget:self action:@selector(segmentedControlValueDidChange:) forControlEvents:UIControlEventValueChanged];
    [topiccontroller setSelectedSegmentIndex:0];
    [self.view addSubview:topiccontroller];
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
    return [contentname count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    static NSString *ViewCellIdentifier = @"ViewCell";
    UITableViewCell *cell = nil;
    cell = [mainview dequeueReusableCellWithIdentifier:ViewCellIdentifier];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        
        UIImageView *featureimg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, curwidth, curwidth/4*3)];
        [featureimg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", [[imgurl objectAtIndex:indexPath.row] objectAtIndex:0]]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
        featureimg.contentMode = UIViewContentModeScaleAspectFill;
        featureimg.clipsToBounds = YES;
        UILabel *newtitle = [[UILabel alloc] initWithFrame:CGRectMake(10, curwidth/4*3+5, curwidth-20, curwidth/4-20)];
        newtitle.text = [NSString stringWithFormat:@"%@ %@",fronttitle, [[contentname objectAtIndex:indexPath.row] objectAtIndex:0]];
        newtitle.lineBreakMode = NSLineBreakByWordWrapping;
        newtitle.numberOfLines = 2;
        newtitle.textAlignment = NSTextAlignmentLeft;
        newtitle.font = [UIFont systemFontOfSize:17.0f weight:UIFontWeightMedium];
        [cell.contentView addSubview:newtitle];
        [cell.contentView addSubview:featureimg];
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return curwidth;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    newdetailview = [self.storyboard instantiateViewControllerWithIdentifier:@"NewsDetailView"];
    newdetailview.detailtitle = [NSString stringWithFormat:@"%@ %@",fronttitle, [[contentname objectAtIndex:indexPath.row] objectAtIndex:0]];
    newdetailview.productid = [[contentid objectAtIndex:indexPath.row] objectAtIndex:0];
    NSLog(@"%@",[[contentid objectAtIndex:indexPath.row] objectAtIndex:0] );
    [self.navigationController pushViewController:newdetailview animated:YES];
    [mainview deselectRowAtIndexPath:indexPath animated:YES];
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger lastSectionIndex = [mainview numberOfSections] - 1;
    NSInteger lastRowIndex = [mainview numberOfRowsInSection:lastSectionIndex] - 1;
    
    if (indexPath.row == lastRowIndex) {
        // This is the last cell
        readpage = [NSString stringWithFormat:@"%d",[readpage intValue] + 1];
        NSLog(@"end action %@", readpage);
        [self performSelectorOnMainThread:@selector(getserverfile:) withObject:readpage waitUntilDone:YES];
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
