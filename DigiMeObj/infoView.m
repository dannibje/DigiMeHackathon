//
//  infoView.m
//  DigiMeObj
//
//  Created by Daníel Sigurbjörnsson on 08/10/2017.
//  Copyright © 2017 Daníel Sigurbjörnsson. All rights reserved.
//

#import "infoView.h"
#import "Chameleon.h"
#import "vaccsCell.h"

@implementation infoView{
    UIView* background;
    UITableView* tableView;
    int tableViewWidth;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //
    }
    return self;
}

-(void)setupViews{
    
    UIGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(exit)];
    [self addGestureRecognizer:tap];
    
    //init views
    background = [[UIView alloc] initWithFrame:self.bounds];
    background.backgroundColor = [UIColor blackColor];
    background.alpha = 0.6;
    [self addSubview:background];
    
    
    
    tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width*0.8, self.frame.size.height*0.8)];
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.allowsSelection = NO;
    [tableView registerNib:[UINib nibWithNibName:@"vaccsCell" bundle:nil] forCellReuseIdentifier:@"vaccCell"];
    //tableView.backgroundColor = [UIColor flatSkyBlueColor];
    [tableView setCenter:self.center];
    
    [tableView reloadData];
    
    [self addSubview:tableView];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_info count];
}

#define cellHeight 89.0
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return cellHeight;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    vaccsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"vaccCell"];
    
    if (cell == nil) {
        cell = [[vaccsCell alloc] initWithFrame:CGRectMake(0, 0, tableViewWidth, cellHeight) reuseIdentifier:@"mainCell"];
    }
    
    id cellObject = [_info objectAtIndex:indexPath.row];
    NSLog(@"object: %@", cellObject);
    NSLog(@"name: %@, %@", [cellObject objectForKey:@"name"],[cellObject objectForKey:@"description"]);
    
    cell.vaccNAme.text = [cellObject objectForKey:@"name"];
    cell.desription.text = [cellObject objectForKey:@"description"];
    
    return cell;
}

-(void)exit{
    [self removeFromSuperview];
}

@end
