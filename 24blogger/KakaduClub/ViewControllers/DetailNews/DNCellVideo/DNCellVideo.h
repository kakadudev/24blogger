//
//  DNCellVideo.h
//  KakaduClub
//
//  Created by Sytsevich Dmitry on 11/16/15.
//  Copyright © 2015 iZaVyLoN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DNCellVideo : UITableViewCell <UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *youTubeView;
@property (strong, nonatomic) NSString *urlVideo;

@end
