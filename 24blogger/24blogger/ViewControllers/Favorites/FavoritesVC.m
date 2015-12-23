//
//  FavoritesVC.m
//  24blogger
//
//  Created by iZaVyLoN on 11/2/15.
//  Copyright © 2015 iZaVyLoN. All rights reserved.
//

#import "FavoritesVC.h"
#import "SWRevealViewController.h"
#import "UIImageView+WebCache.h"
#import "NewsFeedCell.h"
#import "DetailNewsVC.h"

@interface FavoritesVC () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) IBOutlet UITableView *tableViewFavorites;
@property (nonatomic, strong) NSMutableArray *arrayNewsFavorites;

@end

@implementation FavoritesVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setBarButtonItem];
    
    self.title = [[LanguageManager sharedLanguageManager] getStringValueByKey:@"favorite_lm"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _arrayNewsFavorites = [KakaduClubData sharedKakaduClubData].favoritesArray;
    [_tableViewFavorites reloadData];
}

#pragma  Button
- (void)setBarButtonItem {
    // Left menu button
    SWRevealViewController *revealController = [self revealViewController];
    [self.navigationController.navigationBar addGestureRecognizer:revealController.panGestureRecognizer];
    
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_menu"] style:UIBarButtonItemStylePlain target:revealController action:@selector(revealToggle:)];
    self.navigationItem.leftBarButtonItem = revealButtonItem;
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
}


#pragma UITableView
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"NewsFeedCell";
    NewsFeedCell *newsFeed = (NewsFeedCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (newsFeed == nil) {
        newsFeed = [[NewsFeedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    newsFeed.isNewsFeed = YES;
    
    NSDictionary *mainImage = _arrayNewsFavorites[indexPath.section][@"thumbnail_images"][@"normal-post"];
    [newsFeed.mainImageView sd_setImageWithURL:[NSURL URLWithString:[mainImage[@"url"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:nil];
    newsFeed.factorMainImage = [mainImage[@"width"] floatValue] / [mainImage[@"height"] floatValue];
    
    NSString *slugPost = _arrayNewsFavorites[indexPath.section][@"categories"][0][@"slug"];
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
    
    [newsFeed.titleLabel setText:_arrayNewsFavorites[indexPath.section][@"title"]];
    [newsFeed.descriptionLabel setText:_arrayNewsFavorites[indexPath.section][@"excerpt"]];
    [newsFeed.dateText setText:[[HelperFunction sharedHelperFunction] datePost:_arrayNewsFavorites[indexPath.section][@"date"]]];
    [newsFeed.authorText setText:_arrayNewsFavorites[indexPath.section][@"author"][@"name"]];
    
    return newsFeed;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[KakaduClubData sharedKakaduClubData].favoritesArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *mainImage = _arrayNewsFavorites[indexPath.section][@"thumbnail_images"][@"normal-post"];
    return self.view.frame.size.width / ([mainImage[@"width"] floatValue] / [mainImage[@"height"] floatValue]) + [[HelperFunction sharedHelperFunction] descriptionTextHeightForText:_arrayNewsFavorites[indexPath.section][@"excerpt"]] + 40.0f;
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable) {
        [[HelperFunction sharedHelperFunction] showNoIternetConnectionMessage:_tableViewFavorites];
    } else {
        DetailNewsVC *detailNewsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailNewsVC"];
        detailNewsVC.newsID = [_arrayNewsFavorites[indexPath.section][@"id"] floatValue];
        detailNewsVC.titleNews = _arrayNewsFavorites[indexPath.section][@"title"];
        detailNewsVC.arrayFavorites = _arrayNewsFavorites[indexPath.section];
        [self.navigationController pushViewController:detailNewsVC animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.00001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.00001;
}

@end
