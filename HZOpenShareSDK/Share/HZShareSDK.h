//
//  HZShareSDK.h
//  CommonUtil
//
//  Created by 张洋 on 16/8/8.
//  Copyright © 2016年 Hiram. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HZShareObject.h"

@interface HZShareSDK : NSObject

+ (BOOL)handleOpenURL:(NSURL *)url;

+ (BOOL)sendMessage:(HZShareObject *)shareObject controller:(UIViewController *)controller handler:(void(^)(HZSharePlatformType platform,BOOL success,NSError *error))handler;

@end
