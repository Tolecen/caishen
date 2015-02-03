//
//  ShareServe.h
//  TalkingPet
//
//  Created by wangxr on 14-8-15.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ShareSDK/ShareSDK.h>
#import "WXApi.h"

#define SHAREBASEURL @"http://www.uzero.cn/caishen/index.html"

@interface ShareServe : NSObject
+(void)buildShareSDK;

+(void)shareToFriendCircleWithTitle:(NSString*)title Content:(NSString*)content imageUrl:(NSString*)url webUrl:(NSString*)web Succeed:(void (^)())success;
+(void)shareToWeixiFriendWithTitle:(NSString*)title Content:(NSString*)content imageUrl:(NSString*)url webUrl:(NSString*)web Succeed:(void (^)())succes;


@end
