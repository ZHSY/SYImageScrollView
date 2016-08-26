//
//  SYImageScrollView.h
//  SYIMageScrollView
//
//  Created by 夜雨 on 16/8/24.
//  Copyright © 2016年 zhsy. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SYImageScrollIteam.h"

/** 页码小点的显示方式 **/
typedef NS_ENUM(NSUInteger, SYImsViewPageShowStyle)
{
    SYImsViewPageShowStyleNone,//default 不显示
    SYImsViewPageShowStyleLeft,
    SYImsViewPageShowStyleCenter,
    SYImsViewPageShowStyleRight,
};

/** 图片标题的显示方式 **/
typedef NS_ENUM(NSUInteger, SYImsViewTitleShowStyle)
{
    SYImsViewTitleShowStyleNone,//default 不显示
    SYImsViewTitleShowStyleTop,
    SYImsViewTitleShowStyleBottom,
};

/** 图片加载方式 **/
typedef NS_ENUM(NSUInteger, SYImsViewImageLoadMode)
{
    SYImsViewImageLoadModeDefault,//default URL
    SYImsViewImageLoadModeURL,
    SYImsViewImageLoadModeImage,
    SYImsViewImageLoadModeName,
};

@class SYImageScrollView;

@protocol  SYImageScrollViewDelegate <NSObject>

- (NSArray<SYImageScrollIteam *> *)syImsViewIteams:(SYImageScrollView *)imageScrollView;

@optional

-(void)syImsView:(SYImageScrollView *)imageScrollView selectedAdIndex:(NSInteger)index;

@end



@interface SYImageScrollView : UIView


@property (nonatomic, strong, readonly)UIPageControl    *pageControl;//分页小点 在pageShowStyle 不为None 时会被创建
@property (nonatomic, strong, readonly)UILabel          *titleLabel;//图片标题label 在titleShowStyle 不为None 时会被创建
@property (nonatomic, strong, readonly)NSMutableArray *iteams;

@property (nonatomic, assign)CGFloat                    timeInterval;//自动轮播的时间间隔 默认3.0s

@property (nonatomic, assign)SYImsViewPageShowStyle     pageShowStyle;
@property (nonatomic, assign)SYImsViewTitleShowStyle    titleStyle;
@property (nonatomic, assign)SYImsViewImageLoadMode     imageLoadMode;



@property (nonatomic, assign)BOOL isAutoScroll;/** 是否自动滚动广告 **/


@property (nonatomic, assign)id <SYImageScrollViewDelegate>dataSource;

/** 刷新数据 **/
- (void)reloadData;






@end




