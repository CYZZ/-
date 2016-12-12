//
//  BLwebViewChangeUser-agentVC.m
//  百思不得姐
//
//  Created by cyz on 16/12/2.
//  Copyright © 2016年 yuze. All rights reserved.
//

#import "BLwebViewChangeUser-agentVC.h"
#import <objc/runtime.h>

@interface BLwebViewChangeUser_agentVC ()<UIWebViewDelegate>

@end

@implementation BLwebViewChangeUser_agentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    

    // Do any additional setup after loading the view.
}

- (instancetype)initWithUrlString:(NSString *)urlString
{
    self = [super init];
    if (self) {
        UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
        // 获取全局的user-agent of webView
        NSString *oldAgent = [webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
        NSLog(@"old agent=%@",oldAgent);
        
        
        
        if (![oldAgent containsString:@"baili"]) {
            oldAgent = [oldAgent stringByAppendingString:@" baili"];
        }
        
        NSDictionary *dictionnary = [[NSDictionary alloc] initWithObjectsAndKeys:oldAgent, @"UserAgent", nil];
        [[NSUserDefaults standardUserDefaults] registerDefaults:dictionnary];
        
        [self.view addSubview:webView];
        NSURL *url = [NSURL URLWithString:urlString];
        [webView loadRequest:[NSURLRequest requestWithURL:url cachePolicy:0 timeoutInterval:10]];
        webView.delegate = self;
    }
    return self;
}

#pragma mark - UIWebViewDelegate
//- (void)webViewDidStartLoad:(UIWebView *)webView
//{
//	NSLog(@"%s", __func__);
//}
//

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
//    NSMutableURLRequest *mutRequest = (NSMutableURLRequest *)request;
//    [mutRequest setValue:@"chiyuze" forKey:@"user-agent"];
    NSLog(@"%s",__func__);
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList([request class], &count);
    NSLog(@"count=%d",count);
    for (int i = 0; i < count; i++) {
        Ivar ivar = ivars[i];
        NSString *ivarName = @(ivar_getName(ivar));
        NSLog(@"request----------------------%@",ivarName);
    }
    
    
    
    return YES;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *userAgent = [webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    
	NSLog(@"----------------=============%@", userAgent);
}
//
//- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
//{
//	NSLog(@"error = %@", error);
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
