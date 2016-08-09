//
//  HZTencentShare.h
//  HZOpenShare
//
//  Created by Hiram on 16/8/9.
//  Copyright © 2016年 张洋. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "HZShareObject.h"

@interface HZTencentShare : NSObject

+ (instancetype)shareIntance;

+ (BOOL)handleOpenURL:(NSURL *)url;

+ (BOOL)registerApp:(NSString *)appKey redirectURL:(NSString *)url;

+ (BOOL)sendMessage:(HZShareObject *)shareObject controller:(UIViewController *)controller handler:(void(^)(HZSharePlatformType platform,BOOL success,NSError *error))handler;

@end
