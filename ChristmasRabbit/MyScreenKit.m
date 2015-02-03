//
//  MyScreenKit.m
//  SpriteKitTest
//
//  Created by Zenny Chen on 14-9-24.
//  Copyright (c) 2014年 Adwo. All rights reserved.
//

#import "MyScreenKit.h"

@implementation MyScreenKit

static MyScreenKit *sScreenKit;

+ (void)setupScreenKit:(enum MY_SCREEN_KIT_BASE_WIDTH_PIXEL_WIDTH)baseWidthInPixel
{
    
    if(sScreenKit != nil)
        return;
    
    sScreenKit = [[MyScreenKit alloc] init];
    
    UIScreen *mainScreen = [UIScreen mainScreen];
    CGFloat scale = mainScreen.scale;
    CGSize size = mainScreen.bounds.size;
    
    if([mainScreen respondsToSelector:@selector(nativeScale)])
    {
        scale = mainScreen.nativeScale;
        size = mainScreen.nativeBounds.size;
    }
    else
    {
        size.width *= scale;
        size.height *= scale;
    }
    
    sScreenKit->iScreenScale = scale;
    sScreenKit->iScreenSize = size;
    sScreenKit->mScaleFactor = size.width / (CGFloat)baseWidthInPixel / scale;
    sScreenKit->iIsiPad = [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad;
    
   
    if([[sScreenKit currentLanguage] compare:@"zh-Hans" options:NSCaseInsensitiveSearch]==NSOrderedSame || [[sScreenKit currentLanguage] compare:@"zh-Hant" options:NSCaseInsensitiveSearch]==NSOrderedSame)
    {
        sScreenKit->lang = @"ch";
        NSLog(@"current Language == Chinese");
    }else{
        sScreenKit->lang = @"en";
        NSLog(@"current Language == English");
        
    }
    
    
}


-(NSString*)currentLanguage
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *languages = [defaults objectForKey:@"AppleLanguages"];
    NSString *currentLang = [languages objectAtIndex:0];
    return currentLang;
}


+ (MyScreenKit *)getInstance
{
    return sScreenKit;
}

- (CGFloat)relativePointValue:(CGFloat)basePixelValue
{
    NSLog(@"mScaleFactor=%f",mScaleFactor);
    
    return basePixelValue * mScaleFactor;
}

- (CGSize)getScreenSizeInPoint
{
    CGSize size = iScreenSize;
    size.width /= iScreenScale;
    size.height /= iScreenScale;
    
    return size;
}

@end


