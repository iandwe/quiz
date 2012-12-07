//
//  AXLAppDelegate.h
//  QuizGame
//
//  Created by Axel Lundbäck on 2012-11-26.
//  Copyright (c) 2012 Axel Lundbäck. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>
#import <CoreData/CoreData.h>
#import "AXLSharedContext.h"


@interface AXLAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) NSString *oponentName;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@end
