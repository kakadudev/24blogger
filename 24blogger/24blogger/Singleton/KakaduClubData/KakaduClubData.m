//
//  KakaduClubData.h
//  24blogger
//
//  Created by iZaVyLoN on 11/6/15.
//  Copyright © 2015 iZaVyLoN. All rights reserved.
//


#import "KakaduClubData.h"

#define KAKADU_CLUB_DATA_KEY @"KAKADU_CLUB_DATA_KEY"

@implementation KakaduClubData

static KakaduClubData * sharedInstance = nil;

+ (KakaduClubData *)sharedKakaduClubData {
    
    static dispatch_once_t once_token = 0;
    
    dispatch_once(&once_token, ^{
        sharedInstance =  [[self alloc] init];
        
        sharedInstance.isNotification = YES;
        sharedInstance.favoritesArray = [[NSMutableArray alloc] init];
        sharedInstance.favoritesID= [[NSMutableArray alloc] init];

    });
    
    return sharedInstance ;
}

- (id)initWithCoder:(NSCoder *)coder {
    KakaduClubData *instance = [KakaduClubData sharedKakaduClubData];
    
    // Notification
    [instance setIsNotification:[coder decodeBoolForKey:@"setIsNotification"]];
    
    // Device Token
    [instance setDeviceToken:[coder decodeObjectForKey:@"setDeviceToken"]];
    
    // Device UDID
    [instance setDeviceUDID:[coder decodeObjectForKey:@"setDeviceUDID"]];

    // DNCellText
    [instance setIsTitleDNCellText:[coder decodeBoolForKey:@"setIsTitleDNCellText"]];
    
    // Favorites
    [instance setFavoritesArray:[coder decodeObjectForKey:@"setFavoritesArray"]];
    [instance setFavoritesID:[coder decodeObjectForKey:@"setFavoritesID"]];
    
    return instance;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    KakaduClubData *instance = [KakaduClubData sharedKakaduClubData];

    // Notification
    [coder encodeBool:[instance isNotification] forKey:@"setIsNotification"];
    
    // Device Token
    [coder encodeObject:[instance deviceToken] forKey:@"setDeviceToken"];
    
    // Device UDID
    [coder encodeObject:[instance deviceUDID] forKey:@"setDeviceUDID"];
    
    // DNCellText
    [coder encodeBool:[instance isTitleDNCellText] forKey:@"setIsTitleDNCellText"];
    
    // Favorites
    [coder encodeObject:[instance favoritesArray] forKey:@"setFavoritesArray"];
    [coder encodeObject:[instance favoritesID] forKey:@"setFavoritesID"];
}

- (BOOL)saveKakaduClubData {
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:[KakaduClubData sharedKakaduClubData]] forKey:KAKADU_CLUB_DATA_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    return YES;
}

- (void)loadKakaduClubData {
    [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:KAKADU_CLUB_DATA_KEY]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
