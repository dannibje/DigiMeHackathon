//
//  listViewController.m
//  DigiMeObj
//
//  Created by Daníel Sigurbjörnsson on 08/10/2017.
//  Copyright © 2017 Daníel Sigurbjörnsson. All rights reserved.
//

#import "listViewController.h"
#import "Chameleon.h"
#import "FlatUIKit.h"
#import "TableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "infoView.h"

@interface listViewController ()

@end

@implementation listViewController{
    UITableView* tableView;
    NSArray* raw;
    NSArray* goodColors;
    NSArray* badColors;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

//    _data = @{ @"can" : @[
//                          @{
//                              @"name" : @"American Samoa"
//                          },
//                          @{
//                              @"name" : @"Aland Islands"
//                          },
//                          @{
//                              @"name" : @"Anguilla"
//                          },
//                          @{
//                              @"name" : @"Andorra"
//                          },
//                          @{
//                              @"name" : @"Australia"
//                          }
//                          ],
//               @"cant" : @[
//                       @{
//                           @"name" : @"American Samoa",
//                           @"needVacc": @[
//                                          @{
//                                              @"name": @"Malaria",
//                                              @"description": @"Malaria occurs in some areas. Protect yourself from mosquito bites. Precautions are personal. Consult a qualified medical professional to determine the right actions"
//                                          },
//                                          @{
//                                              @"name": @"Malaria",
//                                              @"description": @"Malaria occurs in some areas. Protect yourself from mosquito bites. Precautions are personal. Consult a qualified medical professional to determine the right actions"
//                                              }
//                                      ]
//                           },
//                       @{
//                           @"name" : @"Aland Islands",
//                           @"needVacc": @[
//                                   @{
//                                       @"name": @"Malaria",
//                                       @"description": @"Malaria occurs in some areas. Protect yourself from mosquito bites. Precautions are personal. Consult a qualified medical professional to determine the right actions"
//                                       },
//                                   @{
//                                       @"name": @"Malaria",
//                                       @"description": @"Malaria occurs in some areas. Protect yourself from mosquito bites. Precautions are personal. Consult a qualified medical professional to determine the right actions"
//                                       }
//                                   ]
//                           },
//                       @{
//                           @"name" : @"Anguilla"
//                           },
//                       @{
//                           @"name" : @"Andorra"
//                           },
//                       @{
//                           @"name" : @"Australia"
//                           }
//                       ]
//               };
//    
    goodColors = @[[UIColor flatMintColor], [UIColor flatMintColorDark], [UIColor flatGreenColor], [UIColor flatGreenColorDark]];
    badColors = @[[UIColor flatWatermelonColor], [UIColor flatWatermelonColorDark], [UIColor flatRedColor], [UIColor flatRedColorDark]];
    self.view.backgroundColor = [UIColor colorWithGradientStyle:UIGradientStyleTopToBottom withFrame:self.view.bounds andColors:@[[UIColor flatOrangeColor], [UIColor flatYellowColorDark]]];
    
    tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height-20)];
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.allowsSelection = NO;
    
    [tableView registerNib:[UINib nibWithNibName:@"TableViewCell" bundle:nil] forCellReuseIdentifier:@"mainCell"];
    [self.view addSubview:tableView];
    
    raw = @[@"can",@"cant"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    [header setBackgroundColor:[UIColor flatMagentaColor]];
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 150, 40)];
    headerLabel.font = [UIFont systemFontOfSize:22 weight:UIFontWeightLight];
    
    NSArray* sectionArray = [_data objectForKey:[raw objectAtIndex:section]];
    NSString* headerString = [NSString stringWithFormat:@"%@ (%lu)",[raw objectAtIndex:section], (unsigned long)[sectionArray count]];
    
    headerLabel.text = [headerString uppercaseString];
    [header addSubview:headerLabel];
    
    return header;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSLog(@"number of sections: %lu", (unsigned long)[_data count]);
    return [_data count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"number of rows: %ld", (long)section);
    return [[_data objectForKey:[raw objectAtIndex:section]] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSLog(@"title of sections: %ld", (long)section);
    return [raw objectAtIndex:section];
}

#define cellHeight 70.0
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return cellHeight;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray *sectionData = [_data objectForKey:[raw objectAtIndex:indexPath.section]];
    id cellObject = [sectionData objectAtIndex:indexPath.row];
    
    
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mainCell"];
    
    if (cell == nil) {
        cell = [[TableViewCell alloc] initWithFrame:CGRectMake(5, 0, self.view.frame.size.width - 10, cellHeight - 5) reuseIdentifier:@"mainCell"];
    }
    
    cell.infoButton.tag = indexPath.row;
    cell.infoButton.hidden = YES;
    if([[raw objectAtIndex:indexPath.section] isEqualToString:@"can"]){
        cell.backgroundColor = [goodColors objectAtIndex:indexPath.row%3];
    }else{
        cell.backgroundColor = [badColors objectAtIndex:indexPath.row%3];
        NSLog(@"cellObject is: %@", cellObject);
        NSLog(@"cellVaccs: %@", [cellObject objectForKey:@"needVacc"]);
        if([cellObject objectForKey:@"needVacc"]){
            
            cell.infoButton.hidden = NO;
            [cell.infoButton addTarget:self action:@selector(showInfo:) forControlEvents:UIControlEventTouchUpInside];

        }
    }
    
    cell.countryLabel.text = [cellObject objectForKey:@"name"];
    NSString* formattedCountryString = [[cellObject objectForKey:@"name"] stringByReplacingOccurrencesOfString:@" " withString:@"-"];
    NSString* flagString = [NSString stringWithFormat:@"https://www.countries-ofthe-world.com/flags-normal/flag-of-%@.png", formattedCountryString];
    [cell.countryFlag sd_setImageWithURL:[NSURL URLWithString:flagString] placeholderImage:[UIImage imageNamed:@"Placeholder_flag"]];
    
    return cell;
}

-(void)showInfo:(UIButton*)sender{
    NSLog(@"sender TAG: %ld", (long)sender.tag);
    
    //Get data
    NSArray *sectionData = [_data objectForKey:[raw objectAtIndex:1]];
    id cellObject = [sectionData objectAtIndex:sender.tag];
    NSArray* neededVaccs = [cellObject objectForKey:@"needVacc"];
    NSLog(@"needeVAccs: %@", neededVaccs);
    
    //display data
    infoView *infopoup = [[infoView alloc] initWithFrame:self.view.bounds];
    infopoup.info = neededVaccs;
    [infopoup setupViews];
    [self.view addSubview:infopoup];
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
