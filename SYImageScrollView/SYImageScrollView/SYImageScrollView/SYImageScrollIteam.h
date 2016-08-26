//
//  SYImageScrollIteam.h
//  SYIMageScrollView
//
//  Created by 夜雨 on 16/8/25.
//  Copyright © 2016年 zhsy. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

@interface SYImageScrollIteam : NSObject

/**
 *  三选一个设置项
 */
@property (nonatomic, strong)NSString *ImageUrl;
@property (nonatomic, strong)NSString *ImageName;
@property (nonatomic, strong)UIImage  *Image;


@property (nonatomic, strong)NSString *ImageTitle;

@end
