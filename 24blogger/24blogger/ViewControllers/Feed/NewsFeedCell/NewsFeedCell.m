//
//  NewsFeedCell.m
//  24blogger
//
//  Created by Sytsevich Dmitry on 11/16/15.
//  Copyright © 2015 iZaVyLoN. All rights reserved.
//

#import "NewsFeedCell.h"
#import "UIImageView+WebCache.h"

#define LABEL_IMAGE @"label_news"
#define CALENDAR_IMAGE @"ic_calendar"
#define AUTHOR_IMAGE @"ic_author"
#define DATE_WIDGHT 150.0f
#define VALUE_OFFSET 5.0f

@implementation NewsFeedCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        // MainImage
        _mainImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_mainImageView];
        
        // Mark Image
        _markImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_markImageView];
        
        // Mark Label
        _markText = [[UILabel alloc] init];
        [_markText setFont:[UIFont fontWithName:KAKADU_FONT_NORMAL size:15.0f]];
        [_markText setTextColor:[UIColor whiteColor]];
        [self.contentView addSubview:_markText];
        
        // Title text
        _titleBackgroundView = [[UIView alloc] init];
        _titleLabel = [[RTLabel alloc] init];
        [_titleLabel setTextColor:[UIColor whiteColor]];
        [_titleLabel setFont:[UIFont fontWithName:KAKADU_FONT_BOLD size:19.0f]];
        [_titleLabel setTextAlignment:RTTextAlignmentCenter];
        _gradientLayer = [CAGradientLayer layer];
        _gradientLayer.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.0] CGColor], (id)[[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.6] CGColor], nil];
        
        [_titleBackgroundView.layer addSublayer:_gradientLayer];
        [_titleBackgroundView addSubview:_titleLabel];
        [self.contentView addSubview:_titleBackgroundView];
        
        // Description text
        _descriptionLabel = [[RTLabel alloc] init];
        [_descriptionLabel setFont:[UIFont fontWithName:KAKADU_FONT_NORMAL size:15.0f]];
        [self.contentView addSubview:_descriptionLabel];
        
        // Date Image
        _dateImageView = [[UIImageView alloc] init];
        [_dateImageView setImage:[UIImage imageNamed:CALENDAR_IMAGE]];
        [self.contentView addSubview:_dateImageView];
        
        // Date Label
        _dateText = [[UILabel alloc] init];
        [_dateText setFont:[UIFont fontWithName:KAKADU_FONT_NORMAL size:13.0f]];
        [_dateText setTextColor:[UIColor grayColor]];
        [self.contentView addSubview:_dateText];
        
        // Author Image
        _authorImageView = [[UIImageView alloc] init];
        [_authorImageView setImage:[UIImage imageNamed:AUTHOR_IMAGE]];
        [self.contentView addSubview:_authorImageView];
        
        // Author Label
        _authorText = [[UILabel alloc] init];
        [_authorText setFont:[UIFont fontWithName:KAKADU_FONT_NORMAL size:13.0f]];
        [_authorText setTextColor:[UIColor grayColor]];
        [self.contentView addSubview:_authorText];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGFloat offsetDateImage = (self.contentView.frame.size.width/2 - ([UIImage imageNamed:CALENDAR_IMAGE].size.width + 5.0f + [[_dateText text] sizeWithAttributes:@{NSFontAttributeName:[_dateText font]}].width)) / 2;
    CGFloat offsetNameImage = self.contentView.frame.size.width/2 + (self.contentView.frame.size.width/2 - ([UIImage imageNamed:CALENDAR_IMAGE].size.width + 5.0f + [[_authorText text] sizeWithAttributes:@{NSFontAttributeName:[_authorText font]}].width)) / 2;
    
    [_mainImageView setFrame:CGRectMake(0.0f, 0.0f, self.contentView.frame.size.width, self.contentView.frame.size.width / _factorMainImage)];
    [_markImageView setFrame:CGRectMake(0.0f, VALUE_OFFSET * 3, [UIImage imageNamed:LABEL_IMAGE].size.width, [UIImage imageNamed:LABEL_IMAGE].size.height)];
    [_markText setFrame:CGRectMake(_markImageView.frame.origin.x + 2 * VALUE_OFFSET, _markImageView.frame.origin.y, _markImageView.frame.size.width, _markImageView.frame.size.height)];
    
    if ([self checkIsNewsCell:_isNewsFeed]) {
        [_titleBackgroundView setFrame:CGRectMake(0.0f, _mainImageView.frame.size.height - 1.5 * [self heightTitleLabel], self.contentView.frame.size.width, 1.5 * [self heightTitleLabel])];
        [_gradientLayer setFrame:_titleBackgroundView.bounds];
        
        [_titleLabel setFrame:CGRectMake(_titleBackgroundView.bounds.origin.x, _titleBackgroundView.bounds.origin.y + [self heightTitleLabel] / 3, _titleBackgroundView.bounds.size.width, _titleBackgroundView.bounds.size.height)];
        [_descriptionLabel setFrame:CGRectMake(VALUE_OFFSET, _mainImageView.frame.size.height + VALUE_OFFSET * 2, self.contentView.frame.size.width - VALUE_OFFSET * 2, [self heightDescriptionLabel])];

        
        [_dateImageView setFrame:CGRectMake(offsetDateImage, _mainImageView.frame.size.height + VALUE_OFFSET * 2.5 + [self heightDescriptionLabel], [UIImage imageNamed:CALENDAR_IMAGE].size.width, [UIImage imageNamed:CALENDAR_IMAGE].size.height)];
        [_dateText setFrame:CGRectMake(offsetDateImage + [UIImage imageNamed:CALENDAR_IMAGE].size.width + 5.0f, _mainImageView.frame.size.height + VALUE_OFFSET * 2.5 + [self heightDescriptionLabel], DATE_WIDGHT, [UIImage imageNamed:CALENDAR_IMAGE].size.height)];
        
        [_authorImageView setFrame:CGRectMake(offsetNameImage, _mainImageView.frame.size.height + VALUE_OFFSET * 2.5 + [self heightDescriptionLabel], [UIImage imageNamed:CALENDAR_IMAGE].size.width, [UIImage imageNamed:CALENDAR_IMAGE].size.height)];
        [_authorText setFrame:CGRectMake(offsetNameImage + [UIImage imageNamed:CALENDAR_IMAGE].size.width + 5.0f, _mainImageView.frame.size.height + VALUE_OFFSET * 2.5 + [self heightDescriptionLabel], DATE_WIDGHT, [UIImage imageNamed:CALENDAR_IMAGE].size.height)];
    } else {
        [_titleBackgroundView setFrame:CGRectMake(0.0f, _mainImageView.frame.size.height - 50, self.contentView.frame.size.width, 50)];
        [_gradientLayer setFrame:_titleBackgroundView.bounds];
        
        [_dateImageView setFrame:CGRectMake(offsetDateImage, _mainImageView.frame.size.height - 35, [UIImage imageNamed:CALENDAR_IMAGE].size.width, [UIImage imageNamed:CALENDAR_IMAGE].size.height)];
        [_dateText setFrame:CGRectMake(offsetDateImage + [UIImage imageNamed:CALENDAR_IMAGE].size.width + 5.0f, _mainImageView.frame.size.height - 35, DATE_WIDGHT, [UIImage imageNamed:CALENDAR_IMAGE].size.height)];
        [_dateText setTextColor:[UIColor whiteColor]];
        [_authorImageView setFrame:CGRectMake(offsetNameImage, _mainImageView.frame.size.height - 35, [UIImage imageNamed:CALENDAR_IMAGE].size.width, [UIImage imageNamed:CALENDAR_IMAGE].size.height)];
        [_authorText setFrame:CGRectMake(offsetNameImage + [UIImage imageNamed:CALENDAR_IMAGE].size.width + 5.0f, _mainImageView.frame.size.height - 35, DATE_WIDGHT, [UIImage imageNamed:CALENDAR_IMAGE].size.height)];
        [_authorText setTextColor:[UIColor whiteColor]];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

#pragma RTLabel height

- (CGFloat)heightTitleLabel {
    CGSize optimumSizeFirst = [_titleLabel optimumSize];
    CGRect frameFirst = [_titleLabel frame];
    frameFirst.size.height = (int)optimumSizeFirst.height;
    return frameFirst.size.height + 5.0f;
}

- (CGFloat)heightDescriptionLabel {
    CGSize optimumSizeFirst = [_descriptionLabel optimumSize];
    CGRect frameFirst = [_descriptionLabel frame];
    frameFirst.size.height = (int)optimumSizeFirst.height;
    return frameFirst.size.height + 5.0f;
}

#pragma Function

- (BOOL)checkIsNewsCell:(BOOL)isNewsCell {
    if (!isNewsCell) {
        [_descriptionLabel removeFromSuperview];
        [_titleLabel removeFromSuperview];
    }
    
    return isNewsCell;
}

@end
