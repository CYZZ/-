//
//  YDDetailViewModel.m
//  百思不得姐
//
//  Created by cyz on 16/12/29.
//  Copyright © 2016年 yuze. All rights reserved.
//

#import "YDDetailViewModel.h" // viewModel
#import "YDDetailNewsModel.h" // Model
#import <YYModel.h>
#import "BLNetworkTool.h"
#import "YDDocumentModel.h"
#import "YDresult.h"

@interface YDDetailViewModel ()
/// 资讯详情页模型数据
@property (nonatomic, strong) YDDocumentModel *documents;
@end

@implementation YDDetailViewModel


- (instancetype)init
{
	if (self = [super init]) {
		[self setupRACCommand];
	}
	return self;
}

/// 初始化发送命令
- (void)setupRACCommand
{
	@weakify(self)
	_fetchNewsDetaiCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
			@strongify(self)
			[self requestForNewsDetailsuccess:^(YDDocumentModel *document) {
			
				/// 将请求的数据进行字典转模型
				self.documents = document;
				
				// 完成
				[subscriber sendCompleted];
			} failure:^(NSError *error) {
				// 发送失败
				[subscriber sendError:error];
			}];
			return nil;
		}];
	}];
}

/**
 发起网络请求
 */
- (void)requestForNewsDetailsuccess:(void (^)(YDDocumentModel *document))success failure:(void (^)( NSError *error))failure

{
	NSString *url =[NSString stringWithFormat: @"http://a1.go2yd.com/Website/contents/content?appid=yidian&bottom_channels=true&bottom_comments=true&cv=4.3.4.4&distribution=com.apple.appstore&docid=%@&highlight=true&net=wifi&platform=0&related_docs=true&related_wemedia=true&version=020113", self.result.docid];
	
	BLNetworkTool *manager = [BLNetworkTool sharedToolWithJSON];
	NSString *Cookie = [self getCookie];
	[manager.requestSerializer setValue:Cookie forHTTPHeaderField:@"Cookie"];
	
	[manager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
		NSLog(@"progress=%@",downloadProgress);
	} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
		
		YDDetailNewsModel *model = [YDDetailNewsModel yy_modelWithDictionary:responseObject];
		
		if (success) {
			success(model.documents[0]);
		}
	} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
		NSLog(@"请求资讯详情数据失败");
		failure(error);
	}];
}

/// 获取Cookie
- (NSString *)getCookie
{
	NSString *Cookie = @"JSESSIONID=a2Kxk5sCtOy6I4nzvipDrw";
	NSString *token = [[NSUserDefaults standardUserDefaults] valueForKey:YDToken];
	// 如果用户输入的话就替换
	if (token.length > 1) {
		Cookie = [NSString stringWithFormat:@"JSESSIONID=%@",token];
	}
	
	return Cookie;
}

- (NSString *)getHtmlString
{
//	return self.documents.content;
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
	[body appendFormat:@"<div class=\"title\">%@</div>",self.documents.title];
	[body appendFormat:@"<div class=\"time\">%@</div>",self.documents.date];
	if (self.documents.content != nil) {
		// 直接拼接body
		//        [body appendString:self.detailModel.body];
		[body appendFormat:@"<div class=\"content\">%@</div>",self.documents.content];
	}
	for (NSString *imageUrl in self.documents.image_urls) {
		
		NSMutableString *imgHtml = [NSMutableString string];
		NSString *onload = @"this.onclick = function() {"
		"  window.location.href = 'sx://github.com/dsxNiubility?src=' +this.src+'&top=' + this.getBoundingClientRect().top + '&whscale=' + this.clientWidth/this.clientHeight ;"
		"};";
//		[imgHtml appendFormat:@"<img onload=\"%@\" width=\"%f\" height=\"%f\" src=\"%@\">",onload,width,height,detailImgModel.src];
		
		[imgHtml appendFormat:@"onload=\"%@\" src=\"http://i1.go2yd.com/image.php?url=%@&net=wifi;url=%@\"",onload,imageUrl,imageUrl];
		
		[body replaceOccurrencesOfString:[NSString stringWithFormat:@"src=\"http://image1.hipu.com/image.php?type=thumbnail_580x000&amp;url=%@\"",imageUrl] withString:imgHtml options:NSCaseInsensitiveSearch range:NSMakeRange(0, body.length)];
	}
	return body;
}
@end
