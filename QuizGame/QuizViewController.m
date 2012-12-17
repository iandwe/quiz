//
//  QuizViewController.m
//  quiz
//
//  Created by Axel Lundbäck on 2012-11-27.
//  Copyright (c) 2012 Axel Lundbäck. All rights reserved.
//

#import "QuizViewController.h"
#import "GameViewController.h"
#import "AXLAppDelegate.h"
#import "SBJsonParser.h"
#import "Round.h"

@interface QuizViewController ()

@end

@implementation QuizViewController {
    NSString *answerOne;
    NSString *answerTwo;
    NSString *nameTwo;
    NSString *nameOne;
    int questionOne;
    int questionTwo;
    int questionThree;
    int turn;
    int correctAnswer;
    int playerOneCorrectAnswers;
    int playerTwoCorrectAnswers;
    int playerRounds;
    int questionArr[3];
    NSDictionary *dict;
    NSDictionary *questionDict;
    BOOL roundExists;
    
}

@synthesize questionLabel, statusLabel, btnFour, btnOne, btnThree, btnTwo, category, managedObjectContext = _managedObjectContext;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
#pragma Core Data
-(NSManagedObjectContext *)context {
    return [AXLSharedContext getSharedContext];
}


-(void)insertNewObject
{
 
    // Create a new instance of the entity managed by the fetched results controller.
    Round *event;
    event = [NSEntityDescription insertNewObjectForEntityForName:@"Round" inManagedObjectContext:self.context];
    
    event.playerOneScore = [NSString stringWithFormat:@"%d", playerOneCorrectAnswers];
    
    event.playerOneDate = [NSDate date];
    event.matchId = [[[GCTurnBasedMatchHelper sharedInstance] currentMatch] matchID];
    event.category = category;
    
    // Save the context.
    NSError *error = nil;
    if (![self.context save:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"View did load quizviewcontroller");
   // [GCTurnBasedMatchHelper sharedInstance].delegate = self;
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"questions" ofType:@"json"];
    NSString *jsonString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    
    SBJsonParser *jsonParser = [SBJsonParser new];
    dict = [jsonParser objectWithString:jsonString];
    
    NSLog(@"json view did load %@", [[dict objectForKey:@"questions"] objectAtIndex:1]);
    questionDict = [[dict objectForKey:@"questions"] objectAtIndex:turn];
    

    [self setQuestionsWithDict:questionDict];
    //mainTextController.text = [NSString stringWithUTF8String:[[[[GCTurnBasedMatchHelper sharedInstance] currentMatch] matchData]bytes]];

    // Do any additional setup after loading the view from its nib.
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)handleTurnEventForMatch:(GKTurnBasedMatch *)match didBecomeActive:(BOOL)didBecomeActive {
    NSLog(@"hej game %@", match);
    
    
}
-(NSManagedObjectContext *)managedObjectContext {
    return [AXLSharedContext getSharedContext];
}

-(void)checkIfCoreDataObjectExists {
    // Fetched saved car.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Round" inManagedObjectContext:[self managedObjectContext]];
    [fetchRequest setEntity:entity];
    
    // Set predicate and sort orderings...
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"matchId = %@",[[[GCTurnBasedMatchHelper sharedInstance] currentMatch] matchID]];
    [fetchRequest setPredicate:predicate];
    
    // Execute the fetch -- create a mutable copy of the result.
    NSError *error = nil;
    NSMutableArray *mutableFetchResults = [[self.managedObjectContext executeFetchRequest:fetchRequest error:&error] mutableCopy];
    NSLog(@"[GameViewController] round: round not found. %d",[mutableFetchResults count] );
    if (mutableFetchResults == nil || [mutableFetchResults count] == 0) {
        // Handle the error.
        NSLog(@"[GameViewController] round: round not found. %d",[mutableFetchResults count] );
    }
    else 
    {
        NSLog(@"uppdatera objekt i ronder");
        int count = [mutableFetchResults count]-1;
        Round *aRound = (Round *)[mutableFetchResults objectAtIndex:count];
        [aRound setPlayerOneScore:[NSString stringWithFormat:@"%d", playerOneCorrectAnswers]];
        [aRound setPlayerOneDate:[NSDate date]];
        // Save the car.
        NSError *error = nil;
        if (![self.managedObjectContext save:&error]) {
            // Handle the error.
            NSLog(@"[GameViewController] round: error saving round.");
        }
        else {
            NSLog(@"[GameViewController] round: round saved.");
        }
               
    }
   
}
- (IBAction)sendTurn:(id)sender {
    
    
    
    
    
    if ([[GCTurnBasedMatchHelper sharedInstance] isPlayerOne])
    {
        NSString *matchId = [[[GCTurnBasedMatchHelper sharedInstance] currentMatch] matchID];
        int count = [[NSUserDefaults standardUserDefaults] integerForKey:matchId];
        count++;
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:matchId];
        [[NSUserDefaults standardUserDefaults] setInteger:count forKey:matchId];
        [self insertNewObject];
    }
    else {
        [self checkIfCoreDataObjectExists];
    }
    
    NSLog(@"send turn");
     NSString *qr = [NSString stringWithFormat:@"%d%d%d", questionArr[0], questionArr[1], questionArr[2]];
    NSLog(@"players %@", [[GCTurnBasedMatchHelper sharedInstance] currentMatch].participants);
    NSString *str = [NSString  stringWithFormat:@"%@%d", qr, [[NSUserDefaults standardUserDefaults] integerForKey:[[[GCTurnBasedMatchHelper sharedInstance] currentMatch] matchID]]];
    [self sendTurnString:str];
    
}





-(void)sendTurnString:(NSString*)string {
    
    NSLog(@"send turnstring");
    GKTurnBasedMatch *currentMatch =
    [[GCTurnBasedMatchHelper sharedInstance] currentMatch];
    NSString *newStoryString;
    
    
 
   
    
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    

    
    NSUInteger currentIndex = [currentMatch.participants
                               indexOfObject:currentMatch.currentParticipant];
    GKTurnBasedParticipant *nextParticipant;
    
    NSUInteger nextIndex = (currentIndex + 1) %
    [currentMatch.participants count];
    nextParticipant = [currentMatch.participants objectAtIndex:nextIndex];
    
    for (int i = 0; i < [currentMatch.participants count]; i++) {
        nextParticipant = [currentMatch.participants
                           objectAtIndex:((currentIndex + 1 + i) %
                                          [currentMatch.participants count ])];
        if (nextParticipant.matchOutcome != GKTurnBasedMatchOutcomeQuit) {
            NSLog(@"isnt' quit %@", nextParticipant);
            break;
        } else {
            NSLog(@"nex part %@", nextParticipant);
        }
    }
    
    if ([data length] > 3800) {
        for (GKTurnBasedParticipant *part in currentMatch.participants) {
            part.matchOutcome = GKTurnBasedMatchOutcomeTied;
        }
        [currentMatch endMatchInTurnWithMatchData:data
                                completionHandler:^(NSError *error) {
                                    if (error) {
                                        NSLog(@"error in send turn string %@", error);
                                    }
                                }];
        statusLabel.text = @"Game has ended";
    } else {
        
        [currentMatch endTurnWithNextParticipant:nextParticipant
                                       matchData:data completionHandler:^(NSError *error) {
                                           if (error) {
                                               NSLog(@"error in data length < 3800 %@", error);
                                               statusLabel.text =
                                               @"Oops, there was a problem.  Try that again.";
                                           } else {
                                               statusLabel.text = @"Your turn is over.";
                                           }
                                       }];
    }
    NSLog(@"Send Turn, %@, %@", data, nextParticipant);
    [self.navigationController popToRootViewControllerAnimated:TRUE];
    //[self performSegueWithIdentifier:@"results" sender:self];
}
/*#pragma mark - GCTurnBasedMatchHelperDelegate

-(void)enterNewGame:(GKTurnBasedMatch *)match {
    NSLog(@"Entering new game...");
    statusLabel.text = @"Player 1's Turn (that's you)";
}

-(void)takeTurn:(GKTurnBasedMatch *)match {
    NSLog(@"Taking turn for existing game...");
    int playerNum = [match.participants
                     indexOfObject:match.currentParticipant] + 1;
    NSString *statusString = [NSString stringWithFormat:
                              @"Player %d's Turn (that's you)", playerNum];
    statusLabel.text = statusString;
    if ([match.matchData bytes]) {
        NSString *storySoFar = [NSString stringWithUTF8String:
                                [match.matchData bytes]];
       
        [[NSUserDefaults standardUserDefaults] setObject:storySoFar forKey:@"score"];
        [self presentGameStatsWithString:storySoFar];
        [self showAlertWithMessage:storySoFar];
    }
  
}
*/
-(void)layoutMatch:(GKTurnBasedMatch *)match {
    NSLog(@"Viewing match where it's not our turn...");
    NSString *statusString;
    
    if (match.status == GKTurnBasedMatchStatusEnded) {
        statusString = @"Match Ended";
    } else {
        int playerNum = [match.participants
                         indexOfObject:match.currentParticipant] + 1;
        statusString = [NSString stringWithFormat:
                        @"Player %d's Turn", playerNum];
    }
    statusLabel.text = statusString;
    
    NSString *storySoFar = [NSString stringWithUTF8String:
                            [match.matchData bytes]];
   
    [[NSUserDefaults standardUserDefaults] setObject:storySoFar forKey:@"score"];
    [self presentGameStatsWithString:storySoFar];
    [self showAlertWithMessage:storySoFar];
    
}
-(void)showAlertWithMessage:(NSString*)message {
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Alert" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [av show];
}
-(void)recieveEndGame:(GKTurnBasedMatch *)match {
    [self layoutMatch:match];
}

-(void)sendNotice:(NSString *)notice forMatch:
(GKTurnBasedMatch *)match {
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:
                       @"Another game needs your attention!" message:notice
                                                delegate:self cancelButtonTitle:@"Sweet!"
                                       otherButtonTitles:nil];
    [av show];
   
}

- (IBAction)goBack:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    NSLog(@"resign");
    return YES;
}



-(void)presentGameStatsWithString:(NSString*)string {
    
     NSLog(@"presentGameStatsWithString");
    answerTwo = [[NSUserDefaults standardUserDefaults] objectForKey:@"score"];;
    
    //[self performSegueWithIdentifier:@"results" sender:self];
    
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"prepareForSegue");
    AXLAppDelegate *appDel = (AXLAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    GameViewController *gv = (GameViewController*)[segue destinationViewController];
    gv.nameOne = [[GKLocalPlayer localPlayer] alias];
    gv.nameTwo = appDel.oponentName;
    gv.answerOne = [NSString stringWithFormat:@"%d %d %d", questionArr[0], questionArr[1], questionArr[2]];
    gv.answerTwo = answerTwo;

}
- (void)viewDidUnload {
   

    [self setStatusLabel:nil];
    [super viewDidUnload];
}
- (IBAction)findPlayers:(id)sender {
    NSLog(@"findPlayers");
    [[GCTurnBasedMatchHelper sharedInstance]
     findMatchWithMinPlayers:2 maxPlayers:2 viewController:self];
}

- (IBAction)answerBtnPressed:(UIButton*)sender {
NSLog(@"answerbtnpressed");
    turn++;
    //playerRounds++;
   // NSLog(@"playerrounds1 %d", playerRounds);
    if (turn == 3) {
        
        [self checkPlayerOneAnswerWithTag:sender.tag];

        
        [self sendTurn:nil];
        
    }
    else {
        
        
        //questionDict = [[dict objectForKey:@"questions"] objectAtIndex:turn];
        
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"questions" ofType:@"json"];
        NSString *jsonString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
        
        SBJsonParser *jsonParser = [SBJsonParser new];
        dict = [jsonParser objectWithString:jsonString];
        
        NSLog(@"json %@", [[dict objectForKey:@"questions"] objectAtIndex:1]);
        questionDict = [[dict objectForKey:@"questions"] objectAtIndex:turn];
        
        [self checkPlayerOneAnswerWithTag:sender.tag];
        [self setQuestionsWithDict:questionDict];
        
        NSLog(@"json %d", turn);
    }
    
    
}

-(void)checkPlayerOneAnswerWithTag:(int)tag {

NSLog(@"checkPlayerOneAnswerWithTag");    
    if (tag == correctAnswer) {
        questionArr[turn-1] = 1;
        playerOneCorrectAnswers++;

        NSString *qr = [NSString stringWithFormat:@"%d%d%d%@", questionArr[0], questionArr[1], questionArr[2], category];
        
    }
    else {
        
        questionArr[turn-1] = 0;
    }
    
   
}

-(void)checkPlayerTwoAnswerWithTag:(int)tag {
    NSLog(@"playerrounds2 %d", playerRounds);
    
    playerTwoCorrectAnswers = tag;
    if (playerRounds == 4) {
        AXLAppDelegate *appDel = (AXLAppDelegate*)[[UIApplication sharedApplication] delegate];
        GameViewController *gv = [[GameViewController alloc] initWithNibName:@"GameViewController" bundle:nil];
        gv.nameOne = [[GKLocalPlayer localPlayer] alias];
        gv.nameTwo = appDel.oponentName;
        gv.answerOne = [NSString stringWithFormat:@"%d", playerOneCorrectAnswers];
        gv.answerTwo = [NSString stringWithFormat:@"%d", playerTwoCorrectAnswers];
        
        [self presentModalViewController:gv animated:YES];
    }
    
}

-(void)setQuestionsWithDict:(NSDictionary*)dictionary {
    NSLog(@"setQuestionsWithDict");
    questionLabel.text = [dictionary valueForKey:@"question"];
    [btnOne setTitle:[dictionary valueForKey:@"answerOne"] forState:UIControlStateNormal];
    [btnTwo setTitle:[dictionary valueForKey:@"answerTwo"] forState:UIControlStateNormal];
    [btnThree setTitle:[dictionary valueForKey:@"answerThree"] forState:UIControlStateNormal];
    [btnFour setTitle:[dictionary valueForKey:@"answerFour"] forState:UIControlStateNormal];
    correctAnswer = [[dictionary valueForKey:@"correct"] intValue];
}
@end
