//
//  QuizViewController.h
//  quiz
//
//  Created by Axel Lundbäck on 2012-11-27.
//  Copyright (c) 2012 Axel Lundbäck. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCTurnBasedMatchHelper.h"


@interface QuizViewController : UIViewController<UITextFieldDelegate>
{

    NSInteger answerTag;
    BOOL alreadyanswered;
    float time;
    NSTimer *timer;
    BOOL timedOut;
    BOOL alreadyFetchedQuestions;
    NSDictionary *totalQuestionDict;
}

- (IBAction)sendTurn:(id)sender;
- (IBAction)goBack:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *questionLabel;
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;

@property (strong, nonatomic) IBOutlet UIButton *btnOne;
@property (strong, nonatomic) IBOutlet UIButton *btnTwo;
@property (strong, nonatomic) IBOutlet UIButton *btnThree;
@property (strong, nonatomic) IBOutlet UIButton *btnFour;
@property (strong, nonatomic) GKTurnBasedEventHandler *ev;
@property (readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSString *category;


@property (readonly) NSManagedObjectContext *context;

@property (weak, nonatomic) IBOutlet UIView *box1;
@property (weak, nonatomic) IBOutlet UIView *box2;
@property (weak, nonatomic) IBOutlet UIView *box3;



- (IBAction)findPlayers:(id)sender;
- (IBAction)answerBtnPressed:(UIButton*)sender;
- (IBAction)nextQAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *nextQoutlet;

@property (weak, nonatomic) IBOutlet UIProgressView *progressBar;

@end
