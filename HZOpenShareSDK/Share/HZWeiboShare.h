//
//  HZWeiboShare.h
//  CommonUtil
//
//  Created by Hiram on 16/8/8.
//  Copyright © 2016年 Hiram. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HZShareObject.h"

@interface HZWeiboShare : NSObject


+ (instancetype)shareIntance;

+ (BOOL)handleOpenURL:(NSURL *)url;

+ (BOOL)registerApp:(NSString *)appKer redirectURL:(NSString *)url;

+ (BOOL)sendMessage:(HZShareObject *)shareObject controller:(UIViewController *)controller handler:(void(^)(HZSharePlatformType platform,BOOL success,NSError *error))handler;

@end
