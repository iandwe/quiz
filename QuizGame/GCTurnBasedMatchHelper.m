//
//  GCTurnBasedMatchHelper.m
//  quiz
//
//  Created by Axel Lundbäck on 2012-11-27.
//  Copyright (c) 2012 Axel Lundbäck. All rights reserved.
//

#import "GCTurnBasedMatchHelper.h"
#import "AXLAppDelegate.h"

@implementation GCTurnBasedMatchHelper
@synthesize delegate;
@synthesize gameCenterAvailable;
@synthesize currentMatch;
@synthesize isPlayerOne;
#pragma mark Initialization

static GCTurnBasedMatchHelper *sharedHelper = nil;
+ (GCTurnBasedMatchHelper *) sharedInstance {
    if (!sharedHelper) {
        sharedHelper = [[GCTurnBasedMatchHelper alloc] init];
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

- (void) loadPlayerData: (NSArray *) identifiers
{
    [GKPlayer loadPlayersForIdentifiers:identifiers withCompletionHandler:^(NSArray *players, NSError *error) {
        if (error != nil)
        {
            // Handle the error.
        }
        if (players != nil)
        {
            // Process the array of GKPlayer objects.
            NSLog(@"players %@", players);
        }
    }];
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

- (void)authenticationChanged {
    
    if ([GKLocalPlayer localPlayer].isAuthenticated &&
        !userAuthenticated) {
        NSLog(@"Authentication changed: player authenticated.");
        //[self loadPlayerData:[GKLocalPlayer localPlayer].]
        userAuthenticated = TRUE;
        [delegate userDidAuthenticate];
        
        
    } else if (![GKLocalPlayer localPlayer].isAuthenticated &&
               userAuthenticated) {
        NSLog(@"Authentication changed: player not authenticated");
        userAuthenticated = FALSE;
    }
    
}

#pragma mark User functions

- (void)authenticateLocalUser {
    
    if (!gameCenterAvailable) return;
    
    void (^setGKEventHandlerDelegate)(NSError *) = ^ (NSError *error)
    {
        NSLog(@"delegate handler");
        GKTurnBasedEventHandler *ev =
        [GKTurnBasedEventHandler sharedTurnBasedEventHandler];
        ev.delegate = self;
    };

    NSLog(@"Authenticating local user...");
    if ([GKLocalPlayer localPlayer].authenticated == NO) {
        [[GKLocalPlayer localPlayer]
         authenticateWithCompletionHandler:
         setGKEventHandlerDelegate];
    } else {
        NSLog(@"Already authenticated!");
        setGKEventHandlerDelegate(nil);
         [delegate userDidAuthenticate];
    }
    
    
}

- (void)findMatchWithMinPlayers:(int)minPlayers
                     maxPlayers:(int)maxPlayers
                 viewController:(UIViewController *)viewController {
    if (!gameCenterAvailable) return;
    
    presentingViewController = viewController;
    
    GKMatchRequest *request = [[GKMatchRequest alloc] init];
    request.minPlayers = minPlayers;
    request.maxPlayers = maxPlayers;
    
    GKTurnBasedMatchmakerViewController *mmvc =
    [[GKTurnBasedMatchmakerViewController alloc]
     initWithMatchRequest:request];
    mmvc.turnBasedMatchmakerDelegate = self;
    mmvc.showExistingMatches = YES;

    [presentingViewController presentModalViewController:mmvc
                                                animated:YES];
}

#pragma mark GKTurnBasedMatchmakerViewControllerDelegate

-(void)turnBasedMatchmakerViewController:
(GKTurnBasedMatchmakerViewController *)viewController
                            didFindMatch:(GKTurnBasedMatch *)match {
    [presentingViewController
     dismissModalViewControllerAnimated:YES];
    self.currentMatch = match;
    GKTurnBasedParticipant *firstParticipant =
    [match.participants objectAtIndex:0];
    if (firstParticipant.lastTurnDate == NULL) {
        // It's a new game!
        [delegate enterNewGame:match];
    } else {
        if ([match.currentParticipant.playerID
             isEqualToString:[GKLocalPlayer localPlayer].playerID]) {
            // It's your turn!
            [delegate takeTurn:match];
        } else {
            // It's not your turn, just display the game state.
            [delegate layoutMatch:match];
        }
    }
    [self lookupPlayers];
}

-(void)turnBasedMatchmakerViewControllerWasCancelled:
(GKTurnBasedMatchmakerViewController *)viewController {
    [presentingViewController
     dismissModalViewControllerAnimated:YES];
    NSLog(@"has cancelled");
}

-(void)turnBasedMatchmakerViewController:
(GKTurnBasedMatchmakerViewController *)viewController
                        didFailWithError:(NSError *)error {
    [presentingViewController
     dismissModalViewControllerAnimated:YES];
    NSLog(@"Error finding match: %@", error.localizedDescription);
}

-(void)turnBasedMatchmakerViewController:
(GKTurnBasedMatchmakerViewController *)viewController
                      playerQuitForMatch:(GKTurnBasedMatch *)match {
    NSUInteger currentIndex =
    [match.participants indexOfObject:match.currentParticipant];
    GKTurnBasedParticipant *part;
    
    for (int i = 0; i < [match.participants count]; i++) {
        part = [match.participants objectAtIndex:
                (currentIndex + 1 + i) % match.participants.count];
        if (part.matchOutcome != GKTurnBasedMatchOutcomeQuit) {
            break;
        }
    }
    NSLog(@"playerquitforMatch, %@, %@",
          match, match.currentParticipant);
    [match participantQuitInTurnWithOutcome:
     GKTurnBasedMatchOutcomeQuit nextParticipant:part
                                  matchData:match.matchData completionHandler:nil];
}

#pragma mark GKTurnBasedEventHandlerDelegate

-(void)handleInviteFromGameCenter:(NSArray *)playersToInvite {
    [presentingViewController
     dismissModalViewControllerAnimated:YES];
    GKMatchRequest *request =
    [[GKMatchRequest alloc] init];
    request.playersToInvite = playersToInvite;
    request.maxPlayers = 2;
    request.minPlayers = 2;
    GKTurnBasedMatchmakerViewController *viewController =
    [[GKTurnBasedMatchmakerViewController alloc]
     initWithMatchRequest:request];
    viewController.showExistingMatches = NO;
    viewController.turnBasedMatchmakerDelegate = self;
    [presentingViewController
     presentModalViewController:viewController animated:YES];
}
- (void)lookupPlayers {
    
    AXLAppDelegate *appDel = (AXLAppDelegate*)[[UIApplication sharedApplication] delegate];
   
    NSMutableArray *playerIDs = [NSMutableArray arrayWithCapacity:currentMatch.participants.count];
    for (GKTurnBasedParticipant *part in currentMatch.participants) {
        if([part.playerID isKindOfClass:[NSString class]]){
            [playerIDs addObject:part.playerID];
        }
    }
    
    
    [GKPlayer loadPlayersForIdentifiers:playerIDs withCompletionHandler:^(NSArray *players, NSError *error) {
        for (GKPlayer *player in players) {
            
            //get the aliases
            NSLog(@"playeralias %@", player.alias);
            GKPlayer *aPlayer = [players objectAtIndex:1];
            if([[GKLocalPlayer localPlayer].alias isEqualToString:aPlayer.alias])
            {
                aPlayer = [players objectAtIndex:0];
                isPlayerOne = NO;
            }
            else {
                isPlayerOne = YES;
            }
            appDel.oponentName = aPlayer.alias;
        }
        
        
    }];
   
}
     
-(void)handleTurnEventForMatch:(GKTurnBasedMatch *)match {
    NSLog(@"Turn has happened");
    if ([match.matchID isEqualToString:currentMatch.matchID]) {
        if ([match.currentParticipant.playerID
             isEqualToString:[GKLocalPlayer localPlayer].playerID]) {
            // it's the current match and it's our turn now
            self.currentMatch = match;
            [delegate takeTurn:match];
        } else {
            // it's the current match, but it's someone else's turn
            self.currentMatch = match;
            [delegate layoutMatch:match];
        }
    } else {
        if ([match.currentParticipant.playerID
             isEqualToString:[GKLocalPlayer localPlayer].playerID]) {
            // it's not the current match and it's our turn now
            [delegate sendNotice:@"It's your turn for another match"
                        forMatch:match];
        } else {
            // it's the not current match, and it's someone else's
            // turn
        }
    }
}

-(void)handleMatchEnded:(GKTurnBasedMatch *)match {
    NSLog(@"Game has ended");
    if ([match.matchID isEqualToString:currentMatch.matchID]) {
        [delegate recieveEndGame:match];
    } else {
        [delegate sendNotice:@"Another Game Ended!" forMatch:match];
    }
}
@end
