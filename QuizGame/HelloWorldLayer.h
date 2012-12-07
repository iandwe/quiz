//
//  HelloWorldLayer.h
//  CatRace
//
//  Created by Ray Wenderlich on 4/23/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//


// When you import this file, you import all the cocos2d classes

//#import "GCHelper.h"



// HelloWorldLayer
@interface HelloWorldLayer : UIViewController 
{
    int correctAnswer;
    int playerOneCorrectAnswers;
    int playerTwoCorrectAnswers;
    int playerRounds;
           
    NSDictionary *dict;
    NSDictionary *questionDict;
    int turn;

    
}
@property (retain, nonatomic) IBOutlet UILabel *questionLabel;

- (IBAction)testMove:(UIButton*)sender;
@property (retain, nonatomic) IBOutlet UILabel *answerLabel;
@property (retain, nonatomic) IBOutlet UILabel *answerTwo;
@property (retain, nonatomic) IBOutlet UIButton *btnOne;
@property (retain, nonatomic) IBOutlet UIButton *btnTwo;
@property (retain, nonatomic) IBOutlet UIButton *btnThree;
@property (retain, nonatomic) IBOutlet UIButton *btnFour;

// returns a CCScene that contains the HelloWorldLayer as the only child
//+(CCScene *) scene;

@end
