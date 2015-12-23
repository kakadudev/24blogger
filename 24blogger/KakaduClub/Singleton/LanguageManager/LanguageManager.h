//
//  LanguageManager.h
//  KakaduClub
//
//  Created by iZaVyLoN on 11/6/15.
//  Copyright © 2015 iZaVyLoN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LanguageManager : NSObject

+ (LanguageManager *)sharedLanguageManager;

// Get string value by key from *.string file;
- (NSString *)getStringValueByKey:(NSString *)key;

@end







