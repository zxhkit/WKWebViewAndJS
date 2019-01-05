//
//  WKWebViewViewController.m
//  WKWebView交互
//
//  Created by zhouxuanhe on 2019/1/5.
//  Copyright © 2019年 xuanhe. All rights reserved.
//

#import "WKWebViewViewController.h"
#import <WebKit/WebKit.h>


@interface WKWebViewViewController ()<WKNavigationDelegate>
@property (nonatomic, strong) WKWebView *webView;
@end

@implementation WKWebViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"WKWebView点击图片放大";
    
    NSString *url = @"http://tapi.mukr.com/mapi/wphtml/index.php?ctl=app&act=news_detail&id=VGpTSDhkemFVb3Y4Y3JXTFdRR2J4UT09";
    WKWebView *webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, kNavBarH, kScreenW, kScreenH-kNavBarH)];
    webView.navigationDelegate = self;
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    [self.view addSubview:webView];
    self.webView = webView;
}


- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [webView xh_getImageUrlWithWebView:webView];
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    [self showBigImage:navigationAction.request];
    
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)showBigImage:(NSURLRequest *)request {
    NSString *str = request.URL.absoluteString;
    if ([str hasPrefix:@"myweb:imageClick:"]) {
        NSString *imageUrl = [str substringFromIndex:@"myweb:imageClick:".length];
        NSArray *imgUrlArr = [self.webView getImgUrlArray];
        NSInteger index = 0;
        for (NSInteger i = 0; i < [imgUrlArr count]; i++) {
            if([imageUrl isEqualToString:imgUrlArr[i]]){
                index = i;
                break;
            }
        }
        NSLog(@"im");
    }
    
}
@end
