//
//  FKDashboard.h
//  FKDashboard
//
//  Created by FinderTiwk on 2018/8/22.
//  Copyright © 2018 FinderTiwk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FKDashBoardView : UIView

/*
 构造方法
    @prama start 起始角度, default 150
    @prama end   结束角度, default 390
 */
+ (instancetype)dashBoardViewWithStartAngle:(CGFloat)start
                                   endAngle:(CGFloat)end;

- (instancetype)initWithStartAngle:(CGFloat)start
                          endAngle:(CGFloat)end;

- (void)setStartAngle:(CGFloat)angle;
- (void)setEndAngle:(CGFloat)angle;

//设置进度条与仪表盘之间的间距,default 10
- (void)setPadding:(CGFloat)padding;
//设置内容与视图的内边距,default 5
- (void)setMargin:(CGFloat)margin;

@end



#pragma mark - 进度条
@interface FKDashBoardView()
//设置进度
- (void)setProgress:(CGFloat)progress;
//设置进度条宽度
- (void)setProgressBarWidth:(CGFloat)width;
//设置进度条颜色
- (void)setProgressBarColor:(UIColor *)color;

@end

#pragma mark - 仪表盘
@interface FKDashBoardView()

@property (nonatomic,strong,readonly) UILabel *titleLabel; /**< 仪表盘主标题Label*/
@property (nonatomic,strong,readonly) UILabel *subtitleLabel; /**< 仪表盘副标题Label*/

//大刻度总数
- (void)setNumberOfBigScale:(NSUInteger)count;
//每个大刻度下小刻度总数
- (void)setNumberOfSmallScale:(NSUInteger)count;

- (void)setDashBoardWidth:(CGFloat)width;
- (void)setDashBoardColor:(UIColor *)color;
- (void)setDashBoardBigScaleColor:(UIColor *)color;
- (void)setDashBoardSmallScaleColor:(UIColor *)color;

@end

