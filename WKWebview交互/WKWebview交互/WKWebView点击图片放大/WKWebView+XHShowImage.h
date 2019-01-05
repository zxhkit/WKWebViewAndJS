//
//  WKWebView+XHShowImage.h
//  WKWebView交互
//
//  Created by zhouxuanhe on 2019/1/5.
//  Copyright © 2019年 xuanhe. All rights reserved.
//

#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WKWebView (XHShowImage)

- (NSArray *)xh_getImageUrlWithWebView:(WKWebView *)webView;

- (NSArray *)getImgUrlArray;

@end

NS_ASSUME_NONNULL_END
