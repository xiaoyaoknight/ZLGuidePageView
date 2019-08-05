//
//  NSUserDefaults+LaunchGuide.h
//  GuidePage-Demo
//
//  Created by 王泽龙 on 2019/8/5.
//  Copyright © 2019 王泽龙. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSUserDefaults (LaunchGuide)

/**
 * 是否显示引导页面
 */
- (BOOL)needShowGuide;


/**
 * 是否显示引导页面(needShowGuide YES 展示)
 */
- (void)setNeedShowGuide:(BOOL)needShowGuide;
@end

NS_ASSUME_NONNULL_END
