//
//  NSUserDefaults+LaunchGuide.m
//  GuidePage-Demo
//
//  Created by 王泽龙 on 2019/8/5.
//  Copyright © 2019 王泽龙. All rights reserved.
//

#import "NSUserDefaults+LaunchGuide.h"

static NSString *GuideKey = @"GuideKey";

@implementation NSUserDefaults (LaunchGuide)

- (BOOL)needShowGuide {
    return [[NSUserDefaults standardUserDefaults] objectForKey:[self guideKey]] ? [[NSUserDefaults standardUserDefaults] boolForKey:[self guideKey]] : YES;
}

- (void)setNeedShowGuide:(BOOL)needShowGuide {
    [[NSUserDefaults standardUserDefaults] setBool:needShowGuide forKey:[self guideKey]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)guideKey {
    NSString *key = [GuideKey stringByAppendingString:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    return key;
}

@end
