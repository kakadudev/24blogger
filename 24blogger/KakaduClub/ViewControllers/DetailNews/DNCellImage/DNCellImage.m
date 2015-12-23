//
//  DNCellImage.m
//  KakaduClub
//
//  Created by Sytsevich Dmitry on 11/16/15.
//  Copyright © 2015 iZaVyLoN. All rights reserved.
//

#import "DNCellImage.h"

@implementation DNCellImage

@synthesize imagePhoto = _imagePhoto;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code.
        
        _imagePhoto = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.width * IMAGE_FACTOR_FOR_HEIGHT)];
        [_imagePhoto setContentMode:UIViewContentModeScaleAspectFit];
        [self.contentView addSubview:_imagePhoto];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state.
}

@end
