//
//  StartUpController.h
//  quiz
//
//  Created by Axel Lundbäck on 2012-11-27.
//  Copyright (c) 2012 Axel Lundbäck. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCTurnBasedMatchHelper.h"

@interface StartUpController : UIViewController<GCTurnBasedMatchHelperDelegate>

@property (weak, nonatomic) IBOutlet UIButton *startgameBtn;
- (IBAction)startQuizPressed:(id)sender;
- (IBAction)signInWithGameCenterPressed:(id)sender;
@end
