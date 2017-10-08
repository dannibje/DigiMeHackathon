//
//  TableViewCell.m
//  DigiMeObj
//
//  Created by Daníel Sigurbjörnsson on 08/10/2017.
//  Copyright © 2017 Daníel Sigurbjörnsson. All rights reserved.
//

#import "TableViewCell.h"

@implementation TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    //press state events for continueButton
    [_infoButton addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchDown];
    [_infoButton addTarget:self action:@selector(buttonReleaseInside:) forControlEvents:UIControlEventTouchUpInside];
    [_infoButton addTarget:self action:@selector(buttonReleaseOutside:) forControlEvents:UIControlEventTouchUpOutside];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

// Scale up on button press
- (void) buttonPress:(UIButton*)button {
    button.transform = CGAffineTransformMakeScale(0.9, 0.9);
}
- (void) buttonReleaseInside:(UIButton*)button {
    button.transform = CGAffineTransformMakeScale(1.0, 1.0);
}
- (void) buttonReleaseOutside:(UIButton*)button {
    button.transform = CGAffineTransformMakeScale(1.0, 1.0);
}


@end
