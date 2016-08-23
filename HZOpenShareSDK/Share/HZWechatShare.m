//
//  HZWeiChat.m
//  CommonUtil
//
//  Created by Hiram on 16/8/6.
//  Copyright © 2016年 Hiram. All rights reserved.
//

#import "HZWechatShare.h"


@interface HZWechatShare ()
{
@private
    void(^_handler)(HZSharePlatformType platform,BOOL success,NSError *error);
}
@property (nonatomic ,strong) HZShareHandler hander;
@property (nonatomic ,strong) HZShareObject *shareObject;
@property (nonatomic ,assign) int scene;

@end

@implementation HZWechatShare



id createMediaObject(NSString *className)
{
    Class class = NSClassFromString(className);
    SEL objetInit = NSSelectorFromString(@"object");
    IMP imp = [class methodForSelector:objetInit];
    id(*create)(id,SEL) = (id(*)(id,SEL))imp;
    id intance = create(class,objetInit);
    return intance;
}

id createMediaMessage(HZShareObject *shareObject)
{
    Class WXMediaMessage = NSClassFromString(@"WXMediaMessage");
    SEL seletor = NSSelectorFromString(@"message");
    IMP imp= [WXMediaMessage methodForSelector:seletor];
    id(*creatMessage)(id,SEL);
    creatMessage = (id(*)(id,SEL))imp;
    id message = creatMessage(WXMediaMessage,seletor);
    SEL setThumImage_selector = NSSelectorFromString(@"setThumbImage:");
    IMP imp_setThumImage = [message methodForSelector:setThumImage_selector];
    void (*setThumImage)(id,SEL,UIImage *image) = (void(*)(id,SEL,UIImage *))imp_setThumImage;
    setThumImage(message,setThumImage_selector,shareObject.thumbImage);
    return message;
}


+ (instancetype)shareInteface
{
    static HZWechatShare *chat = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        chat = [[HZWechatShare alloc]init];
    });
    return chat;
}

+(BOOL)registerApp:(NSString *)appKey
{
    Class class = NSClassFromString(@"WXApi");
    SEL selector = NSSelectorFromString(@"registerApp:");
    IMP imp = [class methodForSelector:selector];
    BOOL (*func)(id,SEL,NSString *);
    func = (BOOL(*)(id,SEL,NSString *))imp;
    BOOL flag = func(class,selector,appKey);
    return flag;
}

+ (BOOL)handleOpenURL:(NSURL *)url
{
    return [[self shareInteface] handleOpenURL:url];
}

+ (BOOL)sendObject:(HZShareObject *)object handle:(void (^)(HZSharePlatformType, BOOL, NSError *))handler
{
    [[self shareInteface] setHander:handler];
    return [[self shareInteface] sendObject:object handle:handler];
}

- (BOOL)sendObject:(HZShareObject *)object handle:(void (^)(HZSharePlatformType, BOOL, NSError *))handler
{
    BOOL isSuccess = NO;
    if (object.platformType == HZSharePlatformWechatSession) {
        self.scene = 0;
    } else if (object.platformType == HZSharePlatformWechatTimeLine){
        self.scene = 1;
    } else {
        self.scene = 2;
    }
    switch (object.messageType) {
        case HZShareMessageText:
            isSuccess = [self sendTextContent:object];
            break;
        case HZShareMessageImage:
            isSuccess = [self sendImageContent:object];
            break;
        case HZShareMessageGifImage:
        case HZShareMessagetEmoticon:
            isSuccess = [self sendImageContent:object];
            break;
        case HZShareMessageMusic:
            isSuccess = [self sendMusicContent:object];
            break;
        case HZShareMessageVideo:
            isSuccess = [self sendVideoContent:object];
            break;
        case HZShareMessageWebpage:
            isSuccess = [self sendWebContent:object];
            break;
        case HZShareMessageApp:
            isSuccess = [self sendFileContent:object];
            break;
        case HZShareMessageFile:
            isSuccess = [self sendFileContent:object];
            break;
            
        default:
            break;
    }
    return isSuccess;
}

- (BOOL) sendTextContent:(HZShareObject *)object
{
    return [self sendMessage:object.description bText:YES];
}

- (BOOL) sendImageContent:(HZShareObject *)object
{
    id message = createMediaMessage(object);
    
    id wxImageObject = createMediaObject(@"WXImageObject");
    
    if (object.data) {
        [wxImageObject setValue:object.data forKey:@"imageData"];
    }
    
    if (object.URLStr) {
        [wxImageObject setValue:object.URLStr forKey:@"imageUrl"];
    }
    [message setValue:wxImageObject forKey:@"mediaObject"];
    
    return [self sendMessage:message bText:NO];
    
}

- (BOOL)sendEmoticonContent:(HZShareObject*)shareObject
{
    id message = createMediaMessage(shareObject);
    
    id wxGifObject = createMediaObject(@"WXEmoticonObject");
    
    [wxGifObject setValue:shareObject.data forKey:@"emoticonData"];
    
    [message setValue:wxGifObject forKey:@"mediaObject"];
    
    return [self sendMessage:message bText:NO];
}

- (BOOL)sendMusicContent:(HZShareObject *)shareObject
{
    id ext = createMediaObject(@"WXMusicObject");
    [ext setValue:shareObject.URLStr forKey:@"musicUrl"];
    [ext setValue:shareObject.musicDataUrl forKey:@"musicUrl"];
    
    id message =  createMediaMessage(shareObject);
    [message setValue:shareObject.title forKey:@"title"];
    [message setValue:shareObject.description forKey:@"description"];
    [message setValue:ext forKey:@"mediaObject"];
    return [self sendMessage:message bText:NO];
}

- (BOOL)sendVideoContent:(HZShareObject *)shareObject
{
    id ext = createMediaObject(@"WXVideoObject");
    [ext setValue:shareObject.URLStr forKey:@"videoUrl"];
    
    id message =  createMediaMessage(shareObject);
    [message setValue:shareObject.title forKey:@"title"];
    [message setValue:shareObject.description forKey:@"description"];
    [message setValue:ext forKey:@"mediaObject"];
    return [self sendMessage:message bText:NO];
}

- (BOOL)sendFileContent:(HZShareObject *)shareObject
{
    id ext = createMediaObject(@"WXFileObject");
    [ext setValue:shareObject.URLStr forKey:@"videoUrl"];
    NSString *extension = [shareObject.URLStr pathExtension];
    [ext setValue:extension forKey:@"fileExtension"];
    NSURL *url = [NSURL URLWithString:shareObject.URLStr];
    NSData *data = [NSData dataWithContentsOfURL:url];
    [ext setValue:data forKey:@"fileData"];
    
    id message = createMediaMessage(shareObject);
    [message setValue:shareObject.title forKey:@"title"];
    [message setValue:shareObject.title forKey:@"description"];
    [message setValue:ext forKey:@"mediaObject"];
    
    return [self sendMessage:message bText:NO];
}

- (BOOL)sendWebContent:(HZShareObject *)shareObject
{
    id ext = createMediaObject(@"WXWebpageObject");
    [ext setValue:shareObject.URLStr forKey:@"webpageUrl"];

    id message =  createMediaMessage(shareObject);
    [message setValue:shareObject.title forKey:@"title"];
    [message setValue:shareObject.description forKey:@"description"];
    [message setValue:ext forKey:@"mediaObject"];


    return [self sendMessage:message bText:NO];
    
}


- (BOOL)sendMessage:(id)message bText:(BOOL)bText
{
    Class class = NSClassFromString(@"SendMessageToWXReq");
    id instance = [[class alloc]init];
    
    if (bText) {
        [instance setValue:message forKey:@"text"];
    } else {
        [instance setValue:message forKey:@"message"];
    }
    [instance setValue:@(bText) forKey:@"bText"];
    [instance setValue:@(self.scene) forKey:@"scene"];
    
    Class wxApi = NSClassFromString(@"WXApi");
    SEL selector = NSSelectorFromString(@"sendReq:");
    IMP imp = [wxApi methodForSelector:selector];
    BOOL(*func)(id,SEL,id);
    func = (BOOL (*)(id,SEL,id))imp;
    BOOL flag = func(wxApi,selector,instance);
    return flag;
}

- (BOOL)handleOpenURL:(NSURL *)url
{
    Class class = NSClassFromString(@"WXApi");
    if (class == nil) {
        return NO;
    }
    SEL selector = NSSelectorFromString(@"handleOpenURL:delegate:");
    IMP imp = [class methodForSelector:selector];
    BOOL (*func)(id,SEL,NSURL*,id);
    func = (BOOL(*)(id,SEL,NSURL*,id))imp;
    BOOL flag = func(class,selector,url,self);
    return flag;
}

-(void) onReq:(id)req
{
//    NSLog(@"req %@",req);
}
-(void) onResp:(id)resp
{
    SEL selector = NSSelectorFromString(@"errCode");
    IMP imp = [resp methodForSelector:selector];
    NSInteger (*func)(id,SEL);
    func = (NSInteger(*)(id,SEL))imp;
    NSInteger code = func(resp,selector);
    switch (code) {
        case 0:{
            if (_handler) {
                _handler(self.shareObject.platformType,YES,nil);
                break;
            }
        }
        case -1:{
            if (_handler) {
                NSError *error = [NSError errorWithDomain:@"分享失败" code:-1 userInfo:@{@"msg":@"分享失败",@"code":@"-1"}];
                _handler(self.shareObject.platformType,NO,error);
                break;
            }
        }
        case -2:{
            if (_handler) {
                NSError *error = [NSError errorWithDomain:@"分享失败" code:-2 userInfo:@{@"msg":@"分享失败",@"code":@"-2"}];
                _handler(self.shareObject.platformType,NO,error);
                break;
            }
        }
        case -3:{
            if (_handler) {
                NSError *error = [NSError errorWithDomain:@"分享失败" code:-3 userInfo:@{@"msg":@"分享失败",@"code":@"-3"}];
                _handler(self.shareObject.platformType,NO,error);
                break;
            }
        }
        case -4:{
            if (_handler) {
                NSError *error = [NSError errorWithDomain:@"授权失败" code:-4 userInfo:@{@"msg":@"分享失败",@"code":@"-4"}];
                _handler(self.shareObject.platformType,NO,error);
                break;
            }
        }
        case -5:{
            if (_handler) {
                NSError *error = [NSError errorWithDomain:@"不支持分享" code:-5 userInfo:@{@"msg":@"不支持分享",@"code":@"-4"}];
                _handler(self.shareObject.platformType,NO,error);
                break;
            }
        }

        default:
            if (_handler) {
                _handler(HZSharePlatformWeibo,NO,nil);
            }
            break;
    }
    NSLog(@"resp %@",resp);
}
@end
