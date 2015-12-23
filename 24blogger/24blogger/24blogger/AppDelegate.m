//
//  AppDelegate.m
//  24blogger
//
//  Created by iZaVyLoN on 11/2/15.
//  Copyright © 2015 iZaVyLoN. All rights reserved.
//

#import "AppDelegate.h"
#import "MenuVC.h"
#import "NewsFeedVC.h"
#import "KakaduClubData.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    UIWindow *window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window = window;
    application.applicationIconBadgeNumber = 0;
    [self customizeNavigationAndSearchBar];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    NewsFeedVC *newsFeedVC = [storyboard instantiateViewControllerWithIdentifier:@"NewsFeedVC"];
    MenuVC *menuVC = [storyboard instantiateViewControllerWithIdentifier:@"MenuVC"];
    
    UINavigationController *frontNavigationController = [[UINavigationController alloc] initWithRootViewController:newsFeedVC];
    
    SWRevealViewController *mainRevealController = [[SWRevealViewController alloc] initWithRearViewController:menuVC frontViewController:frontNavigationController];
    mainRevealController.delegate = self;
    self.window.rootViewController = mainRevealController;
    [self.window makeKeyAndVisible];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    } else {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes: (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
    }
    
    [[KakaduClubData sharedKakaduClubData] loadKakaduClubData];
    
    [Fabric with:@[[Crashlytics class]]];

    return YES;
}

- (void)customizeNavigationAndSearchBar  {
    UIColor *color = [UIColor colorWithRed:0.196 green:0.4 blue:0.333 alpha:1];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBarTintColor:color];
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor whiteColor], NSForegroundColorAttributeName,
                                                           [UIFont fontWithName:KAKADU_FONT_NORMAL size:17.0], NSFontAttributeName, nil]];
    [[UISearchBar appearance] setBarTintColor:color];
    [[UISearchBar appearance] setTintColor:[UIColor whiteColor]];
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSString *tokenString = [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<"withString:@""]
                              stringByReplacingOccurrencesOfString:@">" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""];
    [[KakaduClubData sharedKakaduClubData] setDeviceToken:tokenString];
    
    UIDevice *device = [UIDevice currentDevice];
    NSString  *udid = [[device identifierForVendor] UUIDString];
    
    [[KakaduClubData sharedKakaduClubData] setDeviceUDID:udid];
    
    [[ServerManager sharedManager] pushNotificationPutWithDeviceUDIDToken:[NSString stringWithFormat:@"%@_%@", [KakaduClubData sharedKakaduClubData].deviceUDID, [KakaduClubData sharedKakaduClubData].deviceToken]];
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    NSLog(@"Failed to get token, error: %@", error);
}

- (void) application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    application.applicationIconBadgeNumber = 0;
    if ( application.applicationState == UIApplicationStateActive ) {
        
    } else {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        NewsFeedVC *newsFeedVC = [storyboard instantiateViewControllerWithIdentifier:@"NewsFeedVC"];
        newsFeedVC.newsID = [userInfo[@"id"] integerValue];
        SWRevealViewController *revealViewController = (SWRevealViewController *) self.window.rootViewController;
        UINavigationController *navigationVC =(UINavigationController *) revealViewController.frontViewController;
        [navigationVC setViewControllers:[NSArray arrayWithObject:newsFeedVC]];
    }
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    [[KakaduClubData sharedKakaduClubData] saveKakaduClubData];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    
    [[KakaduClubData sharedKakaduClubData] saveKakaduClubData];
}

@end
