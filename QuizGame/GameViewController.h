//
//  GameViewController.h
//  CatRace
//
//  Created by Axel Lundbäck on 2012-11-26.
//
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "GCTurnBasedMatchHelper.h"

@interface GameViewController : UIViewController<NSFetchedResultsControllerDelegate, UITableViewDataSource, UITableViewDelegate, GCTurnBasedMatchHelperDelegate>
{
    BOOL playBtnShouldBeHidden;
    BOOL havestartedgame;
}

@property (retain, nonatomic) IBOutlet UILabel *playerOneNameLabel;
@property (retain, nonatomic) IBOutlet UILabel *playerTwoNameLabel;

@property (retain, nonatomic) IBOutlet UILabel *playerOneScoreLabel;
@property (retain, nonatomic) IBOutlet UILabel *playerTwoScoreLabel;

@property (retain, nonatomic) NSString *answerOne;
@property (retain, nonatomic) NSString *answerTwo;
@property (retain, nonatomic) NSString *nameTwo;
@property (retain, nonatomic) NSString *nameOne;
@property (readonly) NSManagedObjectContext *context;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (readonly) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
- (IBAction)menuBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *playBtnOutlet;
@property (weak, nonatomic) IBOutlet UIButton *playbtnaction;
- (IBAction)playbtnaction:(id)sender;

@end
