//
//  HTMLViewController.m
//  WKWebView交互
//
//  Created by zhouxuanhe on 2019/1/5.
//  Copyright © 2019年 xuanhe. All rights reserved.
//

#import "HTMLViewController.h"
#import <WebKit/WebKit.h>

@interface HTMLViewController ()<WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler>

@property (nonatomic, strong) WKWebView *webView;

@end

@implementation HTMLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"WKWebView与JS交互";
    [self setupUI];
    
    [self createWebView];
    
}

#pragma mark - 初始化界面
- (void)setupUI {
    
    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, kNavBarH, kScreenW, 45)];
    [self.view addSubview:navView];
    navView.backgroundColor = [UIColor whiteColor];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake((kScreenW-250)/2.0, 5, 250, 35);
    [btn setTitle:@"本地点击调用JS的方法" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    btn.layer.borderWidth = 1;
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 3;
    [navView addSubview:btn];
        
    
}
- (void)createWebView{
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    WKUserContentController *userController = [[WKUserContentController alloc] init];
    config.userContentController = userController;
    
    WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, kNavBarH+45, kScreenW, kScreenH-kNavBarH-45) configuration:config];
    webView.navigationDelegate = self;
    webView.UIDelegate = self;
    
    NSString *js = @"document.getElementsByTagName('h2')[0].innerText = '这是一个iOS写入的方法'";
    WKUserScript*script = [[WKUserScript alloc] initWithSource:js injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    [config.userContentController addUserScript:script];
    
    // [[webView configuration].userContentController addScriptMessageHandler:self name:@"show"];
    //或者
    [userController addScriptMessageHandler:self name:@"show"];
    [userController addScriptMessageHandler:self name:@"sayHello"];

    [self.view addSubview:webView];
    self.webView = webView;
    
    
    //加载本地HTML
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
    NSString *htmlString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    NSURL *url = [NSURL URLWithString:filePath];
    [_webView loadHTMLString:htmlString baseURL:url];
    
    //加载线上url
    //    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com"]];
    //    [_webView loadRequest:request];
}

- (void)addScriptMessageHandler{
    
    
}

- (void)buttonClick{
    // iOS调用js里的navButtonAction方法并传入两个参数
    [self.webView evaluateJavaScript:@"navButtonAction('Xuanhe',25)" completionHandler:^(id _Nullable response, NSError * _Nullable error) {
        
        NSLog(@"response:%@,error:%@",response,error);
        
    }];
    
}

#pragma mark --------------------------------------------------
#pragma mark - WWKNavigationDelegate
//开始加载
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    //页面开始加载.
    
    //可以在这里做加载动画,然后在加载完成代理里面移除动画即可!
}

//网络错误
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    //网络报错
}

//网页加载完成
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    //设置JS
    NSString *js = @"document.getElementsByTagName('h1')[0].innerText";
    //执行JS
    [webView evaluateJavaScript:js completionHandler:^(id _Nullable response, NSError * _Nullable error) {
        NSLog(@"value: %@ error: %@", response, error);
        
    }];
}

#pragma mark --------------------------------------------------
#pragma mark - WKUIDelegate
// alert 接收到警告面板
//此方法作为js的alert方法接口的实现，默认弹出窗口应该只有提示信息及一个确认按钮，当然可以添加更多按钮以及其他内容，但是并不会起到什么作用
//点击确认按钮的相应事件需要执行completionHandler，这样js才能继续执行
////参数 message为  js 方法 alert(<message>) 中的<message>
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}
// confirm
//作为js中confirm接口的实现，需要有提示信息以及两个相应事件， 确认及取消，并且在completionHandler中回传相应结果，确认返回YES， 取消返回NO
//参数 message为  js 方法 confirm(<message>) 中的<message>
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }])];
    
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }])];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

// prompt
//作为js中prompt接口的实现，默认需要有一个输入框一个按钮，点击确认按钮回传输入值
//当然可以添加多个按钮以及多个输入框，不过completionHandler只有一个参数，如果有多个输入框，需要将多个输入框中的值通过某种方式拼接成一个字符串回传，js接收到之后再做处理
//参数 prompt 为 prompt(<message>, <defaultValue>);中的<message>
//参数defaultText 为 prompt(<message>, <defaultValue>);中的 <defaultValue>
-(void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:prompt message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = defaultText;
    }];
    
    [alertController addAction:([UIAlertAction actionWithTitle:@"完成" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(alertController.textFields[0].text?:@"");
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
    
    
}

#pragma mark --------------------------------------------------
#pragma mark - WLScriptMessageHandler
//JS调用的OC回调方法.js传递过来的数据
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    
    NSLog(@"%@",message.name);//方法名
    NSLog(@"%@",message.body);//传递的数据
    
    if ([message.name isEqualToString:@"show"]) {
        //JS调用的OC回调方法
    }else if ([message.name isEqualToString:@"sayHello"]) {
        NSLog(@"sayHello-你好");
    }
    
}



@end
