//
//  GameViewController.h
//  CatRace
//
//  Created by Axel Lundbäck on 2012-11-26.
//
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface GameViewController : UIViewController<NSFetchedResultsControllerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (retain, nonatomic) IBOutlet UILabel *playerOneNameLabel;
@property (retain, nonatomic) IBOutlet UILabel *playerTwoNameLabel;

@property (retain, nonatomic) IBOutlet UILabel *playerOneScoreLabel;
@property (retain, nonatomic) IBOutlet UILabel *playerTwoScoreLabel;

@property (retain, nonatomic) NSString *answerOne;
@property (retain, nonatomic) NSString *answerTwo;
@property (retain, nonatomic) NSString *nameTwo;
@property (retain, nonatomic) NSString *nameOne;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (readonly) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) IBOutlet UITableView *myTableView;

@end
