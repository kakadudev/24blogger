//
//  HelperFunction.m
//  KakaduClub
//
//  Created by iZaVyLoN on 11/6/15.
//  Copyright © 2015 iZaVyLoN. All rights reserved.
//

#import "HelperFunction.h"
#import "DMRNotificationView.h"
#import "RTLabel.h"

#define HELPERSINGLETON @"HelperFunction"
#define SIZE_FONT 18
#define SIZE_FONT_DETAIL_NEWS 15
#define SIZE_FONT_FOOTER 11

@implementation HelperFunction 

static HelperFunction * sharedInstance = nil;

+ (HelperFunction *)sharedHelperFunction {
    
    static dispatch_once_t once_token = 0;
    
    dispatch_once(&once_token, ^{
        sharedInstance =  [[self alloc] init];
    });
    
    return sharedInstance ;
}

#pragma  Function

- (void)showNoIternetConnectionMessage:(UIView *)viewCurrent {
    DMRNotificationView *notificationView = [[DMRNotificationView alloc] initWithTitle:[[LanguageManager sharedLanguageManager] getStringValueByKey:@"message_no_connection"] subTitle:nil targetView:viewCurrent];
    [notificationView setIsTransparent:YES];
    [notificationView showAnimated:YES];
}

- (NSLocale *)currentLocale {
//    return [[NSLocale alloc] initWithLocaleIdentifier:@"ru_RU"];
    return nil;
}

- (void)showProgressHUD:(UIViewController *)viewController {
    _mbProgressHUD = [[MBProgressHUD alloc] initWithView:viewController.navigationController.view];
    [viewController.navigationController.view addSubview:_mbProgressHUD];
    _mbProgressHUD.dimBackground = YES;
    _mbProgressHUD.delegate = self;
    [_mbProgressHUD show:YES];
}

- (void)hideProgressHUD {
    [_mbProgressHUD hide:YES];
}

- (NSString *)datePost:(NSString *)dateString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    NSDate *postDate = [dateFormatter dateFromString:dateString];
    dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    return [dateFormatter stringFromDate:postDate];
}

- (CGFloat)descriptionTextHeightForText:(NSString *)descriptionText {
    RTLabel *descriptionHeight = [[RTLabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [UIScreen mainScreen].bounds.size.width, 10.0f)];
    [descriptionHeight setFont:[UIFont fontWithName:KAKADU_FONT_NORMAL size:15.0f]];
    [descriptionHeight setText:descriptionText];
    return [descriptionHeight optimumSize].height + 20.0f;
}

@end
