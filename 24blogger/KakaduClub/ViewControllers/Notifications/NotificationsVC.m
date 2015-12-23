//
//  SettingsVC.m
//  KakaduClub
//
//  Created by iZaVyLoN on 11/9/15.
//  Copyright © 2015 iZaVyLoN. All rights reserved.
//

#import "NotificationsVC.h"

@interface NotificationsVC () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *arrayNotificationsTitles;
@property (nonatomic, strong) NSArray *arrayNotificationsIcons;
@end

@implementation NotificationsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _arrayNotificationsTitles = @[[[LanguageManager sharedLanguageManager] getStringValueByKey:@"news_lm"]];
    _arrayNotificationsIcons = @[@"ic_notifications"];
    
    self.title = [[LanguageManager sharedLanguageManager] getStringValueByKey:@"notification_s"];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self setLeftBarButtonItem];
}

#pragma Button

- (void)setLeftBarButtonItem {
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    backButton.frame = CGRectMake(0, 0, 23, 23);
    [backButton setBackgroundImage:[UIImage imageNamed:@"ic_back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(pressbackButtonNotifications:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:leftButton];
}

- (void)pressbackButtonNotifications:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
        
        
        {   // Added switch
            UISwitch *switchNotification = [[UISwitch alloc] init];
            CGSize switchSize = [switchNotification sizeThatFits:CGSizeZero];
            switchNotification.frame = CGRectMake(cell.contentView.bounds.size.width - switchSize.width - 5.0f,
                                                  (cell.contentView.bounds.size.height - switchSize.height) / 2.0f,
                                                  switchSize.width,
                                                  switchSize.height);
            switchNotification.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
            [switchNotification setOnTintColor:[UIColor colorWithRed:0.008 green:0.467 blue:0.741 alpha:1]];
            [switchNotification addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
            [switchNotification setOn:[KakaduClubData sharedKakaduClubData].isNotification];
            [cell.contentView addSubview:switchNotification];
        }
        
        {   // Add custom separator line;
            if (indexPath.row == 0) {
                UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, 1.0f)];
                [line setBackgroundColor:[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:0.7]];
                [cell addSubview:line];
            }
            
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 43.5f, self.view.frame.size.width, 1.0f)];
            [line setBackgroundColor:[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:0.7]];
            [cell addSubview:line];
        }
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = [_arrayNotificationsTitles objectAtIndex:indexPath.row];
    
    cell.imageView.image = [UIImage imageNamed:_arrayNotificationsIcons[indexPath.row]];
    [cell.imageView setContentMode:UIViewContentModeCenter];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_arrayNotificationsTitles count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.00001;
}

#pragma Switch Changed

- (void)switchChanged:(id)sender {
    UISwitch *switcher = (UISwitch*)sender;
    [[KakaduClubData sharedKakaduClubData] setIsNotification:switcher.on];
    
    if (switcher.on) {
        [[ServerManager sharedManager] pushNotificationPutWithDeviceUDIDToken:[NSString stringWithFormat:@"%@_%@", [KakaduClubData sharedKakaduClubData].deviceUDID, [KakaduClubData sharedKakaduClubData].deviceToken]];
    } else {
        [[ServerManager sharedManager] pushNotificationDeleteWithDeviceUDIDToken:[NSString stringWithFormat:@"%@_%@", [KakaduClubData sharedKakaduClubData].deviceUDID, [KakaduClubData sharedKakaduClubData].deviceToken]];
    }
}

@end
