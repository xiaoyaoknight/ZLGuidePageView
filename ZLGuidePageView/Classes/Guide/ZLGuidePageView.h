//
//  ZLGuidePageView.h
//  GuidePage-Demo
//
//  Created by 王泽龙 on 2019/8/2.
//  Copyright © 2019 王泽龙. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^GuidePageCallBack)(void);

NS_ASSUME_NONNULL_BEGIN

#define BOOLFORKEY @"dhGuidePage"
#define DDHidden_TIME   3.0

@interface ZLGuidePageView : UIView

/**
 引导结束回调
 */
@property (nonatomic, copy) GuidePageCallBack guidePageCallBack;

/**
 跳过按钮
 */
@property (nonatomic, strong) UIButton *skipButton;

/**
 开始体验按钮
 */
@property (nonatomic, strong) UIButton *startButton;

/**
 PageControl
 */
@property (nonatomic, strong) UIPageControl *imagePageControl;

/**
 *  是否支持滑动进入APP(视频引导页不支持滑动进入APP)
 */
@property (nonatomic, assign) BOOL slideInto;

/**
 快捷创建引导页

 @param frame              frame
 @param imageNameArray     图片数组
 @param hideStartButton    是否隐藏立即体验按钮
 @return                   instancetype
 */
- (instancetype)initWithFrame:(CGRect)frame imageNameArray:(NSArray<NSString *> *)imageNameArray hideStartButton:(BOOL)hideStartButton;

/**
 *  快捷创建引导页(视频引导页)
 *
 *  @param frame    位置大小
 *  @param videoURL 引导页视频地址
 *
 *  @return         instancetype
 */
- (instancetype)initWithFrame:(CGRect)frame videoURL:(NSURL *)videoURL;
@end

NS_ASSUME_NONNULL_END
