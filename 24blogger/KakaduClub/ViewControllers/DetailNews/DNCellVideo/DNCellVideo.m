//
//  DNCellVideo.m
//  KakaduClub
//
//  Created by Sytsevich Dmitry on 11/16/15.
//  Copyright © 2015 iZaVyLoN. All rights reserved.
//

#import "DNCellVideo.h"
#import "SDImageCache.h"

@implementation DNCellVideo

@synthesize youTubeView = _youTubeView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code.
        
        _youTubeView = [[UIWebView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.contentView.frame.size.width, self.contentView.frame.size.width * VIDEO_FACTOR_FOR_HEIGHT)];
        _youTubeView.scrollView.scrollEnabled = NO;
        _youTubeView.scrollView.bounces = NO;
        
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self.contentView addSubview:_youTubeView];
            });
        });
        
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return self;
}

- (void)layoutSubviews
{
	[super layoutSubviews];

    if (!_youTubeView.isLoading && _urlVideo != nil) {
        [self playVideoWithId:[self extractYoutubeIdFromLink:_urlVideo]];
    }
}

- (void)playVideoWithId:(NSString *)videoId {
    
    NSString *youTubeVideoHTML = @"<html><head><style>body{margin:0px 0px 0px 0px;}</style></head> <body> <div id=\"player\"></div> <script> var tag = document.createElement('script'); tag.src = 'http://www.youtube.com/player_api'; var firstScriptTag = document.getElementsByTagName('script')[0]; firstScriptTag.parentNode.insertBefore(tag, firstScriptTag); var player; function onYouTubePlayerAPIReady() { player = new YT.Player('player', { width:'320', height:'200', videoId:'%@', events: { 'onReady': onPlayerReady } }); } function onPlayerReady(event) {  } </script> </body> </html>";
    
    
    NSString *html = [NSString stringWithFormat:youTubeVideoHTML, videoId];
    
    _youTubeView.backgroundColor = [UIColor clearColor];
    _youTubeView.opaque = NO;
    _youTubeView.delegate = self;
    _youTubeView.mediaPlaybackRequiresUserAction = NO;
    
    [_youTubeView loadHTMLString:html baseURL:nil];
}
- (NSString *)extractYoutubeIdFromLink:(NSString *)link {
    
    NSString *regexString = @"((?<=(v|V)/)|(?<=be/)|(?<=(\\?|\\&)v=)|(?<=embed/))([\\w-]++)";
    NSRegularExpression *regExp = [NSRegularExpression regularExpressionWithPattern:regexString
                                                                            options:NSRegularExpressionCaseInsensitive
                                                                              error:nil];
    
    NSArray *array = [regExp matchesInString:link options:0 range:NSMakeRange(0,link.length)];
    if (array.count > 0) {
        NSTextCheckingResult *result = array.firstObject;
        return [link substringWithRange:result.range];
    }
    return nil;
}

@end
