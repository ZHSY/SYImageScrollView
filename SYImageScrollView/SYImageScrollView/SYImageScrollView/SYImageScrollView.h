//
//  SYImageScrollView.h
//  SYIMageScrollView
//
//  Created by 夜雨 on 16/8/24.
//  Copyright © 2016年 zhsy. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SYImageScrollItem.h"

/** 页码小点的显示方式 **/
typedef NS_ENUM(NSUInteger, SYImsViewPageShowStyle)
{
    SYImsViewPageShowStyleNone  = 0,// 不显示
    SYImsViewPageShowStyleLeft,
    SYImsViewPageShowStyleCenter,//default 不显示
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

- (NSArray<SYImageScrollItem *> *)syImsViewIteams:(SYImageScrollView *)imageScrollView;

@optional

-(void)syImsView:(SYImageScrollView *)imageScrollView selectedAdIndex:(NSInteger)index;

@end



@interface SYImageScrollView : UIView


@property (nonatomic, strong, readonly)UIPageControl    *pageControl;//分页小点 在pageShowStyle 不为None 时会被创建
@property (nonatomic, strong, readonly)UILabel          *titleLabel;//图片标题label 在titleShowStyle 不为None 时会被创建
@property (nonatomic, strong, readonly)NSMutableArray *iteams;

@property (nonatomic, assign)CGFloat                    timeInterval;//自动轮播的时间间隔 默认3.0s
/** 页码小点的显示方式 默认SYImsViewPageShowStyleCenter **/
@property (nonatomic, assign)SYImsViewPageShowStyle     pageShowStyle;
/** 图片标题显示方式  默认不显示 **/
@property (nonatomic, assign)SYImsViewTitleShowStyle    titleStyle;
/** 图片加载方式 默认URL加载 **/
@property (nonatomic, assign)SYImsViewImageLoadMode     imageLoadMode;


/** 是否自动滚动广告 默认YES **/
@property (nonatomic, assign)BOOL isAutoScroll;

/** 数据源 **/
@property (nonatomic, assign)id <SYImageScrollViewDelegate>dataSource;

/** 刷新数据 **/
- (void)reloadData;






@end




