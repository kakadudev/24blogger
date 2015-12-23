//
//  NewsFeedVC.h
//  24blogger
//
//  Created by iZaVyLoN on 11/2/15.
//  Copyright © 2015 iZaVyLoN. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    KakaduClubTypeFeed = 0,
    KakaduClubTypeNews,
    KakaduClubTypeReviews,
    KakaduClubEvents
} KakaduClubType;


@interface NewsFeedVC : UIViewController

@property (nonatomic, assign) KakaduClubType kakaduClubType;
@property (nonatomic, assign) NSInteger newsID;

@end
