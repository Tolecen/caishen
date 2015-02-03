//
//  GameViewController.m
//  ChristmasRabbit
//
//  Created by xiefei on 14/12/3.
//  Copyright (c) 2014年 xiefei. All rights reserved.
//

#import "GameViewController.h"
#import "CRMainMenuScene.h"
#import <GameKit/GameKit.h>
#import "AdMoGoDelegateProtocol.h"
#import "AdMoGoWebBrowserControllerUserDelegate.h"
#import "GCHelper.h"
#import "AppDelegate.h"

#define MoGo_ID_IPhone @"3bb4c46001de41ffb578ff772ca10650"



static BOOL g_isGameCenterInit = NO;
#define SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] \
compare:v options:NSNumericSearch] == NSOrderedAscending)



@interface GameViewController()<AdMoGoDelegate,AdMoGoWebBrowserControllerUserDelegate,GCHelperDelegate>
{
   

}
@end

@implementation SKScene (Unarchive)

+ (instancetype)unarchiveFromFile:(NSString *)file {
    
    /* Retrieve scene file path from the application bundle */
    NSString *nodePath = [[NSBundle mainBundle] pathForResource:file ofType:@"sks"];
    /* Unarchive the file to an SKScene object */
    NSData *data = [NSData dataWithContentsOfFile:nodePath
                                          options:NSDataReadingMappedIfSafe
                                            error:nil];
    NSKeyedUnarchiver *arch = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    [arch setClass:self forClassName:@"SKScene"];
    SKScene *scene = [arch decodeObjectForKey:NSKeyedArchiveRootObjectKey];
    [arch finishDecoding];
    
    return scene;
    
}

@end

@implementation GameViewController
-(void)authenticationChanged
{
    
    if ([GKLocalPlayer localPlayer].isAuthenticated ) {
        NSLog(@"Authentication changed: player authenticated.");
    } else if (![GKLocalPlayer localPlayer].isAuthenticated ) {
        NSLog(@"Authentication changed: player not authenticated");
    }
    
}
-(instancetype)init
{
    self=[super init];
    if (self) {
        
 

    }
    return self;
}
- (void)viewDidLoad
{
    
    [super viewDidLoad];

    
    NSNotificationCenter *nc =
    [NSNotificationCenter defaultCenter];
    [nc addObserver:self
           selector:@selector(authenticationChanged)
               name:GKPlayerAuthenticationDidChangeNotificationName
             object:nil];
    
    
//    NSMutableArray *arrayPlayers=[[NSMutableArray alloc] init];
//    if ([self isGameCenterAvailable]) {
//        [self authenticateLocalPlayer];
//        [self loadPlayerData:arrayPlayers];
//    }
//    
//    NSLog(@"arrayPlayers=%@",arrayPlayers);
    
    
    // Configure the view.
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = NO;
    skView.showsNodeCount = NO;
    /* Sprite Kit applies additional optimizations to improve rendering performance */
    skView.ignoresSiblingOrder = YES;
    
    NSLog(@"size w=%f h=%f",skView.frame.size.width,skView.frame.size.height);
    
    // Create and configure the scene.
    
    
    CRMainMenuScene *menuScene=[[CRMainMenuScene alloc] initWithSize:skView.frame.size];
    menuScene->rootViewControl = self;
    menuScene.scaleMode = SKSceneScaleModeAspectFill;
    [skView presentScene:menuScene];
    
    
    
    adMoGoView = [[AdMoGoView alloc] initWithAppKey:MoGo_ID_IPhone adType:AdViewTypeNormalBanner adMoGoViewDelegate:self];
    adMoGoView.adWebBrowswerDelegate = self;
    adMoGoView.frame = CGRectMake(0.0, self.view.frame.size.height-50.0f, 320.0, 50.0);
    [adMoGoView setViewPointType:AdMoGoViewPointTypeDown_middle];
    [adMoGoView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:adMoGoView];
    
    
//    GameScene *scene = [[GameScene alloc] initWithSize:skView.frame.size];
//    scene.scaleMode = SKSceneScaleModeAspectFill;
//    
//    
//    // Present the scene.
//    [skView presentScene:scene];
    
//           [[GCHelper sharedInstance] findMatchWithMinPlayers:2 maxPlayers:2 viewController:self delegate:self];
    
}
#pragma mark gamecenter
#pragma mark -
#pragma mark AdMoGoDelegate delegate
/*
 返回广告rootViewController
 */
- (UIViewController *)viewControllerForPresentingModalView{
    return self;
}


/**
 * 广告开始请求回调
 */
- (void)adMoGoDidStartAd:(AdMoGoView *)adMoGoView{
    NSLog(@"广告开始请求回调");
}
/**
 * 广告接收成功回调
 */
- (void)adMoGoDidReceiveAd:(AdMoGoView *)adMoGoView{
    NSLog(@"广告接收成功回调");
}
/**
 * 广告接收失败回调
 */
- (void)adMoGoDidFailToReceiveAd:(AdMoGoView *)adMoGoView didFailWithError:(NSError *)error{
    NSLog(@"广告接收失败回调");
}
/**
 * 点击广告回调
 */
- (void)adMoGoClickAd:(AdMoGoView *)adMoGoView{
    NSLog(@"点击广告回调");
}
/**
 *You can get notified when the user delete the ad
 广告关闭回调
 */
- (void)adMoGoDeleteAd:(AdMoGoView *)adMoGoView{
    NSLog(@"广告关闭回调");
}

#pragma mark -
#pragma mark AdMoGoWebBrowserControllerUserDelegate delegate

/*
 浏览器将要展示
 */
- (void)webBrowserWillAppear{
    NSLog(@"浏览器将要展示");
}

/*
 浏览器已经展示
 */
- (void)webBrowserDidAppear{
    NSLog(@"浏览器已经展示");
}

/*
 浏览器将要关闭
 */
- (void)webBrowserWillClosed{
    NSLog(@"浏览器将要关闭");
}

/*
 浏览器已经关闭
 */
- (void)webBrowserDidClosed{
    NSLog(@"浏览器已经关闭");
}
/**
 *直接下载类广告 是否弹出Alert确认
 */
-(BOOL)shouldAlertQAView:(UIAlertView *)alertView{
    return NO;
}

- (void)webBrowserShare:(NSString *)url{
    
}


- (BOOL)isGameCenterAvailable

{
    
    Class gcClass = (NSClassFromString(@"GKLocalPlayer"));
    
    NSString *reqSysVer = @"4.1";
    
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    
    BOOL osVersionSupported = ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending);
    
    
    return (gcClass && osVersionSupported);
    
}

/*
 
 Whether you received player identifiers by loading the identifiers for the local player’s
 
 friends, or from another Game Center class, you must retrieve the details about that player
 
 from Game Center.
 
 */

- (void) loadPlayerData: (NSArray *) identifiers

{
    
    [GKPlayer loadPlayersForIdentifiers:identifiers withCompletionHandler:^(NSArray *players, NSError *error) {
        
        if (error != nil)
            
        {
            
            // Handle the error.
            
        }
        
        if (players != nil)
            
        {
            
            NSLog(@"得到好友的alias成功");
            
            GKPlayer *friend1 = [players objectAtIndex:0];
            
            NSLog(@"friedns---alias---%@",friend1.alias);
            
            NSLog(@"friedns---isFriend---%d",friend1.isFriend);
            
            NSLog(@"friedns---playerID---%@",friend1.playerID);
            
        }
        
    }];
    
}
- (void)authenticateLocalPlayer
{
    
    
//    [[GKLocalPlayer localPlayer] authenticateHandler](UIViewController *viewController, NSError *error){
//    
//    
//        
//    };
    
//    [[GKLocalPlayer localPlayer] generateIdentityVerificationSignatureWithCompletionHandler:^(NSURL *publicKeyUrl,NSData *signature,NSData *salt,uint64_t timestamp,NSError *error){
//       
//    
//    }];
//
    
    [GKLocalPlayer localPlayer].authenticateHandler=^(UIViewController *viewController, NSError *error){
    
        if (error == nil) {
            //成功处理
            NSLog(@"成功");
            NSLog(@"1--alias--.%@",[GKLocalPlayer localPlayer].alias);
            NSLog(@"2--authenticated--.%d",[GKLocalPlayer localPlayer].authenticated);
            NSLog(@"3--isFriend--.%d",[GKLocalPlayer localPlayer].isFriend);
            NSLog(@"4--playerID--.%@",[GKLocalPlayer localPlayer].playerID);
            NSLog(@"5--underage--.%d",[GKLocalPlayer localPlayer].underage);

        }else {
            //错误处理
            NSLog(@"失败  %@",error);
        }
        
//        if (viewController) {
//            [self presentViewController:viewController animated:YES completion:^{
//                
//                
//                
//            }];
//        }
        
    };
    
    
//    [[GKLocalPlayer localPlayer] authenticateWithCompletionHandler:^(NSError *error){
//        if (error == nil) {
//            //成功处理
//            NSLog(@"成功");
//            NSLog(@"1--alias--.%@",[GKLocalPlayer localPlayer].alias);
//            NSLog(@"2--authenticated--.%d",[GKLocalPlayer localPlayer].authenticated);
//            NSLog(@"3--isFriend--.%d",[GKLocalPlayer localPlayer].isFriend);
//            NSLog(@"4--playerID--.%@",[GKLocalPlayer localPlayer].playerID);
//            NSLog(@"5--underage--.%d",[GKLocalPlayer localPlayer].underage);
//        }else {
//            //错误处理
//            NSLog(@"失败  %@",error);
//        }
//    }];
    
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}


#pragma mark GCHelperDelegate

- (void)matchStarted {
    NSLog(@"Match started");
}

- (void)matchEnded {
    NSLog(@"Match ended");
}

- (void)match:(GKMatch *)match didReceiveData:(NSData *)data fromPlayer:(NSString *)playerID {
    NSLog(@"Received data");
}


- (void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController
{
    NSLog(@"rfffff");
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

@end
