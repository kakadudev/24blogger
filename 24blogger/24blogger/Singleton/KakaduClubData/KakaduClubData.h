//
//  KakaduClubData.h
//  24blogger
//
//  Created by iZaVyLoN on 11/6/15.
//  Copyright © 2015 iZaVyLoN. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface KakaduClubData : NSObject

#pragma Settings

// Notification
@property (nonatomic, assign) BOOL isNotification;

// Device Token
@property (nonatomic, strong) NSString *deviceToken;

// Device UDID
@property (nonatomic, strong) NSString *deviceUDID;

// DNCellText;
// Title text or Descriprion text;
@property (nonatomic, assign) BOOL isTitleDNCellText;

// Favorites
@property (nonatomic, strong) NSMutableArray *favoritesArray;
@property (nonatomic, strong) NSMutableArray *favoritesID;

+ (KakaduClubData *)sharedKakaduClubData;

- (BOOL)saveKakaduClubData;
- (void)loadKakaduClubData;

@end
