//
//  YDDocumentModel.h
//  百思不得姐
//
//  Created by cyz on 16/12/29.
//  Copyright © 2016年 yuze. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YDDocumentModel : NSObject
@property (nonatomic, copy) NSString *date;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *source;
@property (nonatomic, strong) NSArray *image_urls;
@property (nonatomic, strong) NSArray *upload_images;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *category;

@end
