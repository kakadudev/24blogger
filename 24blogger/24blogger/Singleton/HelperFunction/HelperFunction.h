//
//  HelperFunction.h
//  24blogger
//
//  Created by iZaVyLoN on 11/6/15.
//  Copyright © 2015 iZaVyLoN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

@interface HelperFunction : NSObject <MBProgressHUDDelegate>

+ (HelperFunction *)sharedHelperFunction;

@property (nonatomic, strong) MBProgressHUD *mbProgressHUD;

// Show Internet Connection Message
- (void)showNoIternetConnectionMessage:(UIView *)viewCurrent;

// Get Current Loacale
- (NSLocale *)currentLocale;

// Show Progress View
- (void)showProgressHUD:(UIViewController *)viewController;

// Hide Progress View
- (void)hideProgressHUD;

// Date format: November, 9 2012 by string;
- (NSString *)datePost:(NSString *)dateString;

//  Get Height Description Text
- (CGFloat)descriptionTextHeightForText:(NSString *)descriptionText;

@end
