//
//  GCHelper.m
//  CatRace
//
//  Created by Ray Wenderlich on 4/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GCHelper.h"

@implementation GCHelper
@synthesize gameCenterAvailable;
@synthesize presentingViewController;
@synthesize match;
@synthesize delegate;

#pragma mark Initialization

static GCHelper *sharedHelper = nil;
+ (GCHelper *) sharedInstance {
    if (!sharedHelper) {
        sharedHelper = [[GCHelper alloc] init];
    }
    return sharedHelper;
}

- (BOOL)isGameCenterAvailable {
	// check for presence of GKLocalPlayer API
	Class gcClass = (NSClassFromString(@"GKLocalPlayer"));
	
	// check if the device is running iOS 4.1 or later
	NSString *reqSysVer = @"4.1";
	NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
	BOOL osVersionSupported = ([currSysVer compare:reqSysVer 
                                           options:NSNumericSearch] != NSOrderedAscending);
	
	return (gcClass && osVersionSupported);
    
}

- (id)init {
    if ((self = [super init])) {
        gameCenterAvailable = [self isGameCenterAvailable];
        if (gameCenterAvailable) {
            NSNotificationCenter *nc = 
            [NSNotificationCenter defaultCenter];
            [nc addObserver:self 
                   selector:@selector(authenticationChanged) 
                       name:GKPlayerAuthenticationDidChangeNotificationName 
                     object:nil];
        }
    }
    return self;
}

#pragma mark score unpload and download
- (void) reportScore: (int64_t) score forLeaderboardID: (NSString*) identifier
{
    GKScore *scoreReporter = [[GKScore alloc] initWithLeaderboardIdentifier: identifier];
    scoreReporter.value = score;
    scoreReporter.context = 0;
    
    NSArray *scores = @[scoreReporter];
    [GKScore reportScores:scores withCompletionHandler:^(NSError *error) {
        if (error!=nil) {
            NSLog(@"上传分数失败：error=%@",error);
        }else
        {
            NSLog(@"上传分数成功！！！");
        }
        //Do something interesting here.
    }];
}

//GKScore objects provide the data your application needs to create a custom view.

//Your application can use the score object’s playerID to load the player’s alias.

//The value property holds the actual value you reported to Game Center. the formattedValue

//property provides a string with the score value formatted according to the parameters

//you provided in iTunes Connect.

- (void) retrieveTopTenScores
{
    
    GKLeaderboard *leaderboardRequest = [[GKLeaderboard alloc] init];
    
    if (leaderboardRequest != nil)
    {
        
        leaderboardRequest.playerScope = GKLeaderboardPlayerScopeGlobal;
        
        leaderboardRequest.timeScope = GKLeaderboardTimeScopeAllTime;
        
        leaderboardRequest.range = NSMakeRange(1,10);
        
        leaderboardRequest.identifier = @"com.caishen.ranking";
        
        [leaderboardRequest loadScoresWithCompletionHandler: ^(NSArray *scores, NSError *error) {
            
            if (error != nil){
                
                // handle the error.
                NSLog(@"下载失败:error=%@ scores＝%@",error,scores);
            }
            
            NSLog(@"scores=%@",scores);
            
            if (scores != nil){
                
                // process the score information.
                
                NSLog(@"下载成功....");
                
                NSArray *tempScore = [NSArray arrayWithArray:leaderboardRequest.scores];
                
                for (GKScore *obj in tempScore) {
                    
                    NSLog(@"    playerID            : %@",obj.playerID);
//                    NSLog(@"    category            : %@",obj.category);
                    NSLog(@"    date                : %@",obj.date);
                    NSLog(@"    formattedValue    : %@",obj.formattedValue);
                    NSLog(@"    value                : %lld",obj.value);
                    NSLog(@"    rank                : %ld",(long)obj.rank);
                    NSLog(@"**************************************");
                    
                }
            }
        }];
    }
}


#pragma mark Internal functions

- (void)authenticationChanged {    
    
    if ([GKLocalPlayer localPlayer].isAuthenticated && !userAuthenticated) {
       NSLog(@"Authentication changed: player authenticated.");
       userAuthenticated = TRUE;           
     }else if (![GKLocalPlayer localPlayer].isAuthenticated && userAuthenticated) {
       NSLog(@"Authentication changed: player not authenticated");
       userAuthenticated = FALSE;
    }
                   
}

#pragma mark User functions

- (void)authenticateLocalUser { 
    
    if (!gameCenterAvailable) return;
    
    NSLog(@"Authenticating local user...");
    if ([GKLocalPlayer localPlayer].authenticated == NO) {
        if ([[UIDevice currentDevice].systemVersion floatValue]<7.0) {
            
            [[GKLocalPlayer localPlayer]authenticateWithCompletionHandler:nil];

        }else
        {
            
//            [GKLocalPlayer localPlayer].authenticateHandler = ^(UIViewController *viewController,NSError *error){
//                
//            };
            
            [[GKLocalPlayer localPlayer] setAuthenticateHandler:(^(UIViewController* viewController, NSError *error) {
//                [[CCDirector sharedDirector] resume];
                
                if (error && error.code == GKErrorCancelled) {
                    NSLog(@"Game Center code:%ld %@", (long)error.code, [error debugDescription]);
//                    [self sendFaild];
                    return ;
                }
                
//                if (localPlayer.isAuthenticated) {
//                    [self sendOk];
//                }
                
                else if (viewController) {
                    
//                    [[CCDirector sharedDirector] pause];
//                    AppDelegate* delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
//                    RootViewController* root = (RootViewController*)delegate.viewController;
//                    [root presentViewController:viewController animated:YES completion:nil];
                    
                    [presentingViewController presentViewController:viewController animated:YES completion:^{
                    
                        
                    }];
                    
                }
                
            })];
        }
        
//            [[GKLocalPlayer localPlayer]authenticateWithCompletionHandler:nil];
        
    } else {
        
        NSLog(@"Already authenticated!");
        
    }
}


- (void)findMatchWithMinPlayers:(int)minPlayers maxPlayers:(int)maxPlayers viewController:(UIViewController *)viewController delegate:(id<GCHelperDelegate>)theDelegate {
    
    if (!gameCenterAvailable) return;
    
    matchStarted = NO;
    self.match = nil;
    self.presentingViewController = viewController;
    delegate = theDelegate;               
    [presentingViewController dismissViewControllerAnimated:NO completion:nil];
    
    
    GKMatchRequest *request = [[[GKMatchRequest alloc] init] autorelease]; 
    request.minPlayers = minPlayers;     
    request.maxPlayers = maxPlayers;
    
    GKMatchmakerViewController *mmvc = [[[GKMatchmakerViewController alloc] initWithMatchRequest:request] autorelease];    
    mmvc.matchmakerDelegate = self;
    
//    [presentingViewController presentModalViewController:mmvc animated:YES];
    [presentingViewController presentViewController:mmvc animated:YES completion:nil];
        
}

#pragma mark GKMatchmakerViewControllerDelegate

// The user has cancelled matchmaking
- (void)matchmakerViewControllerWasCancelled:(GKMatchmakerViewController *)viewController {
    [presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

// Matchmaking has failed with an error
- (void)matchmakerViewController:(GKMatchmakerViewController *)viewController didFailWithError:(NSError *)error {
    
    [presentingViewController dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"Error finding match: %@", error.localizedDescription);
    
}

// A peer-to-peer match has been found, the game should start
- (void)matchmakerViewController:(GKMatchmakerViewController *)viewController didFindMatch:(GKMatch *)theMatch {
    
    [presentingViewController dismissViewControllerAnimated:YES completion:nil];
    self.match = theMatch;
    match.delegate = self;
    if (!matchStarted && match.expectedPlayerCount == 0) {
        NSLog(@"Ready to start match!");
    }
    
}

#pragma mark GKMatchDelegate

// The match received data sent from the player.
- (void)match:(GKMatch *)theMatch didReceiveData:(NSData *)data fromPlayer:(NSString *)playerID {
    
    
    if (match != theMatch) return;
    [delegate match:theMatch didReceiveData:data fromPlayer:playerID];
    
}

// The player state changed (eg. connected or disconnected)
- (void)match:(GKMatch *)theMatch player:(NSString *)playerID didChangeState:(GKPlayerConnectionState)state {
    
    if (match != theMatch) return;
    
    
    
    switch (state) {
            
        case GKPlayerStateConnected: 
            // handle a new player connection.
            NSLog(@"Player connected!");
            
            if (!matchStarted && theMatch.expectedPlayerCount == 0) {
                NSLog(@"Ready to start match!");
            }
            break;
        case GKPlayerStateDisconnected:
            // a player just disconnected. 
            NSLog(@"Player disconnected!");
            matchStarted = NO;
            [delegate matchEnded];
            break;
    }
    
}

// The match was unable to connect with the player due to an error.
- (void)match:(GKMatch *)theMatch connectionWithPlayerFailed:(NSString *)playerID withError:(NSError *)error {
    
    if (match != theMatch) return;
    
    NSLog(@"Failed to connect to player with error: %@", error.localizedDescription);
    matchStarted = NO;
    [delegate matchEnded];
    
}

// The match was unable to be established with any players due to an error.
- (void)match:(GKMatch *)theMatch didFailWithError:(NSError *)error {
    
    if (match != theMatch) return;
    
    NSLog(@"Match failed with error: %@", error.localizedDescription);
    matchStarted = NO;
    [delegate matchEnded];
    
}

@end
