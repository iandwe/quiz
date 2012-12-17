//
//  GameViewController.m
//  CatRace
//
//  Created by Axel Lundbäck on 2012-11-26.
//
//

#import "GameViewController.h"
#import "AXLSharedContext.h"
#import "Round.h"
#import "AXLAppDelegate.h"

@interface GameViewController ()

@end

@implementation GameViewController {
    AXLAppDelegate *appDel;
    NSString *pTwoScore;
    int numberOfRows;
}
@synthesize playerOneScoreLabel;
@synthesize playerTwoScoreLabel;
@synthesize playerTwoNameLabel;
@synthesize playerOneNameLabel;
@synthesize answerOne, answerTwo, nameOne, nameTwo;
@synthesize fetchedResultsController = __fetchedResultsController;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize myTableView;
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
    [[GCTurnBasedMatchHelper sharedInstance] authenticateLocalUser];
    appDel = (AXLAppDelegate*)[[UIApplication sharedApplication] delegate];
    havestartedgame = NO;
    
    NSLog(@"answerslabel %@", answerOne);
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    playerOneScoreLabel.text = answerOne;
    playerTwoScoreLabel.text = answerTwo;
    //[self insertNewObject];
    
    
}

-(void)viewDidAppear:(BOOL)animated
{
        
    [GCTurnBasedMatchHelper sharedInstance].delegate = self;
    self.statusLabel.text = [NSString stringWithFormat:@"din tur och spelare %d", [[GCTurnBasedMatchHelper sharedInstance] isPlayerOne]];
//self.playBtnOutlet.hidden = YES;
    if(havestartedgame)
    {
        self.playBtnOutlet.hidden = YES;
        self.statusLabel.text = @"den andres tur. väntar...";
        NSLog(@"view did appear should be hidden");
    }
    playerOneNameLabel.text = [GKLocalPlayer localPlayer].alias;
    playerTwoNameLabel.text = appDel.oponentName;
    
}
-(NSManagedObjectContext *)context {
    return [AXLSharedContext getSharedContext];
}
-(void)insertNewObjectWithScore:(NSString*)score
{
    
    // Create a new instance of the entity managed by the fetched results controller.
    Round *event;
    event = [NSEntityDescription insertNewObjectForEntityForName:@"Round" inManagedObjectContext:self.context];
    
    
    event.playerTwoScore = score;
    event.playerTwoDate = [NSDate date];
    event.matchId = [[[GCTurnBasedMatchHelper sharedInstance] currentMatch] matchID];
    //event.category = category;
    
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
-(void)updateCoreDataObject {
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
    else {
        // Get car and assign new selected value.
        int count = [mutableFetchResults count]-1;
        Round *aRound = (Round *)[mutableFetchResults objectAtIndex:count];
        [aRound setPlayerTwoScore:[[NSUserDefaults standardUserDefaults]objectForKey:@"score"]];
        
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
    [self.myTableView reloadData];
}
-(void)userDidAuthenticate{

    [[GCTurnBasedMatchHelper sharedInstance]
     findMatchWithMinPlayers:2 maxPlayers:2 viewController:self];
    
}

#pragma mark - GCTurnBasedMatchHelperDelegate

-(void)enterNewGame:(GKTurnBasedMatch *)match {
    NSLog(@"Entering new game...");
    self.statusLabel.text = @"Player 1's Turn (that's you)";
    if ([[NSUserDefaults standardUserDefaults] integerForKey:match.matchID]) {
        NSLog(@"vi är på runda %d",[[NSUserDefaults standardUserDefaults] integerForKey:match.matchID]);
    }
    else {
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:match.matchID];
    }
   
}

-(void)takeTurn:(GKTurnBasedMatch *)match {
    int count;
    NSString *storySoFar;
    NSLog(@"Taking turn for existing game...");
    self.playBtnOutlet.hidden = NO;
    playBtnShouldBeHidden = NO;
    int playerNum = [match.participants
                     indexOfObject:match.currentParticipant] + 1;
    NSString *statusString = [NSString stringWithFormat:
                              @"Player %d's Turn (that's you)", playerNum];
    self.statusLabel.text = statusString;
    if ([match.matchData bytes]) {
        storySoFar = [NSString stringWithUTF8String:
                                [match.matchData bytes]];
        
        [[NSUserDefaults standardUserDefaults] setObject:storySoFar forKey:@"score"];
        //[self presentGameStatsWithString:storySoFar];
        [self showAlertWithMessage:[NSString stringWithFormat:@"din tur knappen ska synas runda %@", [storySoFar substringFromIndex:3]]];
        
        count = [[NSUserDefaults standardUserDefaults] integerForKey:match.matchID];
        if ([[NSUserDefaults standardUserDefaults] integerForKey:match.matchID])
        {
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:match.matchID];
        }
        [[NSUserDefaults standardUserDefaults] setInteger:[[storySoFar substringFromIndex:3] intValue] forKey:match.matchID];
    }
    
    
    self.statusLabel.text = [NSString stringWithFormat:@"din tur och spelare %d", [[GCTurnBasedMatchHelper sharedInstance] isPlayerOne]];
    
    if ([[GCTurnBasedMatchHelper sharedInstance] isPlayerOne] && match.matchData != nil) {
        
        NSLog(@"uppdatera objekt för spelare ett");
        [self updateCoreDataObject];
    }
    else if (![[GCTurnBasedMatchHelper sharedInstance] isPlayerOne] && match.matchData != nil){
        if ([[NSUserDefaults standardUserDefaults] integerForKey:match.matchID]>numberOfRows || numberOfRows == 0)
        {
            [self insertNewObjectWithScore:[storySoFar substringToIndex:3]];
            NSLog(@"lägg till objekt för spelare två rader %d och ronder %d", numberOfRows,[[NSUserDefaults standardUserDefaults] integerForKey:match.matchID]);
        }
        else {
            NSLog(@"lägg inte till objekt för spelare två rader %d och ronder %d", numberOfRows,[[NSUserDefaults standardUserDefaults] integerForKey:match.matchID]);
        }
    }
}

-(void)layoutMatch:(GKTurnBasedMatch *)match {
    self.playBtnOutlet.hidden = YES;
    self.statusLabel.text = @"inte din tur";
    [self showAlertWithMessage:[NSString stringWithFormat:@"inte din tur knappen ska inte synas och match id %@", match.matchID]];
    
    NSLog(@"layout match");
    
    
    
    NSLog(@"Viewing match where it's not our turn...");
    playBtnShouldBeHidden = YES;
    NSString *statusString;
    
    if (match.status == GKTurnBasedMatchStatusEnded) {
        statusString = @"Match Ended";
    } else {
        int playerNum = [match.participants
                         indexOfObject:match.currentParticipant] + 1;
        statusString = [NSString stringWithFormat:
                        @"Player %d's Turn", playerNum];
    }
    
    
}

-(void)sendNotice:(NSString *)notice forMatch:(GKTurnBasedMatch *)match {
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSManagedObjectContext *)managedObjectContext
{
    return [AXLSharedContext getSharedContext];
}

-(void)showAlertWithMessage:(NSString*)message {
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Alert" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [av show];
}







// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    numberOfRows = [sectionInfo numberOfObjects];
    return [sectionInfo numberOfObjects];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}



- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the managed object for the given index path
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
        
        
        // Save the context.
        NSError *error = nil;
        if (![context save:&error]) {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
        
    }
    
}



- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // The table view should not be re-orderable.
    return NO;
}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - Fetched results controller


- (NSFetchedResultsController *)fetchedResultsController
{
    if (__fetchedResultsController != nil) {
        return __fetchedResultsController;
    }
    
    // Set up the fetched results controller.
    // Create the fetch request for the entity.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Round" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:100];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"playerOneDate" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Master"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
	    /*
	     Replace this implementation with code to handle the error appropriately.
         
	     abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
	     */
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return __fetchedResultsController;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.myTableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.myTableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.myTableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.myTableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.myTableView endUpdates];
    [self.myTableView reloadData];
}

/*
 // Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed.
 
 - (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
 {
 // In the simplest, most efficient, case, reload the table view.
 [self.tableView reloadData];
 }
 */

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    Round *round = [self.fetchedResultsController objectAtIndexPath:indexPath];
    UILabel *label1 = (UILabel *)[cell viewWithTag:1];
    UILabel *label2 = (UILabel *)[cell viewWithTag:2];
    UIImageView *mediaImage = (UIImageView *)[cell viewWithTag:1001];
    label1.text = round.playerOneScore;
    label2.text = round.playerTwoScore;
    
    //mediaImage.image = image;
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    } 
}





- (void)viewDidUnload {
    [self setPlayerOneNameLabel:nil];
    [self setPlayerTwoNameLabel:nil];
    [self setPlayerOneScoreLabel:nil];
    [self setPlayerTwoScoreLabel:nil];
    [self setMyTableView:nil];
    [self setStatusLabel:nil];
    [self setPlayBtnOutlet:nil];
    
    [super viewDidUnload];
}
- (IBAction)menuBtn:(id)sender {
    [self userDidAuthenticate];
    
}
- (IBAction)playbtnaction:(id)sender {
    
    havestartedgame = YES;
}
@end
