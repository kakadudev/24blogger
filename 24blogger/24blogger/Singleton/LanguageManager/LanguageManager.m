//
//  LanguageManager.m
//  24blogger
//
//  Created by iZaVyLoN on 11/6/15.
//  Copyright © 2015 iZaVyLoN. All rights reserved.
//

#import "LanguageManager.h"

@interface LanguageManager()


@end

@implementation LanguageManager

+ (LanguageManager *)sharedLanguageManager {
    
    static LanguageManager *manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[LanguageManager alloc] init];
    });
    
    return manager;
}

- (instancetype) init {
    
    self = [super init];
    
    if (self) {
        
    }
    
    return self;
}

#pragma   

- (NSString *)getStringValueByKey:(NSString *)key {
    NSString *fileName = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"Localizable_%@", [self language]] ofType:@"strings"];
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:fileName];
    
    if ([dictionary objectForKey:key]) {
        return [dictionary objectForKey:key];
    } else {
        return @"";
    }
}

- (NSString *)language {
    return @"en";
}

@end













