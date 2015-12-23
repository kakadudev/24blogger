//
//  ServerManager.h
//  KakaduClub
//
//  Created by iZaVyLoN on 11/6/15.
//  Copyright © 2015 iZaVyLoN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "CoreDataManager.h"

@interface ServerManager : NSObject

+(ServerManager *) sharedManager;

#pragma GET method

// Get Feed; All Type
- (void)getFeedJsonCount:(NSInteger)count
                        page:(NSInteger)offset
                   onSuccess:(void(^)(NSDictionary *dictionary)) success
                   onFailure:(void(^)(NSError *error,NSInteger statusCode)) failure;

// Get Feed by type:
//   - news
//   - review
//   - events
- (void)getFeedNewstJsonType:(NSString *)type
                   count:(NSInteger)count
                  page:(NSInteger)offset
               onSuccess:(void(^)(NSDictionary *dictionary)) success
               onFailure:(void(^)(NSError *error,NSInteger statusCode)) failure;

// Get Detail News
- (void)getDetailNewsWithID:(NSInteger)newsID
               onSuccess:(void(^)(NSDictionary *dictionary)) success
               onFailure:(void(^)(NSError *error,NSInteger statusCode)) failure;

// Get Search News
- (void)getSearchNewsWithSlug:(NSString *)slug
                   searchText:(NSString *)searchText
                  onSuccess:(void(^)(NSDictionary *dictionary)) success
                  onFailure:(void(^)(NSError *error,NSInteger statusCode)) failure;

#pragma POST method

// Push Notification Put
- (void)pushNotificationPutWithDeviceUDIDToken:(NSString *)deviceUDIDToken;

// Push Notification Delete
- (void)pushNotificationDeleteWithDeviceUDIDToken:(NSString *)deviceUDIDToken;

@end







