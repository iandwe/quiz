//
//  HelloWorldLayer.m
//  CatRace
//
//  Created by Ray Wenderlich on 4/23/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"
#import "AXLAppDelegate.h"
#import "GameViewController.h"
#import <GameKit/GameKit.h>
#import "SBJson.h"
// HelloWorldLayer implementation
@implementation HelloWorldLayer {
    

}
@synthesize questionLabel;
@synthesize answerLabel;
@synthesize answerTwo;
@synthesize btnOne;
@synthesize btnTwo;
@synthesize btnThree;
@synthesize btnFour;



-(void)viewDidLoad {
    
    turn = 0;
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"questions" ofType:@"json"];
    NSString *jsonString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    SBJsonParser *jsonParser = [SBJsonParser new];
    dict = [jsonParser objectWithString:jsonString];
    NSLog(@"json %@", [[dict objectForKey:@"questions"] objectAtIndex:turn]);
    questionDict = [[dict objectForKey:@"questions"] objectAtIndex:turn];
    [self setQuestionsWithDict:questionDict];
}


- (void)restartTapped:(id)sender {
    
    // Reload the current scene
    /*[[CCDirector sharedDirector] replaceScene:[CCTransitionZoomFlipX transitionWithDuration:0.5 scene:[HelloWorldLayer scene]]];*/
    
}

// Helper code to show a menu to restart the level






- (IBAction)testMove:(UIButton*)sender {
    turn++;
    playerRounds++;
    NSLog(@"playerrounds1 %d", playerRounds);
    if (turn == 3) {
        
        [self checkPlayerOneAnswerWithTag:sender.tag];
       
        
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
    NSLog(@"tag och correct %d %d", tag, correctAnswer);
    if (tag == correctAnswer) {
        answerLabel.text = @"Rätt Svar";
        playerOneCorrectAnswers++;
        NSLog(@"correct  %d", playerOneCorrectAnswers);
    }
    else {
        answerLabel.text = @"Fel Svar";
        
    }
    
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
    questionLabel.text = [dictionary valueForKey:@"question"];
    [btnOne setTitle:[dictionary valueForKey:@"answerOne"] forState:UIControlStateNormal];
     [btnTwo setTitle:[dictionary valueForKey:@"answerTwo"] forState:UIControlStateNormal];
     [btnThree setTitle:[dictionary valueForKey:@"answerThree"] forState:UIControlStateNormal];
     [btnFour setTitle:[dictionary valueForKey:@"answerFour"] forState:UIControlStateNormal];
        correctAnswer = [[dictionary valueForKey:@"correct"] intValue];
}
- (void)viewDidUnload {
    [self setAnswerLabel:nil];
    [self setAnswerTwo:nil];
    [self setBtnOne:nil];
    [self setBtnTwo:nil];
    [self setBtnThree:nil];
    [self setBtnFour:nil];
    [self setQuestionLabel:nil];
    [super viewDidUnload];
}
@end
