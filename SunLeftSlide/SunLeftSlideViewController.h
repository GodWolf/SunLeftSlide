//
//  SunLeftSlideViewController.h
//  SunLeftSlide
//
//  Created by sun on 15/6/26.
//  Copyright (c) 2015年 sunxingxiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SunLeftSlideViewController : UIViewController

/**
 *  初始化侧滑视图控制器
 *
 *  @param mainViewController 主视图控制器
 */
- (instancetype)initWithMainViewController:(UIViewController *)mainViewController;

/**
 *  打开左侧菜单栏
 *
 *  @param animation 是否有动画过程
 */
- (void)openSlideWithAnimation:(BOOL)isAnimation;

/**
 *  关闭左侧菜单栏
 *
 *  @param animation 是否有动画过程
 */
- (void)closeSlideWithAnimation:(BOOL)isAnimation;

/**
 *  打开平移手势
 */
- (void)openSlidePanGesture;

/**
 *  关闭平移手势
 */
- (void)closeSlidePanGesture;

@end
