//
//  WKWebView+XHShowImage.m
//  WKWebView交互
//
//  Created by zhouxuanhe on 2019/1/5.
//  Copyright © 2019年 xuanhe. All rights reserved.
//

#import "WKWebView+XHShowImage.h"
#import <objc/runtime.h>


@implementation WKWebView (XHShowImage)
static char imgUrlArrayKey;

- (void)setMethod:(NSArray *)imgUrlArray {
    objc_setAssociatedObject(self, &imgUrlArrayKey, imgUrlArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSArray *)getImgUrlArray {
    return objc_getAssociatedObject(self, &imgUrlArrayKey);
}

- (NSArray *)xh_getImageUrlWithWebView:(WKWebView *)webView{
    //js方法遍历图片添加点击事件返回图片个数
    static  NSString * const jsGetImages =
    @"function getImages(){\
    var objs = document.getElementsByTagName(\"img\");\
    var imgUrlStr='';\
    for(var i=0;i<objs.length;i++){\
    if(i==0){\
    if(objs[i].alt==''){\
    imgUrlStr=objs[i].src;\
    }\
    }else{\
    if(objs[i].alt==''){\
    imgUrlStr+='#'+objs[i].src;\
    }\
    }\
    objs[i].onclick=function(){\
    if(this.alt==''){\
    document.location=\"myweb:imageClick:\"+this.src;\
    }\
    };\
    };\
    return imgUrlStr;\
    };";
    
    //用js获取全部图片
    [webView evaluateJavaScript:jsGetImages completionHandler:nil];
    
    NSString *js2 = @"getImages()";
    __block NSArray *array = [NSArray array];
    [webView evaluateJavaScript:js2 completionHandler:^(id Result, NSError * error) {
        NSString *resurlt = [NSString stringWithFormat:@"%@",Result];
        if([resurlt hasPrefix:@"#"]){
            resurlt = [resurlt substringFromIndex:1];
        }
        array = [resurlt componentsSeparatedByString:@"#"];
        [webView setMethod:array];
    }];
    
    return array;
    
    
}



@end
