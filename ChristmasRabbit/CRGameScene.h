//
//  CRGameScene.h
//  ChristmasRabbit
//
//  Created by xiefei on 14/12/10.
//  Copyright (c) 2014年 xiefei. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "GameViewController.h"
@interface CRGameScene : SKScene
{
    
    float currentBellY;//当前铃铛
    int currentBellTag;//当前铃铛tag
    float currentMaxBellStep;//当前最大铃铛梯级
    int currentBonusBellIndex;//当前奖励铃铛的索引
    int currentBonusType;//当前奖励类型
    int BellCount;//铃铛的数量
    
    BOOL gameSuspended;//游戏悬浮
    BOOL birdLookingRight;//鸟的样子正确
    BOOL yesno;
    float fallRange;
@public
    BOOL musicOff;
    GameViewController *rootControl;
    SKScene *previousScene;
    
}

@end
