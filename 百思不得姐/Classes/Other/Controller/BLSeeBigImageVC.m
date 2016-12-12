//
//  BLSeeBigImageVC.m
//  百思不得姐
//
//  Created by cyz on 16/12/1.
//  Copyright © 2016年 yuze. All rights reserved.
//

#import "BLSeeBigImageVC.h"
#import "BLJinhuaALLModel.h"
#import <UIImageView+WebCache.h>

#import <Photos/Photos.h>
#import <SVProgressHUD.h>

@interface BLSeeBigImageVC ()<UIScrollViewDelegate>
/// 图片控件
@property (nonatomic, weak) UIImageView *imageView;

@end

@implementation BLSeeBigImageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // scrollView
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.backgroundColor = [UIColor blackColor];
    scrollView.delegate = self;
    scrollView.frame = self.view.frame;
    [self.view insertSubview:scrollView atIndex:0];
    
    // imageView
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView sd_setImageWithURL:[NSURL URLWithString: self.model.image1] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        NSLog(@"加载图片完成");
    }];
    
    [scrollView addSubview:imageView];
    
    CGFloat imageW = scrollView.frame.size.width;
    CGFloat imageH = [self.model.height floatValue] * imageW / [self.model.width floatValue];
    CGFloat imageX = 0;
    CGFloat imageY = 0;
    
    imageView.frame = CGRectMake(imageX, imageY, imageW, imageH);
    if (imageH >= scrollView.frame.size.height) {
        // 滚动范围
        scrollView.contentSize = CGSizeMake(0, imageH);
    }else{
        imageView.center = CGPointMake(scrollView.frame.size.width/2.0, scrollView.frame.size.height/2.0);
    }
    self.imageView = imageView;
    
    // 缩放比例
    CGFloat scale = [self.model.width floatValue] / imageW;
    
    if (scale > 1.0) {
        scrollView.maximumZoomScale = scale;
    }
    
    
}
#pragma mark - <UIScrollViewDelegate>

/**
 返回需要进行缩放的视图
 */
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

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
