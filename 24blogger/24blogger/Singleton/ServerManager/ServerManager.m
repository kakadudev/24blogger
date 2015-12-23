//
//  ServerManager.m
//  24blogger
//
//  Created by iZaVyLoN on 11/6/15.
//  Copyright © 2015 iZaVyLoN. All rights reserved.
//

#import "ServerManager.h"

#define KAKADU_URL @"http://kakadu.club"

@interface ServerManager()

@property (strong, nonatomic) AFHTTPRequestOperationManager *requestOperationManager;

@end

@implementation ServerManager

+ (ServerManager *) sharedManager {
    
    static ServerManager *manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ServerManager alloc] init];
    });
    
    return manager;
}

- (instancetype) init {
    
    self = [super init];
    
    if (self) {
        NSURL *url = [NSURL URLWithString:KAKADU_URL];
        self.requestOperationManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:url];
    }
    
    return self;
}

#pragma mark - Get API

- (void)getFeedJsonCount:(NSInteger)count
                    page:(NSInteger)offset
               onSuccess:(void(^)(NSDictionary *dictionary)) success
               onFailure:(void(^)(NSError *error,NSInteger statusCode)) failure {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    self.requestOperationManager.responseSerializer = [AFJSONResponseSerializer serializer];
    [self.requestOperationManager GET:[NSString stringWithFormat:@"?json=get_recent_posts&page=%ld&count=%ld", (long)offset, (long)count]
                           parameters:nil
                              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                  
                                  NSDictionary *dictionary = responseObject;
                                  success(dictionary);
                                  [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];                                  
                              } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                  
                                  if (failure) {
                                      NSLog(@"%@",[error description]);
                                      failure(error,operation.response.statusCode);
                                      [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                                  }
                                  
                              }];
}

- (void)getFeedNewstJsonType:(NSString *)type
                       count:(NSInteger)count
                        page:(NSInteger)offset
                   onSuccess:(void(^)(NSDictionary *dictionary)) success
                   onFailure:(void(^)(NSError *error,NSInteger statusCode)) failure {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    self.requestOperationManager.responseSerializer = [AFJSONResponseSerializer serializer];
    [self.requestOperationManager GET:[NSString stringWithFormat:@"?json=get_category_posts&slug=%@&page=%ld&count=%ld", type, (long)offset, (long)count]
                           parameters:nil
                              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                  
                                  NSDictionary *dictionary = responseObject;
                                  success(dictionary);
                                  [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                              } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                  
                                  if (failure) {
                                      NSLog(@"%@",[error description]);
                                      failure(error,operation.response.statusCode);
                                      [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                                  }
                                  
                              }];
}

- (void)getDetailNewsWithID:(NSInteger)newsID
                  onSuccess:(void(^)(NSDictionary *dictionary)) success
                  onFailure:(void(^)(NSError *error,NSInteger statusCode)) failure {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    self.requestOperationManager.responseSerializer = [AFJSONResponseSerializer serializer];
    [self.requestOperationManager GET:[NSString stringWithFormat:@"?json=get_post&post_id=%ld", (long)newsID]
                           parameters:nil
                              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                  
                                  NSDictionary *dictionary = responseObject;
                                  success(dictionary);
                                  [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                              } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                  
                                  if (failure) {
                                      NSLog(@"%@",[error description]);
                                      failure(error,operation.response.statusCode);
                                      [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                                  }
                                  
                              }];
}

- (void)getSearchNewsWithSlug:(NSString *)slug
                   searchText:(NSString *)searchText
                    onSuccess:(void(^)(NSDictionary *dictionary)) success
                    onFailure:(void(^)(NSError *error,NSInteger statusCode)) failure {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    self.requestOperationManager.responseSerializer = [AFJSONResponseSerializer serializer];
    [self.requestOperationManager GET:[NSString stringWithFormat:@"?json=get_search_results&slug=%@&search=%@", slug, searchText]
                           parameters:nil
                              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                  
                                  NSDictionary *dictionary = responseObject;
                                  success(dictionary);
                                  [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                              } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                  
                                  if (failure) {
                                      NSLog(@"%@",[error description]);
                                      failure(error,operation.response.statusCode);
                                      [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                                  } 
                              }];
}

#pragma mark - Post API

- (void)pushNotificationPutWithDeviceUDIDToken:(NSString *)deviceUDIDToken {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    NSString *pathURL = [NSString stringWithFormat:@"%@/zaki-push-notification/put/token/%@", KAKADU_URL, deviceUDIDToken];
    self.requestOperationManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [self.requestOperationManager POST:pathURL
                            parameters:nil
                               success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                   [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                               } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                   NSLog(@"%@", error);
                                   [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                               }];
}

- (void)pushNotificationDeleteWithDeviceUDIDToken:(NSString *)deviceUDIDToken {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    NSString *pathURL = [NSString stringWithFormat:@"%@/zaki-push-notification/delete/token/%@", KAKADU_URL, deviceUDIDToken];
    
    self.requestOperationManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [self.requestOperationManager POST:pathURL
                            parameters:nil
                               success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                   [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                               } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                   NSLog(@"%@", error);
                                   [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                               }];
}

@end

