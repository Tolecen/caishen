//
//  CRHistoryScoresScene.m
//  ChristmasRabbit
//
//  Created by xiefei on 14/12/9.
//  Copyright (c) 2014年 xiefei. All rights reserved.
//

#import "CRHistoryScoresScene.h"
#import "MyScreenKit.h"
#define HISTORY_SCORES_KEY @"historyscores"
#import "GCHelper.h"
@implementation CRHistoryScoresScene
-(id)initWithSize:(CGSize)size
{
    self=[super initWithSize:size];
    if (self) {
        [self setBackgroundColor:[UIColor blueColor]];
        SKSpriteNode *backNode =[SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"gamesceneback"]];
        backNode.zPosition = -2;
        backNode.size = self.size;
        backNode.position = CGPointMake(self.size.width/2.0f, self.size.height/2.0f);
        [self addChild:backNode];
    }
    return self;
}
#pragma mark SKScene delegate

-(void)didMoveToView:(SKView *)view {
    
    /* Setup your scene here */
    [self setBackgroundColor:[UIColor orangeColor]];
    
    
    
    UIButton *buttonBack=[UIButton buttonWithType:UIButtonTypeCustom];
    [buttonBack addTarget:self action:@selector(stopBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [buttonBack setTitle:@"返回" forState:UIControlStateNormal];
    [buttonBack setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_%@",@"backbtn",[MyScreenKit getInstance]->lang]] forState:UIControlStateNormal];
    [buttonBack setBackgroundColor:[UIColor clearColor]];
    [buttonBack setFrame:CGRectMake(30.0f, 20.0f, 160.0f/2.0f, 49.0/1.5f)];
    [self.view addSubview:buttonBack];

    
    NSArray *arrayScores=[[NSUserDefaults standardUserDefaults] objectForKey:HISTORY_SCORES_KEY];
    
    
    for (int i=0; i<[arrayScores count]; i++) {
        
        SKLabelNode *labelNode = [[SKLabelNode alloc] init];
        [labelNode setPosition:CGPointMake(self.size.width/2.0f, self.size.height-i*40-90)];
        [labelNode setText:[NSString stringWithFormat:@"%@ 元",[arrayScores objectAtIndex:i]]];
        [self addChild:labelNode];
        
    }
    
    [[GCHelper sharedInstance] retrieveTopTenScores];
    
    
}
-(void)stopBtnClick:(UIButton *)sender
{
    [sender removeFromSuperview];
    [self.view presentScene:previousScene];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    
    
}

-(void)update:(CFTimeInterval)currentTime {
    
    
    
    /* Called before each frame is rendered */
}

@end
