//
//  AppDelegate.h
//  KakaduClub
//
//  Created by iZaVyLoN on 11/2/15.
//  Copyright © 2015 iZaVyLoN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, SWRevealViewControllerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) SWRevealViewController *mainController;

@end

