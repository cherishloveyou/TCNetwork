//
//  DoubanRequestCenter.m
//  TCHTTPRequestDemo
//
//  Created by cdk on 15/4/9.
//  Copyright (c) 2015年 dake. All rights reserved.
//

#import "DoubanRequestCenter.h"

static NSString *const kHost = @"https://api.douban.com/v2/";

@implementation DoubanRequestCenter

+ (instancetype)defaultCenter
{
    static DoubanRequestCenter *s_defaultCenter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_defaultCenter = [[self alloc] initWithBaseURL:[NSURL URLWithString:kHost]];
    });
    
    return s_defaultCenter;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.timeoutInterval = 90.0f;
        // You can set urlFilter delegate here to self, or other.
        // self.urlFilter = self;
    }
    return self;
}

- (TCHTTPRequest *)fetchBookInfoForID:(NSString *)bookID beforeRun:(void(^)(TCHTTPRequest *request))beforeRun
{
    if (nil == bookID || bookID.length < 1) {
        return nil;
    }
    
    NSString *apiUrl = [@"book/" stringByAppendingString:bookID];
    TCHTTPRequest *request = [self cacheRequestWithMethod:kTCHTTPRequestMethodGet apiUrl:apiUrl host:nil];
    if (nil != beforeRun) {
        beforeRun(request);
    }
    request.parameters = @{@"fields": @"id,title,url"};
    request.cacheTimeoutInterval = 10 * 60;
    request.shouldExpiredCacheValid = NO;
    return [request start:NULL] ? request : nil;
}

- (TCHTTPRequest *)searchBookListForKeyword:(NSString *)keyword beforeRun:(void(^)(TCHTTPRequest *request))beforeRun
{
    if (nil == keyword || keyword.length < 1) {
        return nil;
    }
    
    TCHTTPRequest *request = [self requestWithMethod:kTCHTTPRequestMethodGet apiUrl:@"book/search" host:nil];
    if (nil != beforeRun) {
        beforeRun(request);
    }
    request.parameters = @{@"q": keyword,
                           @"fields": @"id,title,url"};
    return [request start:NULL] ? request : nil;
}

@end
