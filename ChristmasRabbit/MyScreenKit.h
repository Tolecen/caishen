//
//  MyScreenKit.h
//  SpriteKitTest
//
//  Created by Zenny Chen on 14-9-24.
//  Copyright (c) 2014年 Adwo. All rights reserved.
//

#import <UIKit/UIKit.h>

enum MY_SCREEN_KIT_BASE_WIDTH_PIXEL_WIDTH
{
    MY_SCREEN_KIT_BASE_WIDTH_PIXEL_WIDTH_640 = 640,
    MY_SCREEN_KIT_BASE_WIDTH_PIXEL_WIDTH_750 = 750,
    MY_SCREEN_KIT_BASE_WIDTH_PIXEL_WIDTH_1242 = 1242
};

@interface MyScreenKit : NSObject
{
@private
    
    CGFloat mScaleFactor;
    
@public
    
    CGFloat iScreenScale;
    CGSize iScreenSize;
    BOOL iIsiPad;
    NSString *lang;
}

/** 以一个基准屏幕像素宽度来建立一个ScreenKit单例
 * @param baseWidthInPixel 基准屏幕像素宽度
*/
+ (void)setupScreenKit:(enum MY_SCREEN_KIT_BASE_WIDTH_PIXEL_WIDTH)baseWidthInPixel;

/**
 * 获取ScreenKit的单例对象
 * @return ScreenKit的单例对象
*/
+ (MyScreenKit *)getInstance;

/**
 * 根据源像素值获得当前屏幕相对点的值
*/
- (CGFloat)relativePointValue:(CGFloat)basePixelValue;

/**
 * 获得屏幕宽高（以点的形式）
*/
- (CGSize)getScreenSizeInPoint;

@end

