//
//  HZWeiChat.h
//  CommonUtil
//
//  Created by Hiram on 16/8/6.
//  Copyright © 2016年 Hiram. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HZShareObject.h"


@interface HZWechatShare : NSObject
+ (instancetype)shareInteface;
+(BOOL)handleOpenURL:(NSURL *)url;

+(BOOL)registerApp:(NSString *)appKey;

+(BOOL)sendObject:(HZShareObject *)object handle:(void(^)(HZSharePlatformType platform,BOOL success,NSError *error))handler;
@end
