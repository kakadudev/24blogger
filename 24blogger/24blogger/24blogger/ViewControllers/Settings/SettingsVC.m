//
//  SettingsVC.m
//  24blogger
//
//  Created by iZaVyLoN on 11/9/15.
//  Copyright © 2015 iZaVyLoN. All rights reserved.
//

#import "SettingsVC.h"
#import "NotificationsVC.h"
#import "SDImageCache.h"

@interface SettingsVC () <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *settingsTableView;

@property (nonatomic, strong) NSArray *arraySettingsTitles;
@property (nonatomic, strong) NSArray *arraySettingsIcons;

@end

@implementation SettingsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _arraySettingsTitles = @[[[LanguageManager sharedLanguageManager] getStringValueByKey:@"notification_s"], [[LanguageManager sharedLanguageManager] getStringValueByKey:@"clear_cashe_s"]];
    _arraySettingsIcons = @[@"ic_notifications", @"ic_cache"];
    
    self.title = [[LanguageManager sharedLanguageManager] getStringValueByKey:@"settings_s"];
    
    {   // Left bar button
        UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_menu"] style:UIBarButtonItemStylePlain target:self action:nil];
        self.navigationItem.leftBarButtonItem = menuButton;
        
        menuButton.target = self.revealViewController;
        menuButton.action = @selector(revealToggle:);
        
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
}

#pragma UITableView

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        
        // Custom selected cell color;
        UIImageView *backGroundView = [[UIImageView alloc] initWithFrame:cell.frame];
        backGroundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3f];
        cell.selectedBackgroundView = backGroundView;
        
        {   // Add custom separator line;
            if (indexPath.row == 0) {
                UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, 1.0f)];
                [line setBackgroundColor:[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:0.7]];
                [cell.contentView addSubview:line];
                
                cell.tintColor = [UIColor blackColor];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 43.5f, self.view.frame.size.width, 1.0f)];
            [line setBackgroundColor:[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:0.7]];
            [cell.contentView addSubview:line];
        }
    }
    
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = [_arraySettingsTitles objectAtIndex:indexPath.row];
    
    if (indexPath.row == 1) {
        cell.detailTextLabel.font = [UIFont fontWithName:KAKADU_FONT_NORMAL size:13];
        cell.detailTextLabel.textColor = [UIColor grayColor];
        
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%.f Mb", (unsigned long)[[SDImageCache sharedImageCache] getSize]/1024.f/1024.f];
    }
    
    cell.imageView.image = [UIImage imageNamed:_arraySettingsIcons[indexPath.row]];
    [cell.imageView setContentMode:UIViewContentModeCenter];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_arraySettingsTitles count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [tableView reloadData];
    
    if (indexPath.row == 0) {
        NotificationsVC *notificationsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"NotificationsVC"];
        [self.navigationController pushViewController:notificationsVC animated:YES];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[[LanguageManager sharedLanguageManager] getStringValueByKey:@"Delete_cache_question"] message:nil delegate:self cancelButtonTitle:[[LanguageManager sharedLanguageManager] getStringValueByKey:@"cancel_button"] otherButtonTitles:[[LanguageManager sharedLanguageManager] getStringValueByKey:@"ok_button"], nil];
        [alert show];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.00001;
}

#pragma UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [[SDImageCache sharedImageCache] clearDisk];
        [[SDImageCache sharedImageCache] clearMemory];
        [self.settingsTableView reloadData];
    }
}


@end
