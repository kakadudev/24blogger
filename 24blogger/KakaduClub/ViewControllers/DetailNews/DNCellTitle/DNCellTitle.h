//
//  DNCellTitle.h
//  KakaduClub
//
//  Created by Sytsevich Dmitry on 11/16/15.
//  Copyright © 2015 iZaVyLoN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTLabel.h"

@interface DNCellTitle : UITableViewCell

@property (nonatomic, strong) RTLabel *textType;

+ (RTLabel *)textLabel;

@end
