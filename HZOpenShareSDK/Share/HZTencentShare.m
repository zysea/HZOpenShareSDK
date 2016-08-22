//
//  HZTencentShare.m
//  HZOpenShare
//
//  Created by Hiram on 16/8/9.
//  Copyright © 2016年 张洋. All rights reserved.
//

#import "HZTencentShare.h"

@interface HZTencentShare ()

@property (nonatomic ,strong) id tencentOAuth;
@property (nonatomic ,strong) id appKey;
@property (nonatomic ,strong) id redirectURL;
@property (nonatomic ,strong) id shareObject;

@end

@implementation HZTencentShare

// 创建 SendMessageToQQReq
id createQQRed(id Obj)
{
    Class SendMessageToQQReq = NSClassFromString(@"SendMessageToQQReq");
    SEL selector = NSSelectorFromString(@"reqWithContent:");
    IMP imp = [SendMessageToQQReq methodForSelector:selector];
    id (*create)(id,SEL,id) = (id(*)(id,SEL,id))imp;
    return create(SendMessageToQQReq,selector,Obj);
}
bool isSucess(int sent){
    switch (sent) {
        case 0:
            return YES;
            break;
        case 1:
            return NO;
        default:
            break;
    }
    return NO;
}
int sendQQReq(id Obj)
{
    Class QQApiInterface = NSClassFromString(@"QQApiInterface");
    SEL selector = NSSelectorFromString(@"sendReq:");
    IMP imp = [QQApiInterface methodForSelector:selector];
    int (*send)(id,SEL,id) = (int(*)(id,SEL,id))imp;
    return send(QQApiInterface,selector,Obj);
}


int sendReqToQZone(id Obj)
{
    Class QQApiInterface = NSClassFromString(@"QQApiInterface");
    SEL selector = NSSelectorFromString(@"SendReqToQZone:");
    IMP imp = [QQApiInterface methodForSelector:selector];
    int (*send)(id,SEL,id) = (int(*)(id,SEL,id))imp;
    return send(QQApiInterface,selector,Obj);
}

id creatMediaObject(HZShareObject *shareObject)
{
    id mediaObject = nil;
    switch (shareObject.messageType) {
        case HZShareMessageText:
        {
           if (shareObject.platformType ==HZSharePlatformQQ) {
               mediaObject = creatQQTextObject(shareObject);
           } else {
               mediaObject = creatQZoneImageObject(shareObject);
           }
        }
            break;
        case HZShareMessageImage:
        case HZShareMessageGifImage:
        case HZShareMessagetEmoticon:
            mediaObject = creatQQImageObject(shareObject);
            break;
        case HZShareMessageMusic:
            mediaObject = createQQAudioObject(shareObject);
            break;
        case HZShareMessageVideo:
            mediaObject = createQQVideoObject(shareObject);
            break;
        case HZShareMessageFile:
            mediaObject = createQQFileObject(shareObject);
            break;
        case HZShareMessageApp:
        case HZShareMessageWebpage:
            mediaObject = createQQWebpageObject(shareObject);
            break;
        default:
            break;
    }
    return mediaObject;
}

id creatQQTextObject(HZShareObject *shareObject)
{
    Class QQApiTextObject = NSClassFromString(@"QQApiTextObject");
    SEL sel = NSSelectorFromString(@"objectWithText:");
    IMP imp = [QQApiTextObject methodForSelector:sel];
    id (*create)(id,SEL,id) = (id(*)(id,SEL,id))imp;
    if (shareObject.text== nil ) {
        NSLog(@"text is nill");
        return nil;
    }
    id obj = create(QQApiTextObject,sel,shareObject.text);
    return obj;
}

id creatQQImageObject(HZShareObject *shareObject){

    Class QQApiImageObject = NSClassFromString(@"QQApiImageObject");
    SEL sel = NSSelectorFromString(@"objectWithData:previewImageData:title:description:");
    IMP imp = [QQApiImageObject methodForSelector:sel];
    id (*create)(id,SEL,id,id,id,id) = (id(*)(id,SEL,id,id,id,id))imp;
    NSData *data = UIImagePNGRepresentation(shareObject.thumbImage);
    id obj = create(QQApiImageObject,sel,shareObject.data,data,shareObject.title,shareObject.description);
    if (shareObject.platformType == HZSharePlatformQZone && shareObject.messageType==HZShareMessageText) {
       obj = create(QQApiImageObject,sel,nil,nil,nil,shareObject.description);
    }
    return obj;
}

id createQQWebpageObject(HZShareObject *shareObject){
    Class QQApiImageObject = NSClassFromString(@"QQApiNewsObject");
    SEL sel = NSSelectorFromString(@"objectWithURL:title:description:previewImageData:");
    IMP imp = [QQApiImageObject methodForSelector:sel];
    id (*create)(id,SEL,id,id,id,id) = (id(*)(id,SEL,id,id,id,id))imp;
    NSData *data = UIImagePNGRepresentation(shareObject.thumbImage);
    NSURL *url = [NSURL URLWithString:shareObject.URLStr];
    id obj = create(QQApiImageObject,sel,url,shareObject.title,shareObject.description,data);
    return obj;
}


id creatQZoneImageObject(HZShareObject *shareObject){
    
    Class QQApiImageObject = NSClassFromString(@"QQApiImageArrayForQZoneObject");
    SEL sel = NSSelectorFromString(@"objectWithimageDataArray:title:");
    IMP imp = [QQApiImageObject methodForSelector:sel];
    id (*create)(id,SEL,id,id) = (id(*)(id,SEL,id,id))imp;
    
    id obj = create(QQApiImageObject,sel,@[shareObject.data],shareObject.text);
    if (shareObject.platformType == HZSharePlatformQZone && shareObject.messageType==HZShareMessageText) {
        obj = create(QQApiImageObject,sel,nil,shareObject.text);
    }
    return obj;
}

id createQQAudioObject(HZShareObject *shareObject){
    Class QQApiImageObject = NSClassFromString(@"QQApiAudioObject");
    SEL sel = NSSelectorFromString(@"objectWithURL:title:description:previewImageData:");
    IMP imp = [QQApiImageObject methodForSelector:sel];
    id (*create)(id,SEL,id,id,id,id) = (id(*)(id,SEL,id,id,id,id))imp;
    NSData *data = UIImagePNGRepresentation(shareObject.thumbImage);
    NSURL *url = [NSURL URLWithString:shareObject.URLStr];
    id obj = create(QQApiImageObject,sel,url,shareObject.title,shareObject.description,data);
    return obj;
}

id createQQVideoObject(HZShareObject *shareObject){
    Class QQApiImageObject = NSClassFromString(@"QQApiNewsObject");
    SEL sel = NSSelectorFromString(@"objectWithURL:title:description:previewImageData:");
    IMP imp = [QQApiImageObject methodForSelector:sel];
    id (*create)(id,SEL,id,id,id,id) = (id(*)(id,SEL,id,id,id,id))imp;
    NSData *data = UIImagePNGRepresentation(shareObject.thumbImage);
    NSURL *url = [NSURL URLWithString:shareObject.URLStr];
    id obj = create(QQApiImageObject,sel,url,shareObject.title,shareObject.description,data);
    return obj;
}

id createQQFileObject(HZShareObject *shareObject){
    Class QQApiImageObject = NSClassFromString(@"QQApiFileObject");
    SEL sel = NSSelectorFromString(@"objectWithData:previewImageData:title:description:");
    IMP imp = [QQApiImageObject methodForSelector:sel];
    id (*create)(id,SEL,id,id,id,id) = (id(*)(id,SEL,id,id,id,id))imp;
    NSData *data = UIImagePNGRepresentation(shareObject.thumbImage);

    NSData *fileData = shareObject.data;
    if (fileData == nil) {
        NSURL *url = [NSURL URLWithString:shareObject.URLStr];
        fileData = [NSData dataWithContentsOfURL:url];
    }
    id obj = create(QQApiImageObject,sel,fileData,data,shareObject.title,shareObject.description);
    return obj;
}

+ (instancetype)shareIntance
{
    static HZTencentShare *share = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        share = [[HZTencentShare alloc]init];
    });
    return share;
}

- (void)initTencentOAuth
{
    if (_tencentOAuth == nil) {
        Class TencentOAuth = NSClassFromString(@"TencentOAuth");
        _tencentOAuth = [[TencentOAuth alloc]init];
        [_tencentOAuth setValue:@"www.qq.com" forKey:@"redirectURI"];
        [_tencentOAuth setValue:_appKey forKey:@"appId"];
        if (_redirectURL!=nil && [_redirectURL length]>0) {
            [_tencentOAuth setValue:_redirectURL forKey:@"redirectURI"];
        }
        [_tencentOAuth setValue:self forKey:@"sessionDelegate"];
//        NSArray* permissions = [NSArray arrayWithObjects:@"get_user_info", @"get_simple_userinfo", @"add_t", nil];
//        SEL selector = NSSelectorFromString(@"authorize:inSafari:");
//        IMP imp = [_tencentOAuth methodForSelector:selector];
//        void(*func)(id,SEL,id,BOOL)= (void(*)(id,SEL,id,BOOL))imp;
//        func(_tencentOAuth,selector,permissions,NO);

    }
}

+ (BOOL)handleOpenURL:(NSURL *)url
{
   return [[self shareIntance]handleOpenURL:url];
}

+ (BOOL)registerApp:(NSString *)appKey redirectURL:(NSString *)url
{
    [[self shareIntance] registerApp:appKey redirectURL:url];
    return YES;
}

+ (BOOL) sendMessage:(HZShareObject *)shareObject controller:(UIViewController *)controller handler:(void (^)(HZSharePlatformType, BOOL, NSError *))handler
{
    if (shareObject.platformType == HZSharePlatformQQ || shareObject.platformType == HZSharePlatformQZone ) {
        return [[self shareIntance]sendMessage:shareObject controller:controller handler:handler];
    }
    return NO;
}

- (BOOL)sendMessage:(HZShareObject *)shareObject controller:(UIViewController *)controller handler:(void (^)(HZSharePlatformType, BOOL, NSError *))handler
{
    _shareObject = shareObject;
    id mediaObject = creatMediaObject(shareObject);
    if (mediaObject == nil) {
        return NO;
    }
    id req = createQQRed(mediaObject);
    if (req == nil) {
        return NO;
    }
    int sent = -1;
    if (shareObject.platformType == HZSharePlatformQZone) {
        sent = sendReqToQZone(req);
    } else {
        sent = sendQQReq(req);
    }
    return  isSucess(sent);
}


- (BOOL)registerApp:(NSString *)appKey redirectURL:(NSString *)url
{
    Class TencentOAuth = NSClassFromString(@"TencentOAuth");
    id temp = [TencentOAuth alloc];
    SEL sel = NSSelectorFromString(@"initWithAppId:andDelegate:");
    IMP imp = [temp methodForSelector:sel];
    id(*func)(id,SEL,id,id) = (id(*)(id,SEL,id,id))imp;
     _tencentOAuth = func(temp,sel,appKey,self);
    if (url!=nil && [url length]>0) {
        [_tencentOAuth setValue:url forKey:@""];
    }
    self.appKey = appKey;
    self.redirectURL = url;
    [self initTencentOAuth];
    return YES;
}

- (BOOL)handleOpenURL:(NSURL *)url
{
    Class TencentOAuth = NSClassFromString(@"TencentOAuth");
    SEL selector = NSSelectorFromString(@"HandleOpenURL:");
    IMP imp = [TencentOAuth methodForSelector:selector];
    BOOL (*func)(id,SEL,id) = (BOOL(*)(id,SEL,id))imp;
    return func(TencentOAuth,selector,url);
}

- (void)tencentDidLogin
{
    NSLog(@"tencentDidLogin >>> login success");
}
- (void)tencentDidNotLogin:(BOOL)cancelled
{

}

- (void)tencentDidNotNetWork
{

}
@end
