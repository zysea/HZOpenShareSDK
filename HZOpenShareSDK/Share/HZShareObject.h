//
//  HZShareObject.h
//  CommonUtil
//
//  Created by Hiram on 16/8/6.
//  Copyright © 2016年 Hiram. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,HZSharePlatformType) {
    HZSharePlatformWeibo                            ,               // 微博
    HZSharePlatformQQ                               ,               // QQ好友
    HZSharePlatformQZone                            ,               // QQ空间
    HZSharePlatformWechatSession                    ,               // 微信朋友
    HZSharePlatformWechatTimeLine                   ,               // 微信朋友圈
    HZSharePlatformWechatFavorite                   ,               // 微信收藏
};

typedef NS_ENUM(NSInteger,HZShareMessageType) {
   HZShareMessageText,
   HZShareMessageImage,
   HZShareMessageGifImage,              // 微信区分
   HZShareMessageVideo,                 // 视频 设置URLStr
   HZShareMessageMusic,                 // 音频 设置URLStr
   HZShareMessageWebpage,               // 网页 设置URLStr
   HZShareMessageFile,
   HZShareMessageApp,                   // 微信处理
   HZShareMessagetEmoticon,              // 微信表情
};

typedef void(^HZShareHandler)(HZSharePlatformType platform,BOOL success,NSError *error);


@interface HZShareObject : NSObject

@property (nonatomic ,strong)NSString *objectId; // 必须(帖子id)
@property (nonatomic ,strong)NSString *title;    // (分享标题，除了文本发送，必须 )
@property (nonatomic ,retain)NSString *description; // 必须 (描述，除了文本发送，必须)
@property (nonatomic ,strong)NSString *text;  // (内容，发送text使用，必须)
@property (nonatomic ,strong)NSString *URLStr;
@property (nonatomic ,strong)UIImage  *thumbImage;  // 必须
@property (nonatomic ,strong)NSString *musicDataUrl;
@property (nonatomic ,strong)NSData   *data; // 图片二进制数据 （微信表情使用）
@property (nonatomic ,assign)HZSharePlatformType  platformType;
@property (nonatomic ,assign)HZShareMessageType  messageType;
@property (nonatomic ,strong)NSString  *from;
@property (nonatomic ,strong)UIViewController  *controller; // 分享所在页面

+(instancetype)object;


@end

