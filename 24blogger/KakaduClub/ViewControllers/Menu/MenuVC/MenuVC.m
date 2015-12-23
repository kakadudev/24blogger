//
//  MenuVC.m
//  KakaduClub
//
//  Created by iZaVyLoN on 11/2/15.
//  Copyright © 2015 iZaVyLoN. All rights reserved.
//

#import "MenuVC.h"
#import "MenuHeaderCell.h"
#import "NewsFeedVC.h"
#import "FavoritesVC.h"
#import "SettingsVC.h"
#import "AboutProjectVC.h"

@interface MenuVC () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *shareView;

@property (nonatomic, strong) NSArray *arrayMenuTitles;
@property (nonatomic, strong) NSArray *arrayMenuIcons;

- (IBAction)pressSocialShare:(id)sender;

@end

@implementation MenuVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _arrayMenuTitles = @[[[LanguageManager sharedLanguageManager] getStringValueByKey:@"feed_lm"], [[LanguageManager sharedLanguageManager] getStringValueByKey:@"news_lm"], [[LanguageManager sharedLanguageManager] getStringValueByKey:@"reviews_lm"], [[LanguageManager sharedLanguageManager] getStringValueByKey:@"events_lm"], [[LanguageManager sharedLanguageManager] getStringValueByKey:@"favorite_lm"], [[LanguageManager sharedLanguageManager] getStringValueByKey:@"settings_lm"], [[LanguageManager sharedLanguageManager] getStringValueByKey:@"about_project_lm"]];
    _arrayMenuIcons = @[@"ic_feed", @"ic_news", @"ic_reviews", @"ic_events", @"ic_favorite", @"ic_settings", @"ic_info"];
    
    [self setStyleShareView];
    
}

#pragma UITableView

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
        // Custom selected cell color;
        UIImageView *backGroundView = [[UIImageView alloc] initWithFrame:cell.frame];
        backGroundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3f];
        cell.selectedBackgroundView = backGroundView;
        
        {   // Add custom separator line;
            if (indexPath.row == 0) {
                UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, 1.0f)];
                [line setBackgroundColor:[UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.3]];
                [cell.contentView addSubview:line];
            }

            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 43.5f, self.view.frame.size.width, 1.0f)];
            [line setBackgroundColor:[UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.3]];
            [cell.contentView addSubview:line];
        }
    }
    
    cell.backgroundColor = [UIColor clearColor];
    
    cell.textLabel.text = [_arrayMenuTitles objectAtIndex:indexPath.row];
    [cell.textLabel setFont:[UIFont fontWithName:KAKADU_FONT_NORMAL size:18]];
    cell.textLabel.textColor = [UIColor whiteColor];
    
    cell.imageView.image = [UIImage imageNamed:_arrayMenuIcons[indexPath.row]];
    [cell.imageView setContentMode:UIViewContentModeCenter];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_arrayMenuTitles count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [tableView reloadData];
    
    switch (indexPath.row) {
        case 0:
        case 1:
        case 2:
        case 3:
            {
                NewsFeedVC *newsFeedVC = [self.storyboard instantiateViewControllerWithIdentifier:@"NewsFeedVC"];
                newsFeedVC.kakaduClubType = (int)indexPath.row;
                UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
                [navController setViewControllers:@[newsFeedVC] animated: NO ];
                
                [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
            }
            break;
        case 4:
            {
                FavoritesVC *favoritesVC = [self.storyboard instantiateViewControllerWithIdentifier:@"FavoritesVC"];
                UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
                [navController setViewControllers:@[favoritesVC] animated: NO ];
                
                [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
            }
            break;
        case 5:
            {
                SettingsVC *settingsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingsVC"];
                UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
                [navController setViewControllers:@[settingsVC] animated: NO ];
                
                [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
            }
            break;
        case 6:
            {
                AboutProjectVC *aboutProjectVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AboutProjectVC"];
                UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
                [navController setViewControllers:@[aboutProjectVC] animated: NO ];
                
                [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
            }
            break;
        default:
            break;
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    static NSString *cellIdentifier = @"MenuHeaderCell";
    
    MenuHeaderCell *menuHeaderCell = (MenuHeaderCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (menuHeaderCell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MenuHeaderCell" owner:self options:nil];
        menuHeaderCell = [nib objectAtIndex:0];
    }
    
    [menuHeaderCell setBackgroundColor:[UIColor clearColor]];
    
    return menuHeaderCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 130.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return 44.0f;
}

#pragma Function

- (void)setStyleShareView {
    _shareView.clipsToBounds = YES;
    _shareView.layer.borderWidth = 1.0;
    _shareView.layer.borderColor = [[UIColor colorWithRed:1 green:1 blue:1 alpha:0.3] CGColor];
}

#pragma Button

- (IBAction)pressSocialShare:(id)sender {
    // Share
    NSURL *shareURL = [NSURL URLWithString:@"http://kakadu.club"];
    NSArray *activityItems = @[[UIImage imageNamed:@"menu_logo"], [[LanguageManager sharedLanguageManager] getStringValueByKey:@"share_text"], shareURL];
    NSArray *applicationActivities = @[];
    NSArray *excludeActivities = @[];
    
    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:applicationActivities];
    activityController.excludedActivityTypes = excludeActivities;

    
    if ([[UIDevice currentDevice] userInterfaceIdiom] != UIUserInterfaceIdiomPad) {
        [self presentViewController:activityController animated:YES completion:^{
            NSLog(@"Activity complete");
        }];
    }
}

@end
