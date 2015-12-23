//
//  NewsFeedCell.h
//  24blogger
//
//  Created by Sytsevich Dmitry on 11/16/15.
//  Copyright © 2015 iZaVyLoN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTLabel.h"

@interface NewsFeedCell : UITableViewCell

@property (nonatomic, strong) UIImageView *mainImageView;
@property (nonatomic, assign) CGFloat factorMainImage;

@property (nonatomic, strong) UIImageView *markImageView;
@property (nonatomic, strong) UILabel *markText;

@property (nonatomic, strong) RTLabel *titleLabel;
@property (nonatomic, strong) UIView *titleBackgroundView;
@property (nonatomic, strong) CAGradientLayer *gradientLayer;

@property (nonatomic, strong) RTLabel *descriptionLabel;

@property (nonatomic, strong) UIImageView *dateImageView;
@property (nonatomic, strong) UILabel *dateText;

@property (nonatomic, strong) UIImageView *authorImageView;
@property (nonatomic, strong) UILabel *authorText;

@property (nonatomic, assign) BOOL isNewsFeed;

@end
