//
//  StartUpController.m
//  quiz
//
//  Created by Axel Lundbäck on 2012-11-27.
//  Copyright (c) 2012 Axel Lundbäck. All rights reserved.
//

#import "StartUpController.h"
#import "QuizViewController.h"

@interface StartUpController ()

@end

@implementation StartUpController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
          [GCTurnBasedMatchHelper sharedInstance].delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startQuizPressed:(id)sender {
   
}

- (IBAction)signInWithGameCenterPressed:(id)sender {


  
    
}

-(void)enterNewGame:(GKTurnBasedMatch *)match
{

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
   QuizViewController *vc = (QuizViewController*)[segue destinationViewController];
    vc.category = [NSString stringWithFormat:@"%d", 27];
    
}
-(void)userDidAuthenticate {
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"" message:@"kulkul" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
    [av show];
    [[GCTurnBasedMatchHelper sharedInstance]
     findMatchWithMinPlayers:2 maxPlayers:2 viewController:self];
    
}
- (void)viewDidUnload {
    
    [self setStartgameBtn:nil];
    [super viewDidUnload];
}
@end
