//
//  FKDashBoardView.m
//  FKDashBoardView
//
//  Created by FinderTiwk on 2018/8/22.
//  Copyright © 2018 FinderTiwk. All rights reserved.
//

#import "FKDashBoardView.h"

#define ANGLE2RADIAN(__angle) (((__angle)*M_PI)/180)
@interface FKDashBoardView()

//===================FKDashBoardView===================
@property (nonatomic,assign) CGFloat startAngle; /**< 开始弧度*/
@property (nonatomic,assign) CGFloat endAngle;   /**< 结束弧度*/
@property (nonatomic,assign) CGFloat padding;    /**< 仪表盘与进度条间的间距*/
@property (nonatomic,assign) CGFloat margin;     /**< 整个表盘到视图的边距*/

@property (nonatomic,assign) CGPoint centerPoint; /**< 修正过的仪表盘中心*/
@property (nonatomic,assign) CGFloat radius;      /**< 修正过的仪表盘中心*/

//===================进度条===================
@property (nonatomic,weak) CAShapeLayer *progressLayer;
@property (nonatomic,weak) UIView *cursorView;    /**< 光标*/
@property (nonatomic,assign) CGFloat currentProgress;    /**< 当前进度*/
@property (nonatomic,assign) CGFloat progressBarWidth;   /**< 宽度*/
@property (nonatomic,strong) UIColor *progressBarColor;  /**< 颜色*/

//===================仪表盘===================
@property (nonatomic,assign) CGFloat dashBoardWidth;   /**< 仪表盘宽度*/
@property (nonatomic,assign) NSUInteger numberOfBigScale; /**< 大刻度总数*/
@property (nonatomic,assign) NSUInteger numberOfSmallScale;  /**< 每个大刻度下小刻度总数*/

@property (nonatomic,strong) UIColor *dashBoardColor; /**< 仪表盘颜色*/
@property (nonatomic,strong) UIColor *dashBoardBigScaleColor; /**< 大刻度颜色*/
@property (nonatomic,strong) UIColor *dashBoardSmallScaleColor; /**< 小刻度颜色*/


@end

@implementation FKDashBoardView

- (instancetype)initWithStartAngle:(CGFloat)start endAngle:(CGFloat)end{
    if (self = [super init]) {
        _startAngle = start;
        _endAngle = end;
    }
    return self;
}

+ (instancetype)dashBoardViewWithStartAngle:(CGFloat)start
                                   endAngle:(CGFloat)end{
    return [[FKDashBoardView alloc] initWithStartAngle:start
                                              endAngle:end];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self prepareData];
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    [self prepareData];
}

- (void)prepareData{
    self.backgroundColor = [UIColor clearColor];
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _subtitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    
    //整体配置
    _startAngle = self.startAngle > 0? self.startAngle:160;
    _endAngle   = self.endAngle > 0? self.endAngle:280;
    _padding = 2;
    _margin  = 2;
    
    //进度条配置
    _currentProgress = 0;
    _progressBarWidth = 3;
    _progressBarColor = [UIColor whiteColor];
    
    //仪表盘默认配置
    _dashBoardWidth = 15;
    _numberOfBigScale = 5;
    _numberOfSmallScale = 4;
    _dashBoardColor = [UIColor colorWithWhite:1 alpha:0.6];
    _dashBoardBigScaleColor = [UIColor whiteColor];
    _dashBoardSmallScaleColor = [UIColor colorWithWhite:1 alpha:0.6];
}


- (void)drawRect:(CGRect)rect{
    
    NSParameterAssert(self.endAngle > self.startAngle);
    CGSize size = rect.size;
    CGFloat width = size.width;
    CGFloat height = size.height;
    
    CGFloat radius = MIN(width, height)/2 - self.margin - self.progressBarWidth;
    self.radius = radius;
    
    //圆心下移
    CGFloat deltaCenterY = sinf(ANGLE2RADIAN(180 - self.startAngle))*radius;
    CGPoint centerPoint = CGPointMake(width/2, height/2 + deltaCenterY);
    self.centerPoint = centerPoint;
    
    {//=========================进度条背景=====================
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.path = [UIBezierPath bezierPathWithArcCenter:centerPoint
                                                    radius:radius
                                                startAngle:ANGLE2RADIAN(self.startAngle)
                                                  endAngle:ANGLE2RADIAN(self.endAngle)
                                                 clockwise:YES].CGPath;
        
        layer.fillColor = [UIColor clearColor].CGColor;
        layer.strokeColor = [UIColor colorWithWhite:1 alpha:0.6].CGColor;
        layer.lineWidth = self.progressBarWidth;
        layer.lineCap = kCALineCapRound;
        [self.layer addSublayer:layer];
    }
    
    {//=========================进度条=====================
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.path = [UIBezierPath bezierPathWithArcCenter:centerPoint
                                                    radius:radius
                                                startAngle:ANGLE2RADIAN(self.startAngle)
                                                  endAngle:ANGLE2RADIAN(self.endAngle)
                                                 clockwise:YES].CGPath;
        
        layer.fillColor   = [UIColor clearColor].CGColor;
        layer.strokeColor = [UIColor whiteColor].CGColor;
        layer.lineWidth   = self.progressBarWidth;
        layer.lineCap     = kCALineCapRound;
        layer.strokeEnd   = self.currentProgress;
        [self.layer addSublayer:layer];
        _progressLayer = layer;
    }
    
    {//=========================光标=====================
        CGFloat deltaAngle = self.startAngle + (self.endAngle - self.startAngle)*self.currentProgress;
        
        CGFloat centerX = centerPoint.x + radius*cosf(ANGLE2RADIAN(deltaAngle));
        CGFloat centerY = centerPoint.y + radius*sinf(ANGLE2RADIAN(deltaAngle));
        
        CGFloat w = (self.progressBarWidth/2 + 2);
        UIView *cursorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 2*w, 2*w)];
        cursorView.center = CGPointMake(centerX, centerY);
        cursorView.layer.cornerRadius = w;
        cursorView.backgroundColor = [UIColor whiteColor];
        [self addSubview:cursorView];
        self.cursorView = cursorView;
    }
    
    {//=========================仪表盘 盘面=====================
        radius = (radius - self.padding - self.dashBoardWidth);
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.path = [UIBezierPath bezierPathWithArcCenter:centerPoint
                                                    radius:radius
                                                startAngle:ANGLE2RADIAN(self.startAngle)
                                                  endAngle:ANGLE2RADIAN(self.endAngle)
                                                 clockwise:YES].CGPath;
        
        layer.fillColor   = [UIColor clearColor].CGColor;
        layer.strokeColor = self.dashBoardColor.CGColor;
        layer.lineWidth   = self.dashBoardWidth;
        layer.opaque      = 0.4;

        [self.layer addSublayer:layer];
    }
    
    {//=========================仪表盘 刻度=====================
        NSUInteger scaleCount = self.numberOfSmallScale * self.numberOfBigScale;
        CGFloat perAngle      = (self.endAngle - self.startAngle)/scaleCount;
        CGFloat perimeter     = (2*M_PI*radius); //周长
        
        //计算每一个刻度旋转的角度
        for (NSUInteger index = 0 ; index < (scaleCount + 1); index ++) {
            
            BOOL isBigScale   = (index % (self.numberOfSmallScale + 1) == 0);
            
            CGFloat lineWidth = isBigScale?self.dashBoardWidth:self.dashBoardWidth*0.8;
            CGFloat scaleLineWidth = isBigScale?2:1;
            
            CGFloat start = self.startAngle + (perAngle*index);
            CGFloat end   = start + (scaleLineWidth/perimeter*360);

            CAShapeLayer *layer = [CAShapeLayer layer];
            layer.strokeColor = (isBigScale?self.dashBoardBigScaleColor:self.dashBoardSmallScaleColor).CGColor;
            layer.path = [UIBezierPath bezierPathWithArcCenter:centerPoint
                                                        radius:radius
                                                    startAngle:ANGLE2RADIAN(start)
                                                      endAngle:ANGLE2RADIAN(end)
                                                     clockwise:YES].CGPath;
            layer.lineWidth = lineWidth;
            [self.layer addSublayer:layer];
        }
    }
    
    {//=========================仪表盘标题=====================
        CGFloat tWidth  = sqrt(2)*radius - self.dashBoardWidth/2;
        CGFloat tHeight = (tWidth - deltaCenterY)/2 - 10;
        CGFloat x = centerPoint.x - tWidth/2;
        CGFloat y = centerPoint.y - tWidth/2;
        _subtitleLabel.frame = CGRectMake(x, y, tWidth, tHeight);
        _subtitleLabel.textAlignment   = NSTextAlignmentCenter;
        _subtitleLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_subtitleLabel];
        
        y = y + tHeight;
        _titleLabel.frame = CGRectMake(x, y, tWidth, tHeight);
        _titleLabel.textAlignment   = NSTextAlignmentCenter;
        _titleLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_titleLabel];
        
    }
}

#pragma mark -API
- (void)setProgress:(CGFloat)progress{
    
    if (progress == _currentProgress) {
        return;
    }
    progress = (progress > 1.0)?1.0:progress;
    if (self.progressLayer) {
        
        static NSTimeInterval duration = 0.4;
        {//进度条动画
            CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
            animation.duration  = duration;
            animation.fromValue = @(_currentProgress);
            animation.toValue   = @(progress);
            animation.fillMode  = kCAFillModeForwards;
            animation.removedOnCompletion = NO;
            [self.progressLayer addAnimation:animation forKey:@"strokeEnd"];
        }
        
        {//光标动画
            CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
            animation.calculationMode = kCAAnimationPaced;//使得动画均匀进行
            //动画结束不被移除
            animation.fillMode = kCAFillModeForwards;
            animation.removedOnCompletion = NO;
            animation.rotationMode = kCAAnimationRotateAuto;
            animation.duration = duration;
            //设置动画路径
            CGMutablePathRef path = CGPathCreateMutable();

            CGFloat start = ANGLE2RADIAN(self.endAngle - self.startAngle)*self.currentProgress + ANGLE2RADIAN(self.startAngle);
            CGFloat end = ANGLE2RADIAN(self.endAngle - self.startAngle)*progress + ANGLE2RADIAN(self.startAngle);

            CGPathAddArc(path,
                         NULL,
                         self.centerPoint.x,
                         self.centerPoint.y,
                         self.radius,
                         start,
                         end,
                         self.currentProgress > progress);
            animation.path = path;
            
            CGPathRelease(path);
            [self.cursorView.layer addAnimation:animation
                                   forKey:@"moveCursor"];
            
            
            
            
        }
    }
    _currentProgress = progress;
}

@end
