//
//  HZWeiboShare.m
//  CommonUtil
//
//  Created by Hiram on 16/8/8.
//  Copyright © 2016年 Hiram. All rights reserved.
//

#import "HZWeiboShare.h"

@interface HZWeiboShare ()

@property (nonatomic ,strong) NSString *wbtoken;

@property (nonatomic ,strong) NSString *wbCurrentUserID;

@property (nonatomic ,strong) NSString *wbRefreshToken;

@property (nonatomic ,strong) NSString *redirectURL;


@end

@implementation HZWeiboShare



+ (instancetype)shareIntance
{
    static HZWeiboShare  *share = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        share = [[HZWeiboShare alloc]init];
    });
    return share;
}

+ (BOOL)handleOpenURL:(NSURL *)url
{
   return [[self shareIntance] handleOpenURl:url];
}

- (void)didReceiveWeiboResponse:(id)response
{
    Class WBSendMessageToWeiboResponse = NSClassFromString(@"WBSendMessageToWeiboResponse");
    Class WBAuthorizeResponse = NSClassFromString(@"WBAuthorizeResponse");
    Class WBPaymentResponse = NSClassFromString(@"WBPaymentResponse");
    Class WBSDKAppRecommendResponse = NSClassFromString(@"WBSDKAppRecommendResponse");
    Class WBShareMessageToContactResponse = NSClassFromString(@"WBShareMessageToContactResponse");

    if ([response isKindOfClass:[WBSendMessageToWeiboResponse class]]) {
        NSInteger status = [[response valueForKey:@"statusCode"] integerValue];
        id authResponse = [response valueForKey:@"authResponse"];
        NSString* accessToken = [authResponse valueForKey:@"accessToken"];
        NSString* userID = [authResponse valueForKey:@"userID"];;
        if (accessToken){
            self.wbtoken = accessToken;
        }
        if (userID) {
            self.wbCurrentUserID = userID;
        }
        NSLog(@"status %ld",(long)status);

    } else if ([response isKindOfClass:[WBAuthorizeResponse class]]) {

    } else if ([response isKindOfClass:[WBPaymentResponse class]]) {

    } else if ([response isKindOfClass:[WBSDKAppRecommendResponse class]]) {

    } else if ([response isKindOfClass:[WBShareMessageToContactResponse class]]) {

    }
}

- (BOOL)sendMessage:(HZShareObject *)shareObject shareMessageFrom:(NSString *)from
{
    id authRequest = createAuthRequest(self.redirectURL);
    id message = createMessage(shareObject);
    id request = createWeiboRequest(message,authRequest,self.wbtoken,from);
    Class class = NSClassFromString(@"WeiboSDK");
    SEL selector = NSSelectorFromString(@"sendRequest:");
    IMP imp = [class methodForSelector:selector];
    BOOL (*sendMessage)(id,SEL,id) = (BOOL (*)(id,SEL,id))imp;

   return sendMessage(class,selector,request);
}


+ (BOOL)sendMessage:(HZShareObject *)shareObject controller:(UIViewController *)controller handler:(HZShareHandler)handler
{
    NSString *from = NSStringFromClass(controller.class);
   return [[self shareIntance]sendMessage:shareObject shareMessageFrom:from];
}

+ (BOOL)registerApp:(NSString *)appKey redirectURL:(NSString *)url
{
    return [[self shareIntance]registerApp:appKey url:url];
}

- (BOOL)handleOpenURl:(NSURL *)url
{
    Class WeiboSDK = NSClassFromString(@"WeiboSDK");
    SEL seletor = NSSelectorFromString(@"handleOpenURL:delegate:");
    IMP imp = [WeiboSDK methodForSelector:seletor];
    BOOL(*func)(id,SEL,NSURL *,id) = (BOOL(*)(id,SEL,NSURL *,id)) imp;
    return func(WeiboSDK,seletor,url,self);
}

- (BOOL)registerApp:(NSString *)appKey url:(NSString *)url
{
    self.redirectURL = url;
    Class class = NSClassFromString(@"WeiboSDK");
    SEL selector = NSSelectorFromString(@"registerApp:");
    IMP imp = [class methodForSelector:selector];
    BOOL (*func)(id,SEL,NSString *);
    func = (BOOL(*)(id,SEL,NSString *))imp;
    BOOL flag = func(class,selector,appKey);
    return flag;
}

id creatWeiboMediaObject(NSString *className)
{
    Class  class = NSClassFromString(className);
    SEL selector = NSSelectorFromString(@"object");
    IMP imp = [class methodForSelector:selector];
    id (*createmedia)(id,SEL) = (id(*)(id,SEL))imp;
    id mediaObject = createmedia(class,selector);
    return mediaObject;
}

id createMessage(HZShareObject *shareObject)
{
    Class  WBMessageObject = NSClassFromString(@"WBMessageObject");
    SEL createMessage_selector = NSSelectorFromString(@"message");
    IMP creatMessage_imp = [WBMessageObject methodForSelector:createMessage_selector];
    id (*createMessage)(id,SEL) = (id(*)(id,SEL))creatMessage_imp;
    id message = createMessage(WBMessageObject,createMessage_selector);
    [message setValue:shareObject.text forKey:@"text"];

    if (shareObject.messageType == HZShareMessageText) {
        [message setValue:shareObject.text forKey:@"text"];
    } else if (shareObject.messageType == HZShareMessageImage || shareObject.messageType == HZShareMessageGifImage) {
        id ext = creatWeiboMediaObject(@"WBImageObject");
        [ext setValue:shareObject.data forKey:@"imageData"];
        [message setValue:ext forKey:@"imageObject"];
    } else if (shareObject.messageType == HZShareMessageWebpage) {
        id ext = creatWeiboMediaObject(@"WBWebpageObject");
        setMediaObjectCommonParameter(ext, shareObject);
        [ext setValue:shareObject.URLStr forKey:@"webpageUrl"];
        [message setValue:ext forKey:@"mediaObject"];
    } else if (shareObject.messageType == HZShareMessageMusic) {
        id ext = creatWeiboMediaObject(@"WBMusicObject");
        setMediaObjectCommonParameter(ext, shareObject);
        [ext setValue:shareObject.URLStr forKey:@"musicUrl"];
        [message setValue:ext forKey:@"mediaObject"];
    } else if (shareObject.messageType == HZShareMessageVideo) {
        id ext = creatWeiboMediaObject(@"WBVideoObject");
        setMediaObjectCommonParameter(ext, shareObject);
        [ext setValue:shareObject.URLStr forKey:@"videoUrl"];
        [message setValue:ext forKey:@"mediaObject"];
    }
    return message;
}

id createAuthRequest(NSString *url){
    Class  WBAuthorizeRequest = NSClassFromString(@"WBAuthorizeRequest");
    SEL selector = NSSelectorFromString(@"request");
    IMP imp = [WBAuthorizeRequest methodForSelector:selector];
    id (*create)(id,SEL) = (id(*)(id,SEL))imp;
    id request = create(WBAuthorizeRequest,selector);
    [request setValue:@"all" forKey:@"scope"];
    [request setValue:url forKey:@"redirectURI"];
    return request;
}

id createWeiboRequest(id message,id authRequest,id token,id from){
    Class  classs = NSClassFromString(@"WBSendMessageToWeiboRequest");
    SEL selector = NSSelectorFromString(@"requestWithMessage:authInfo:access_token:");
    IMP imp = [classs methodForSelector:selector];
    id (*create)(id,SEL,id,id,id) = (id(*)(id,SEL,id,id,id))imp;
    id request = create(classs,selector,message,authRequest,token);
    NSDictionary *userInfo =  @{@"ShareMessageFrom": from,
                                @"Other_Info_1": [NSNumber numberWithInt:123],
                                @"Other_Info_2": @[@"obj1", @"obj2"],
                                @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    [request setValue:userInfo forKey:@"userInfo"];
    return request;
}

void setMediaObjectCommonParameter(id mediaObject,HZShareObject *shareObject)
{
    [mediaObject setValue:shareObject.title forKey:@"title"];
    [mediaObject setValue:shareObject.objectId forKey:@"objectID"];
    [mediaObject setValue:shareObject.text forKey:@"description"];
    NSData *data = UIImagePNGRepresentation(shareObject.thumbImage);
    [mediaObject setValue:data forKey:@"thumbnailData"];
}

@end
