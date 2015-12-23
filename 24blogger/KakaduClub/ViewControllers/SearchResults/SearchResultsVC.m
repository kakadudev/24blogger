//
//  SearchResultsVC.m
//  KakaduClub
//
//  Created by iZaVyLoN on 11/2/15.
//  Copyright © 2015 iZaVyLoN. All rights reserved.
//

#import "SearchResultsVC.h"
#import "UIImageView+WebCache.h"
#import "NewsFeedCell.h"
#import "DetailNewsVC.h"
#import "AppDelegate.h"

@interface SearchResultsVC ()

@property (nonatomic, strong) NSArray *searchData;
@property (nonatomic, strong) NSArray *arraySearchNews;

@end

@implementation SearchResultsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _searchData = nil;
    _arraySearchNews = nil;
     
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(observeNotification:) name:SEARCH_TEXT_AND_TYPE object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    _searchData = nil;
    _arraySearchNews = nil;
}


#pragma UITableView

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"NewsFeedCell";
    NewsFeedCell *newsFeed = (NewsFeedCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (newsFeed == nil) {
        newsFeed = [[NewsFeedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    newsFeed.isNewsFeed = YES;
    
    NSDictionary *mainImage = _arraySearchNews[indexPath.section][@"thumbnail_images"][@"normal-post"];
    [newsFeed.mainImageView sd_setImageWithURL:[NSURL URLWithString:[mainImage[@"url"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:nil];
    newsFeed.factorMainImage = [mainImage[@"width"] floatValue] / [mainImage[@"height"] floatValue];
    
    NSString *slugPost = _arraySearchNews[indexPath.section][@"categories"][0][@"slug"];
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
    
    [newsFeed.titleLabel setText:_arraySearchNews[indexPath.section][@"title"]];
    [newsFeed.descriptionLabel setText:_arraySearchNews[indexPath.section][@"excerpt"]];
    [newsFeed.dateText setText:[[HelperFunction sharedHelperFunction] datePost:_arraySearchNews[indexPath.section][@"date"]]];
    [newsFeed.authorText setText:_arraySearchNews[indexPath.section][@"author"][@"name"]];
    
    return newsFeed;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_arraySearchNews count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *mainImage = _arraySearchNews[indexPath.section][@"thumbnail_images"][@"normal-post"];
    return self.view.frame.size.width / ([mainImage[@"width"] floatValue] / [mainImage[@"height"] floatValue]) + [[HelperFunction sharedHelperFunction] descriptionTextHeightForText:_arraySearchNews[indexPath.section][@"excerpt"]] + 40.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable) {
        [[HelperFunction sharedHelperFunction] showNoIternetConnectionMessage:self.view];
    } else {
        DetailNewsVC *detailNewsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailNewsVC"];
        detailNewsVC.newsID = [_arraySearchNews[indexPath.section][@"id"] floatValue];
        detailNewsVC.titleNews = _arraySearchNews[indexPath.section][@"title"];        
        [self.navigationController pushViewController:detailNewsVC animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.00001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.00001;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    // extract array from observer
    self.searchData = [(NSArray *)object valueForKey:SEARCH_TEXT_AND_TYPE];
    
    if (_searchData == nil) {
        _arraySearchNews = nil;
        [self.tableView reloadData];
    } else {
        if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable) {
            [[HelperFunction sharedHelperFunction] showNoIternetConnectionMessage:self.view];
        } else {
//            [[HelperFunction sharedHelperFunction] showProgressHUD:self.tableView];
            [self requestGetSearchNews];
        }
    }
}

#pragma NSNotification

- (void)observeNotification:(NSNotification *)notification {
    self.searchData = [notification object];
    
    if (_searchData == nil) {
        _arraySearchNews = nil;
        [self.navigationController popViewControllerAnimated:YES];
        [self.tableView reloadData];
    } else {
        if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable) {
            [[HelperFunction sharedHelperFunction] showNoIternetConnectionMessage:self.view];
        } else {
            [self requestGetSearchNews];
        }
    }
}



#pragma ServerManager

// Get detail news with ID
- (void)requestGetSearchNews {
    [[ServerManager sharedManager] getSearchNewsWithSlug:self.searchData[0] searchText:[self.searchData[1] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] onSuccess:^(NSDictionary *dictionary) {
        _arraySearchNews = dictionary[@"posts"];
        [self.tableView reloadData];
        [[HelperFunction sharedHelperFunction] hideProgressHUD];
    } onFailure:^(NSError *error, NSInteger statusCode) {
        [[HelperFunction sharedHelperFunction] hideProgressHUD];
    }];
}

@end
