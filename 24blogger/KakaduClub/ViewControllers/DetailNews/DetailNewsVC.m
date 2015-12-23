//
//  DetailNewsVC.m
//  KakaduClub
//
//  Created by iZaVyLoN on 11/16/15.
//  Copyright © 2015 iZaVyLoN. All rights reserved.
//

#import "DetailNewsVC.h"
#import "NewsFeedCell.h"
#import "UIImageView+WebCache.h"
#import "DNCellTitle.h"
#import "DNCellText.h"
#import "DNCellImage.h"
#import "DNCellVideo.h"

#define CALENDAR_IMAGE_WHITE @"ic_calendar_white"
#define AUTHOR_IMAGE_WHITE @"ic_author_white"
#define IC_FAVORITE @"ic_favorite_navbar"
#define IC_FAVORITE_FILLED @"ic_favorite_filled_navbar"
#define HEIGHT_OFFSET 10.0f

typedef enum {
    TypeNewsCellHeader = 0,
    TypeNewsCellTitle,
    TypeNewsCellText,
    TypeNewsCellImage,
    TypeNewsCellVideo
} TypeNewsCell;

@interface DetailNewsVC () <RTLabelDelegate>

@property (nonatomic, strong) UIButton *buttonFavorites;

@property (nonatomic, strong) NSMutableArray *arrayDetailNews;
@property (nonatomic, strong) NSMutableArray *arrayTypeDetailNews;
@property (nonatomic, strong) NSDictionary *dictionaryDetailNews;

@property (nonatomic, assign) TypeNewsCell typeNewsCell;

@end

@implementation DetailNewsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.title = _titleNews;
    
    // Add Left Bar BUtton
    [self setLeftBarButtonItem];
    
    // Check Network Connction
    if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable) {
        [[HelperFunction sharedHelperFunction] showNoIternetConnectionMessage:self.view];
    } else {
        _arrayDetailNews = [[NSMutableArray alloc] init];
        _arrayTypeDetailNews = [[NSMutableArray alloc] init];
        
        [[HelperFunction sharedHelperFunction] showProgressHUD:self];
        // Send Request Get Detail News With ID
        [self requestGetDetailNewsWithID:_newsID];
    }
}

#pragma UITableView

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([_arrayTypeDetailNews[indexPath.section] integerValue] == TypeNewsCellHeader) {
        static NSString *cellIdentifier = @"NewsFeedCell";
        NewsFeedCell *newsFeed = (NewsFeedCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (newsFeed == nil) {
            newsFeed = [[NewsFeedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        
        newsFeed.selectionStyle = UITableViewCellSelectionStyleNone;
        newsFeed.isNewsFeed = NO;
        
        NSDictionary *mainImage = _arrayDetailNews[indexPath.section][@"thumbnail_images"][@"normal-post"];
        [newsFeed.mainImageView sd_setImageWithURL:[NSURL URLWithString:[mainImage[@"url"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:nil];
        newsFeed.factorMainImage = [mainImage[@"width"] floatValue] / [mainImage[@"height"] floatValue];
        
        NSString *slugPost = _arrayDetailNews[indexPath.section][@"categories"][0][@"slug"];
        if ([slugPost isEqualToString:@"news"]) {
            [newsFeed.markImageView setImage:[UIImage imageNamed:@"label_news"]];
            [newsFeed.markText setText:[[LanguageManager sharedLanguageManager] getStringValueByKey:@"news_lm"]];
        } else if ([slugPost isEqualToString:@"review"] || [slugPost isEqualToString:@"mobileapps"]) {
            [newsFeed.markImageView setImage:[UIImage imageNamed:@"label_reviews"]];
            [newsFeed.markText setText:[[LanguageManager sharedLanguageManager] getStringValueByKey:@"reviews_lm"]];
        } else {
            [newsFeed.markImageView setImage:[UIImage imageNamed:@"label_events"]];
            [newsFeed.markText setText:[[LanguageManager sharedLanguageManager] getStringValueByKey:@"events_lm"]];
        }
        
        [newsFeed.authorImageView setImage:[UIImage imageNamed:AUTHOR_IMAGE_WHITE]];
        [newsFeed.dateImageView setImage:[UIImage imageNamed:CALENDAR_IMAGE_WHITE]];
        [newsFeed.dateText setText:[[HelperFunction sharedHelperFunction] datePost:_arrayDetailNews[indexPath.section][@"date"]]];
        [newsFeed.authorText setText:_arrayDetailNews[indexPath.section][@"author"][@"name"]];
        
        return newsFeed;
    } else if ([_arrayTypeDetailNews[indexPath.section] integerValue] == TypeNewsCellTitle) {
        static NSString *cellIdentifier = @"DNCellTitle";
        DNCellTitle *dnCellText = (DNCellTitle *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (dnCellText == nil) {
            dnCellText = [[DNCellTitle alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            [dnCellText.textType setDelegate:self];
        }
        
        [dnCellText.textType setText:_arrayDetailNews[indexPath.section]];
        
        return dnCellText;
    } else if ([_arrayTypeDetailNews[indexPath.section] integerValue] == TypeNewsCellText) {
        static NSString *cellIdentifier = @"DNCellText";
        DNCellText *dnCellText = (DNCellText *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (dnCellText == nil) {
            dnCellText = [[DNCellText alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            [dnCellText.textType setDelegate:self];
        }
        
        [dnCellText.textType setText:_arrayDetailNews[indexPath.section]];
        
        return dnCellText;
    } else if ([_arrayTypeDetailNews[indexPath.section] integerValue] == TypeNewsCellImage) {
        static NSString *cellIdentifier = @"DNCellImage";
        DNCellImage *dNCellImage = (DNCellImage *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (dNCellImage == nil) {
            dNCellImage = [[DNCellImage alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        
        [dNCellImage.imagePhoto sd_setImageWithURL:[NSURL URLWithString:_arrayDetailNews[indexPath.section]] placeholderImage:nil];
        return dNCellImage;
    } else if (YES) {
        static NSString *CellIdentifier = @"DNCellVideo";
        DNCellVideo *dNCellVideo = (DNCellVideo *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (dNCellVideo == nil) {
            dNCellVideo = [[DNCellVideo alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        dNCellVideo.urlVideo = _arrayDetailNews[indexPath.section];
        
        return dNCellVideo;
    } else {
        return nil;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_arrayDetailNews count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([_arrayTypeDetailNews[indexPath.section] integerValue] == TypeNewsCellHeader) {
        NSDictionary *mainImage = _arrayDetailNews[indexPath.section][@"thumbnail_images"][@"normal-post"];
        return self.view.frame.size.width / ([mainImage[@"width"] floatValue] / [mainImage[@"height"] floatValue]) + 10.0f;
    } if ([_arrayTypeDetailNews[indexPath.section] integerValue] == TypeNewsCellTitle || [_arrayTypeDetailNews[indexPath.section] integerValue] == TypeNewsCellText) {
        RTLabel *rtLabel;
        if ([_arrayTypeDetailNews[indexPath.section] integerValue] == TypeNewsCellTitle) {
            rtLabel = [DNCellTitle textLabel];
        } else {
            rtLabel = [DNCellText textLabel];
        }
        [rtLabel setText:_arrayDetailNews[indexPath.section]];
        CGSize optimumSize = [rtLabel optimumSize];
        
        return optimumSize.height + HEIGHT_OFFSET;
    } else  if ([_arrayTypeDetailNews[indexPath.section] integerValue] == TypeNewsCellImage) {
        return self.view.frame.size.width * IMAGE_FACTOR_FOR_HEIGHT + HEIGHT_OFFSET;
    } else  if ([_arrayTypeDetailNews[indexPath.section] integerValue] == TypeNewsCellVideo) {
        return self.view.frame.size.width * VIDEO_FACTOR_FOR_HEIGHT + HEIGHT_OFFSET;
    } else {
        return 0.0f;
    }
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == [_arrayDetailNews count] - 1) {
        UIView *headerView = [[UIView alloc] init];
        [headerView setBackgroundColor:[UIColor colorWithRed:0.9f green:0.96f blue:1.0f alpha:1.0f]];
        
        {   // Create Center Label
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 10.0f, self.view.frame.size.width, 25)];
            [titleLabel setFont:[UIFont fontWithName:KAKADU_FONT_NORMAL size:21]];
            [titleLabel setText:[[LanguageManager sharedLanguageManager] getStringValueByKey:@"news_footer_title"]];
            [titleLabel setTextAlignment:NSTextAlignmentCenter];
            [headerView addSubview:titleLabel];
        }
        
        
        if (_dictionaryDetailNews[@"next_title"] != nil) {
            // Create Left Button
            UIImage *leftButtonImage = [UIImage imageNamed:@"ic_left"];
            UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
            leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            [leftButton setFrame:CGRectMake(10.0, 50.0f, 150.0f, 32.0f)];
            [leftButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0f, 5.0f, 0.0f, 0.0f)];
            [leftButton setImage:leftButtonImage forState:UIControlStateNormal];
            [leftButton setTitle:_dictionaryDetailNews[@"next_title"] forState:UIControlStateNormal];
            [leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [leftButton.titleLabel setFont:[UIFont fontWithName:KAKADU_FONT_NORMAL size:15.0]];
            leftButton.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
            leftButton.titleLabel.numberOfLines = 2;
            [leftButton addTarget:self action:@selector(pressNextNewsButton:) forControlEvents:UIControlEventTouchUpInside];
            [headerView addSubview:leftButton];
        }
        
        if (_dictionaryDetailNews[@"previous_title"] != nil) {
            // Create Right Button
            UIImage *rightButtonImage = [UIImage imageNamed:@"ic_right"];
            UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [rightButton setFrame:CGRectMake(self.view.frame.size.width - 160.0f, 50.0, 150.0f, 32)];
            [rightButton setImageEdgeInsets:UIEdgeInsetsMake(0.0f, CGRectGetWidth(rightButton.frame) - rightButtonImage.size.width, 0.0f, 0.0f)];
            [rightButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 1.2 * rightButtonImage.size.width)];
            [rightButton setImage:rightButtonImage forState:UIControlStateNormal];
            [rightButton setTitle:_dictionaryDetailNews[@"previous_title"] forState:UIControlStateNormal];
            [rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [rightButton.titleLabel setFont:[UIFont fontWithName:KAKADU_FONT_NORMAL size:15.0]];
            rightButton.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
            rightButton.titleLabel.textAlignment = NSTextAlignmentRight;
            rightButton.titleLabel.numberOfLines = 2;
            [rightButton addTarget:self action:@selector(pressPreviousNewsButton:) forControlEvents:UIControlEventTouchUpInside];
            [headerView addSubview:rightButton];
        }
        
        return headerView;
    } else {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.00001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == [_arrayDetailNews count] - 1) {
        return 110.0f;
    } else {
        return 0.00001;
    }
}


#pragma ServerManager

// Get detail news with ID
- (void)requestGetDetailNewsWithID:(NSInteger)newsID {
    
    [[ServerManager sharedManager] getDetailNewsWithID:newsID onSuccess:^(NSDictionary *dictionary) {
        
        [_arrayDetailNews removeAllObjects];
        [_arrayTypeDetailNews removeAllObjects];
        
        _dictionaryDetailNews = dictionary;
        
        [_arrayDetailNews addObject:_dictionaryDetailNews[@"post"]];
        [_arrayTypeDetailNews addObject:[NSNumber numberWithInt:TypeNewsCellHeader]];
        
        NSArray *postContent = dictionary[@"post"][@"content"];
        
        [_arrayDetailNews addObject:dictionary[@"post"][@"title"]];
        [_arrayTypeDetailNews addObject:[NSNumber numberWithInt:TypeNewsCellTitle]];
        
        
        for (int i = 0; i < [postContent count]; i ++) {
            NSDictionary *contentDictionary = postContent[i];
            
            if ([contentDictionary[@"type"] isEqualToString:@"text"] || [contentDictionary[@"type"] isEqualToString:@"list"]) {
                [_arrayDetailNews addObject:contentDictionary[@"body"]];
                [_arrayTypeDetailNews addObject:[NSNumber numberWithInt:TypeNewsCellText]];
            }
            
            
            if ([contentDictionary[@"type"] isEqualToString:@"image"]) {
                [_arrayDetailNews addObject:contentDictionary[@"body"]];
                [_arrayTypeDetailNews addObject:[NSNumber numberWithInt:TypeNewsCellImage]];
            }

            if ([contentDictionary[@"type"] isEqualToString:@"video"]) {
                [_arrayDetailNews addObject:contentDictionary[@"body"]];
                [_arrayTypeDetailNews addObject:[NSNumber numberWithInt:TypeNewsCellVideo]];
            }
        }
        
        self.title = dictionary[@"post"][@"title"];
        
        [[HelperFunction sharedHelperFunction] hideProgressHUD];
        [_detailNewsTableView reloadData];
    } onFailure:^(NSError *error, NSInteger statusCode) {
        [[HelperFunction sharedHelperFunction] hideProgressHUD];
    }];
}

#pragma Button

- (void)setLeftBarButtonItem {
    // Create left button
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    backButton.frame = CGRectMake(0.0f, 0.0f, 23.0f, 23.0f);
    [backButton setBackgroundImage:[UIImage imageNamed:@"ic_back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(pressbackButtonNotifications:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:leftButton];
    
    // Create right buttons
    UIButton *buttonShare = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    buttonShare.frame = CGRectMake(0.0f, 0.0f, 27.0f, 27.0f);
    [buttonShare setBackgroundImage:[UIImage imageNamed:@"ic_share_navbar"] forState:UIControlStateNormal];
    [buttonShare addTarget:self action:@selector(pressbackShare:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *righBarButtonShare = [[UIBarButtonItem alloc] initWithCustomView:buttonShare];
    
    _buttonFavorites = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _buttonFavorites.frame = CGRectMake(0.0f, 0.0f, 27.0f, 27.0f);
    
    if ([[KakaduClubData sharedKakaduClubData].favoritesID containsObject:[NSNumber numberWithInteger:_newsID]]) {
        [_buttonFavorites setBackgroundImage:[UIImage imageNamed:IC_FAVORITE_FILLED] forState:UIControlStateNormal];
    } else {
        [_buttonFavorites setBackgroundImage:[UIImage imageNamed:IC_FAVORITE] forState:UIControlStateNormal];
    }
    
    [_buttonFavorites addTarget:self action:@selector(pressbackFavorites:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *righBarButtonFavorites = [[UIBarButtonItem alloc] initWithCustomView:_buttonFavorites];
    
    // Create a spacer
    UIBarButtonItem *space = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
    space.width = 10.0f;
    
    NSArray *buttons = @[righBarButtonShare, space, righBarButtonFavorites, space];
    self.navigationItem.rightBarButtonItems = buttons;
    
}

- (void)pressbackButtonNotifications:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)pressNextNewsButton:(id)sender {
    [self nextNewswithID:[_dictionaryDetailNews[@"next_id"] integerValue]];
}

- (void)pressPreviousNewsButton:(id)sender {
    [self nextNewswithID:[_dictionaryDetailNews[@"previous_id"] integerValue]];
}

- (void)nextNewswithID:(NSInteger)nextNewsID {
    if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable) {
        [[HelperFunction sharedHelperFunction] showNoIternetConnectionMessage:self.view];
    } else {
        [[HelperFunction sharedHelperFunction] showProgressHUD:self];
        [self requestGetDetailNewsWithID:nextNewsID];
        [_detailNewsTableView setContentOffset:CGPointZero animated:YES];
    }
}

- (void)pressbackFavorites:(id)sender {
    if ([[KakaduClubData sharedKakaduClubData].favoritesID containsObject:[NSNumber numberWithInteger:_newsID]]) {
        [_buttonFavorites setBackgroundImage:[UIImage imageNamed:IC_FAVORITE] forState:UIControlStateNormal];
        
        NSUInteger indexID = [[KakaduClubData sharedKakaduClubData].favoritesID indexOfObject:[NSNumber numberWithInteger:_newsID]];
        [[KakaduClubData sharedKakaduClubData].favoritesID removeObjectAtIndex:indexID];
        [[KakaduClubData sharedKakaduClubData].favoritesArray removeObjectAtIndex:indexID];
    } else {
        [_buttonFavorites setBackgroundImage:[UIImage imageNamed:IC_FAVORITE_FILLED] forState:UIControlStateNormal];
        
        [[KakaduClubData sharedKakaduClubData].favoritesID addObject:[NSNumber numberWithInteger:_newsID]];
        [[KakaduClubData sharedKakaduClubData].favoritesArray addObject:_arrayFavorites];
    }
}

- (void)pressbackShare:(id)sender {
    NSString *shareTitle = _arrayDetailNews[0][@"title"];
    NSURL *shareURL = [NSURL URLWithString:_arrayDetailNews[0][@"url"]];
    
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:_arrayDetailNews[0][@"attachments"][0][@"images"][@"normal-post"][@"url"]]];
    UIImage *imageShare = [UIImage imageWithData:data];
    
    NSArray *activityItems = @[imageShare, shareTitle, shareURL];
    NSArray *applicationActivities = @[];
    NSArray *excludeActivities = @[];
    
    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:applicationActivities];
    activityController.excludedActivityTypes = excludeActivities;
//    [activityController.view setTintColor:[UIColor blackColor]];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] != UIUserInterfaceIdiomPad) {
        [self presentViewController:activityController animated:YES completion:^{
            NSLog(@"Activity complete");
        }];
    }

}

@end
