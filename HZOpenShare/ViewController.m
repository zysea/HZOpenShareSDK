//
//  ViewController.m
//  HZOpenShare
//
//  Created by 张洋 on 16/8/8.
//  Copyright © 2016年 张洋. All rights reserved.
//

#import "ViewController.h"
#import <HZOpenShareSDK/HZOpenShareSDK.h>
#import <TencentOpenAPI/QQApiInterface.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)sendMessage:(id)sender {
    HZShareObject *object = [HZShareObject object];
    object.platformType = HZSharePlatformQQ;
    object.text = @"test test test test";
    object.title = @"test test test test";
    object.messageType = HZShareMessageText;
    object.thumbImage = [UIImage imageNamed:@"表情包-收藏按钮-icon"];
    object.URLStr = @"http://www.baidu.com";
    [HZTencentShare sendMessage:object controller:self handler:nil];

//    QQApiTextObject* txtObj = [QQApiTextObject objectWithText:@"text"];
//    SendMessageToQQReq* req = [SendMessageToQQReq reqWithContent:txtObj];
//
//    QQApiSendResultCode sent = [QQApiInterface sendReq:req];

//    NSLog(@"sent------->%d",sent);
}

@end
