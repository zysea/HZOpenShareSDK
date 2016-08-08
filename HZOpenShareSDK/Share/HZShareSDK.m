//
//  HZShareSDK.m
//  CommonUtil
//
//  Created by 张洋 on 16/8/8.
//  Copyright © 2016年 Hiram. All rights reserved.
//

#import "HZShareSDK.h"
#import "HZWechatShare.h"
#import "HZWeiboShare.h"


@implementation HZShareSDK

+ (BOOL)handleOpenURL:(NSURL *)url
{
    BOOL weChat_flag = [HZWechatShare handleOpenURL:url];
    if (weChat_flag) {
        return weChat_flag;
    }
    BOOL weibo_flag = [HZWeiboShare handleOpenURL:url];
    if (weibo_flag) {
        return weibo_flag;
    }
    return NO;
}

+ (BOOL)sendMessage:(HZShareObject *)shareObject controller:(UIViewController *)controller handler:(void (^)(HZSharePlatformType, BOOL, NSError *))handler
{
    BOOL isSuccess = NO;
    switch (shareObject.platformType) {
        case HZSharePlatformWeibo:
            isSuccess = [HZWeiboShare sendMessage:shareObject controller:controller handler:handler];
            break;
        case HZSharePlatformQQ:
        case HZSharePlatformQZone:
            isSuccess = [HZWeiboShare sendMessage:shareObject controller:controller handler:handler];
            break;
        case HZSharePlatformWechatSession:
        case HZSharePlatformWechatTimeLine:
        case HZSharePlatformWechatFavorite:
            isSuccess = [HZWechatShare sendObject:shareObject handle:handler];
            break;
        default:
            break;
    }
    return isSuccess;
}
@end
