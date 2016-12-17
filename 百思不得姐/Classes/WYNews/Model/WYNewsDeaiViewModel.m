//
//  WYNewsDeaiViewModel.m
//  百思不得姐
//
//  Created by cyz on 16/11/21.
//  Copyright © 2016年 yuze. All rights reserved.
//

#import "WYNewsDeaiViewModel.h"
#import "BLNetworkTool.h"
#import <MJExtension.h>

@implementation WYNewsDeaiViewModel

- (instancetype)init
{
    if (self = [super init]) {
        [self setupRACCommand];
        NSLog(@"进入了WYNewsDeaiViewModel.init");
    }
    return self;
}

/**
 初始化发送命令
 */
- (void)setupRACCommand
{
    @weakify(self);
    _fetchNewsDetailCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        NSLog(@"进入了_fetchNewsDetailCommand");
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            
            @strongify(self);
            [self requestForNewsDetailsuccess:^(NSDictionary *result) {
                //将请求到的数据进行解析存储
                self.detailModel = [WYNewsDetailEntity mj_objectWithKeyValues:result[self.listModel.docid]];
                // 完成
                [subscriber sendCompleted];
                
            } failure:^(NSError *error) {
                [subscriber sendError:error];
            }];
            return nil; // 必须有返回值
        }];
    }];
}

/**
 发起网络请求
 */
- (void)requestForNewsDetailsuccess:(void (^)(NSDictionary *result))success failure:(void (^)( NSError *error))failure
{
    NSString *url = [NSString stringWithFormat:@"http://c.m.163.com/nc/article/%@/full.html",self.listModel.docid];
    [BLNetworkTool BL_GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (responseObject) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

- (NSString *)getHtmlString
{
    NSMutableString *html = [NSMutableString string];
    [html appendString:@"<html>"];
    [html appendString:@"<head>"];
#warning test 测试函数
    [html appendString:@"<script>"];
    [html appendString:@"function myFunction(theme)"];
    [html appendString:@"{"];
    [html appendString:@"var classVal = document.getElementsByTagName('body')[0].getAttribute(\"class\");"];
    
    [html appendString:@"if(theme == \"night\") { classVal = classVal.replace(\"day\", \"night\");}else{classVal = classVal.replace(\"night\", \"day\");}"];
    [html appendString:@"document.getElementsByTagName('body')[0].setAttribute(\"class\",classVal );"];
    [html appendString:@"}"];
	
    [html appendString:@"function myScrollfunc()"];
    [html appendString:@"{"];
    [html appendString:@"var vtop = document.body.scrollTop;"];
    [html appendString:@"vtop = vtop+200;"];
    [html appendString:@"document.body.scrollTop=vtop;"];
//    [html appendString:@"document.body.animate(scrollTop=0,800);"];
    [html appendString:@"}"];
    
    [html appendString:@"</script>"];
    
    
    [html appendFormat:@"<link rel=\"stylesheet\" href=\"%@\">",[[NSBundle mainBundle] URLForResource:@"WYDetails.css" withExtension:nil]];
    [html appendString:@"</head>"];
    
    // 设置背景颜色 字体颜色
        [html appendString:@"<body class=\"day\">"];
    //style=\"background:#f6f6f6\"
    // 
//    [html appendString:@"<body style=\"background:#555555; Color:white\">"];
    [html appendString:[self getBodyString]];
    [html appendString:@"</body>"];
    
    [html appendString:@"</html>"];
    
    return html;
    
}

- (NSString *)getBodyString
{
    
    NSMutableString *body = [NSMutableString string];
    [body appendFormat:@"<div class=\"title\">%@</div>",self.listModel.title];
    [body appendFormat:@"<div class=\"time\">%@</div>",self.listModel.ptime];
    if (self.detailModel.body != nil) {
        // 直接拼接body
//        [body appendString:self.detailModel.body];
        [body appendFormat:@"<div class=\"content\">%@</div>",self.detailModel.body];
    }
    for (bodyimg *detailImgModel in self.detailModel.img) {
        
        NSMutableString *imgHtml = [NSMutableString string];
        // 设置img的div
        [imgHtml appendString:@"<div class=\"img-parent\">"];
        NSArray *pixel = [detailImgModel.pixel componentsSeparatedByString:@"*"];
        CGFloat width = [[pixel firstObject]floatValue];
        CGFloat height = [[pixel lastObject]floatValue];
        // 判断是否超过最大宽度
        CGFloat maxWidth = [UIScreen mainScreen].bounds.size.width * 0.96;
        if (width > maxWidth) {
            height = maxWidth / width * height;
            width = maxWidth;
        }
        
        NSString *onload = @"this.onclick = function() {"
        "  window.location.href = 'sx://github.com/dsxNiubility?src=' +this.src+'&top=' + this.getBoundingClientRect().top + '&whscale=' + this.clientWidth/this.clientHeight ;"
        "};";
        [imgHtml appendFormat:@"<img onload=\"%@\" width=\"%f\" height=\"%f\" src=\"%@\">",onload,width,height,detailImgModel.src];
        [imgHtml appendString:@"</div>"];
        [body replaceOccurrencesOfString:detailImgModel.ref withString:imgHtml options:NSCaseInsensitiveSearch range:NSMakeRange(0, body.length)];
    }
    return body;
}

@end
