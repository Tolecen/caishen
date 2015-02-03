//
//  ShareServe.m
//  TalkingPet
//
//  Created by wangxr on 14-8-15.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import "ShareServe.h"
#import "SVProgressHUD.h"

@implementation ShareServe
+(void)buildShareSDK
{
    [ShareSDK registerApp:@"2f37350b8994"];

    
//    [ShareSDK connectQQWithAppId:@"1102327672" qqApiCls:[QQApi class]];

    /**
     连接微信应用以使用相关功能，此应用需要引用WeChatConnection.framework和微信官方SDK
     http://open.weixin.qq.com上注册应用，并将相关信息填写以下字段
     **/
    [ShareSDK connectWeChatWithAppId:@"wxb62f795f2bc6b770" wechatCls:[WXApi class]];
}
+(void)shareToFriendCircleWithTitle:(NSString*)title Content:(NSString*)content imageUrl:(NSString*)url webUrl:(NSString*)web Succeed:(void (^)())success
{
    id<ISSContent> publishContent = [ShareSDK content:content
                                       defaultContent:nil
                                                image:url?[ShareSDK imageWithUrl:url]:nil
                                                title:title
                                                  url:web
                                          description:nil
                                            mediaType:SSPublishContentMediaTypeNews];
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:YES
                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
                                                          viewDelegate:nil
                                               authManagerViewDelegate:nil];
    [ShareSDK shareContent:publishContent
                      type:ShareTypeWeixiTimeline
               authOptions:authOptions
             statusBarTips:NO
                    result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                        if (state == SSResponseStateBegan) {
                            [SVProgressHUD showWithStatus:@"正在分享,请稍后"];
                        }
                        if (state == SSResponseStateCancel)
                        {
                            [SVProgressHUD dismiss];
                        }
                        if (state == SSResponseStateSuccess) {
                            [SVProgressHUD showSuccessWithStatus:@"分享成功"];
                            if (success) {
                                success();
                            }
                        }
                        if (state == SSResponseStateFail) {
                            [SVProgressHUD dismiss];
                            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"  message:[NSString stringWithFormat:@"发送失败!%@", [error errorDescription]] delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
                            [alertView show];
                        }
                    }];
}
+(void)shareToWeixiFriendWithTitle:(NSString*)title Content:(NSString*)content imageUrl:(NSString*)url webUrl:(NSString*)web Succeed:(void (^)())success
{
    id<ISSContent> publishContent = [ShareSDK content:content
                                       defaultContent:nil
                                                image:url?[ShareSDK imageWithUrl:url]:nil
                                                title:title
                                                  url:web
                                          description:nil
                                            mediaType:SSPublishContentMediaTypeNews];
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:YES
                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
                                                          viewDelegate:nil
                                               authManagerViewDelegate:nil];
    [ShareSDK shareContent:publishContent
                      type:ShareTypeWeixiSession
               authOptions:authOptions
             statusBarTips:NO
                    result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                        if (state == SSResponseStateBegan) {
                            [SVProgressHUD showWithStatus:@"正在分享,请稍后"];
                        }
                        if (state == SSResponseStateCancel)
                        {
                            [SVProgressHUD dismiss];
                        }
                        if (state == SSResponseStateSuccess) {
                            
                            [SVProgressHUD showSuccessWithStatus:@"分享成功"];
                            if (success) {
                                success();
                            }
                        }
                        if (state == SSResponseStateFail) {
                            [SVProgressHUD dismiss];
                            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"  message:[NSString stringWithFormat:@"发送失败!%@", [error errorDescription]] delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
                            [alertView show];
                        }
                    }];
}
@end
