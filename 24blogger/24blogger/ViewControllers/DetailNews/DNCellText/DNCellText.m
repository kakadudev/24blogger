//
//  DNCellText.m
//  24blogger
//
//  Created by Sytsevich Dmitry on 11/16/15.
//  Copyright © 2015 iZaVyLoN. All rights reserved.
//

#import "DNCellText.h"

@implementation DNCellText

@synthesize textType = _textType;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code.
        
		_textType = [DNCellText textLabel];
        
		[self.contentView addSubview:_textType];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return self;
}

- (void)layoutSubviews {
	[super layoutSubviews];
    
	CGSize optimumSizeFirst = [self.textType optimumSize];
	CGRect frameFirst = [self.textType frame];
	frameFirst.size.height = (int)optimumSizeFirst.height;
	[self.textType setFrame:frameFirst];
}

+ (RTLabel*)textLabel {
    RTLabel *textLabel = [[RTLabel alloc] initWithFrame:CGRectMake(10.0f, 0.0f, [[UIScreen mainScreen] bounds].size.width - 20.0f, 100.0f)];
    [textLabel setFont:[UIFont fontWithName:KAKADU_FONT_NORMAL size:15.0f]];
    [textLabel setTextAlignment:RTTextAlignmentLeft];
    [textLabel setParagraphReplacement:@"\n"];
    return textLabel;
}

@end
