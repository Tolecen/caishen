//
//  CRMainMenuScene.h
//  ChristmasRabbit
//
//  Created by xiefei on 14/12/9.
//  Copyright (c) 2014年 xiefei. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "GameViewController.h"
#import <GameKit/GameKit.h>

@interface CRMainMenuScene : SKScene<GKGameCenterControllerDelegate>
{
    BOOL haveShow;
    @public
    GameViewController *rootViewControl;
}
@end
