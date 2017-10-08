//
//  infoView.h
//  DigiMeObj
//
//  Created by Daníel Sigurbjörnsson on 08/10/2017.
//  Copyright © 2017 Daníel Sigurbjörnsson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface infoView : UIView <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) NSArray* info;

-(void)setupViews;

@end
