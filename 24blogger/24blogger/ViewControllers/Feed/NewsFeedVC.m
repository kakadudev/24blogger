//
//  NewsFeedVC.m
//  24blogger
//
//  Created by iZaVyLoN on 11/2/15.
//  Copyright © 2015 iZaVyLoN. All rights reserved.
//

#import "NewsFeedVC.h"
#import "SWRevealViewController.h"
#import "UIImageView+WebCache.h"
#import "NewsFeedCell.h"
#import "DetailNewsVC.h"
#import "SearchResultsVC.h"
#import "UIScrollView+DXRefresh.h"

@interface NewsFeedVC () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchControllerDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableViewFeed;
@property (nonatomic, strong) NSMutableArray *arrayNewsFeed;
@property (nonatomic, strong) NSString *jsonType;
@property (nonatomic, strong) NSArray *searchArray;

@property (nonatomic, assign) int offsetNews;

@property (strong, nonatomic) UISearchController *controller;

@end

@implementation NewsFeedVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    _offsetNews = 1;
    _arrayNewsFeed = [[NSMutableArray alloc] init];

    [self setBarButtonItem];
    
    if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable)
        [[HelperFunction sharedHelperFunction] showProgressHUD:self];
    
    [self refreshHeaderFeed];
    
    [self.tableViewFeed addHeaderWithTarget:self action:@selector(refreshHeaderFeed)];
    [self.tableViewFeed addFooterWithTarget:self action:@selector(refreshBottomFeed)];
}


#pragma DXRefresh

- (void)refreshHeaderFeed {
    if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable) {
        [self endRefreshingTableViewFeed];
        [[HelperFunction sharedHelperFunction] showNoIternetConnectionMessage:self.tableViewFeed];
    } else {
        _offsetNews = 1;
        [self requestFeedNews:_offsetNews isHeader:YES];
    }

}

- (void)refreshBottomFeed {
    if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable) {
        [self endRefreshingTableViewFeed];
        [[HelperFunction sharedHelperFunction] showNoIternetConnectionMessage:self.tableViewFeed];
    } else {
        [self requestFeedNews:_offsetNews isHeader:NO];
    }
}

#pragma  Button
- (void)setBarButtonItem {
    
    {   // Left menu button
        SWRevealViewController *revealController = [self revealViewController];
        [self.navigationController.navigationBar addGestureRecognizer:revealController.panGestureRecognizer];
        
        UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_menu"] style:UIBarButtonItemStylePlain target:revealController action:@selector(revealToggle:)];
        self.navigationItem.leftBarButtonItem = revealButtonItem;
        
        // Set the gesture
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
        // Left menu button
        UIBarButtonItem *searchButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_search"] style:UIBarButtonItemStylePlain target:self action:@selector(pressSearch:)];
        self.navigationItem.rightBarButtonItem = searchButtonItem;
}

- (void)pressSearch:(id)sender {
    [self presentViewController:self.controller animated:YES completion:nil];
}

#pragma UITableView
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"NewsFeedCell";
    NewsFeedCell *newsFeed = (NewsFeedCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (newsFeed == nil) {
        newsFeed = [[NewsFeedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    newsFeed.isNewsFeed = YES;
    
    NSDictionary *mainImage = _arrayNewsFeed[indexPath.section][@"thumbnail_images"][@"normal-post"];
    [newsFeed.mainImageView sd_setImageWithURL:[NSURL URLWithString:[mainImage[@"url"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:nil];
    newsFeed.factorMainImage = [mainImage[@"width"] floatValue] / [mainImage[@"height"] floatValue];
    
    NSString *slugPost = _arrayNewsFeed[indexPath.section][@"categories"][0][@"slug"];
    
    if ([slugPost isEqualToString:@"news"]) {
        [newsFeed.markImageView setImage:[UIImage imageNamed:@"label_news"]];
        [newsFeed.markText setText:[[LanguageManager sharedLanguageManager] getStringValueByKey:@"news_lm"]];
    } else if ([slugPost isEqualToString:@"review"] || [slugPost isEqualToString:@"mobileapps"]) {
        [newsFeed.markImageView setImage:[UIImage imageNamed:@"label_reviews"]];
        [newsFeed.markText setText:[[LanguageManager sharedLanguageManager] getStringValueByKey:@"reviews_lm"]];
    } else if ([slugPost isEqualToString:@"events"]) {
        [newsFeed.markImageView setImage:[UIImage imageNamed:@"label_events"]];
        [newsFeed.markText setText:[[LanguageManager sharedLanguageManager] getStringValueByKey:@"events_lm"]];
    } else {
        
    }
    
    [newsFeed.titleLabel setText:_arrayNewsFeed[indexPath.section][@"title"]];
    [newsFeed.descriptionLabel setText:_arrayNewsFeed[indexPath.section][@"excerpt"]];
    [newsFeed.dateText setText:[[HelperFunction sharedHelperFunction] datePost:_arrayNewsFeed[indexPath.section][@"date"]]];
    [newsFeed.authorText setText:_arrayNewsFeed[indexPath.section][@"author"][@"name"]];
    
    return newsFeed;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_arrayNewsFeed count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *mainImage = _arrayNewsFeed[indexPath.section][@"thumbnail_images"][@"normal-post"];
    return self.view.frame.size.width / ([mainImage[@"width"] floatValue] / [mainImage[@"height"] floatValue]) + [[HelperFunction sharedHelperFunction] descriptionTextHeightForText:_arrayNewsFeed[indexPath.section][@"excerpt"]] + 40.0f;
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable) {
        [[HelperFunction sharedHelperFunction] showNoIternetConnectionMessage:self.view];
    } else {
        DetailNewsVC *detailNewsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailNewsVC"];
        detailNewsVC.newsID = [_arrayNewsFeed[indexPath.section][@"id"] floatValue];
        detailNewsVC.titleNews = _arrayNewsFeed[indexPath.section][@"title"];
        detailNewsVC.arrayFavorites = _arrayNewsFeed[indexPath.section];
        [self.navigationController pushViewController:detailNewsVC animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.00001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.00001;
}

#pragma Search

- (UISearchController *)controller {
    if (!_controller) {
        UINavigationController *searchResultsController = [[self storyboard] instantiateViewControllerWithIdentifier:@"NavigationSearch"];
        _controller = [[UISearchController alloc] initWithSearchResultsController:searchResultsController];
        _controller.delegate = self;
        _controller.searchBar.delegate = self;
    }
    return _controller;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    self.searchArray = @[_jsonType, self.controller.searchBar.text];
    [[NSNotificationCenter defaultCenter] postNotificationName:SEARCH_TEXT_AND_TYPE object:self.searchArray];
}

#pragma Function
//  Description Text Height
- (CGFloat)descriptionTextHeight:(NSInteger)section text:(NSString *)descriptionText {
    RTLabel *descriptionHeight = [[RTLabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, 10.0f)];
    [descriptionHeight setFont:[UIFont fontWithName:KAKADU_FONT_NORMAL size:15.0f]];
    [descriptionHeight setText:_arrayNewsFeed[section][@"excerpt"]];
    return [descriptionHeight optimumSize].height + 20.0f;
}


#pragma UISearchControllerDelegate
- (void)willPresentSearchController:(UISearchController *)searchController {
    
}

- (void)didPresentSearchController:(UISearchController *)searchController {
    
}

- (void)willDismissSearchController:(UISearchController *)searchController {
    self.searchArray = nil;
    [[NSNotificationCenter defaultCenter] postNotificationName:SEARCH_TEXT_AND_TYPE object:self.searchArray];
}

- (void)didDismissSearchController:(UISearchController *)searchController {
    
}

#pragma ServerManager

- (void)requestFeedNews:(NSInteger)offset isHeader:(BOOL)isHeader {
    if (_kakaduClubType == KakaduClubTypeFeed) {
        self.title = [[LanguageManager sharedLanguageManager] getStringValueByKey:@"feed_lm"];
        
        _jsonType = @"feed";
        
        [[ServerManager sharedManager] getFeedJsonCount:10 page:offset onSuccess:^(NSDictionary *dictionary) {
            [self fillingArrayFeedNewsWithArrayData:dictionary[@"posts"] isHeader:isHeader];
            [_tableViewFeed reloadData];
            _offsetNews++;
            
            [self pushDetail];
            
            [self endRefreshingTableViewFeed];
            [[HelperFunction sharedHelperFunction] hideProgressHUD];
        } onFailure:^(NSError *error, NSInteger statusCode) {
            [self endRefreshingTableViewFeed];
            [[HelperFunction sharedHelperFunction] hideProgressHUD];
        }];
    } else {
        if (_kakaduClubType == KakaduClubTypeNews) {
            _jsonType = @"news";
            self.title = [[LanguageManager sharedLanguageManager] getStringValueByKey:@"news_lm"];
        } else if (_kakaduClubType == KakaduClubTypeReviews) {
            _jsonType = @"review";
            self.title = [[LanguageManager sharedLanguageManager] getStringValueByKey:@"reviews_lm"];
        } else {
            _jsonType = @"events";
            self.title = [[LanguageManager sharedLanguageManager] getStringValueByKey:@"events_lm"];
        }
        
        [[ServerManager sharedManager] getFeedNewstJsonType:_jsonType count:10 page:offset onSuccess:^(NSDictionary *dictionary) {
            [self fillingArrayFeedNewsWithArrayData:dictionary[@"posts"] isHeader:isHeader];
            [_tableViewFeed reloadData];
            _offsetNews++;
            
            [self endRefreshingTableViewFeed];
            [[HelperFunction sharedHelperFunction] hideProgressHUD];
        } onFailure:^(NSError *error, NSInteger statusCode) {
            [self endRefreshingTableViewFeed];
            [[HelperFunction sharedHelperFunction] hideProgressHUD];
        }];
    }
}

- (void)pushDetail {
    if (_newsID > 0) {
        DetailNewsVC *detailNewsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailNewsVC"];
        detailNewsVC.newsID =_newsID;
        [self.navigationController pushViewController:detailNewsVC animated:YES];
        _newsID = 0;
    }
}

- (void)fillingArrayFeedNewsWithArrayData:(NSArray *)arrayData isHeader:(BOOL)isHeader {
    if (isHeader) {
        [_arrayNewsFeed removeAllObjects];
    }
    
    for (int counter = 0; counter < [arrayData count]; counter++) {
        [_arrayNewsFeed addObject:arrayData[counter]];
    }
}

- (void)endRefreshingTableViewFeed {
    [_tableViewFeed footerEndRefreshing];
    [_tableViewFeed headerEndRefreshing];
}

@end
