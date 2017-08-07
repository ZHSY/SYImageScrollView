//
//  SYImageScrollItem.h
//  SYIMageScrollView
//
//  Created by 夜雨 on 16/8/25.
//  Copyright © 2016年 zhsy. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

@interface SYImageScrollItem : NSObject

/**
 *  三选一个设置项
 */
@property (nonatomic, strong)NSString *ImageUrl;
@property (nonatomic, strong)NSString *ImageName;
@property (nonatomic, strong)UIImage  *Image;


@property (nonatomic, strong)NSString *ImageTitle;

//爱我车附加属性
@property (nonatomic, strong)NSString *title;
@property (nonatomic, strong)NSString *url;

@end
