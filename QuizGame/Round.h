//
//  Round.h
//  The Quizzle
//
//  Created by Axel Lundbäck on 2012-12-17.
//  Copyright (c) 2012 Axel Lundbäck. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Round : NSManagedObject

@property (nonatomic, retain) NSDate * playerOneDate;
@property (nonatomic, retain) NSString * playerOneScore;
@property (nonatomic, retain) NSDate * playerTwoDate;
@property (nonatomic, retain) NSString * playerTwoScore;
@property (nonatomic, retain) NSString * matchId;
@property (nonatomic, retain) NSString * category;
@property (nonatomic, retain) NSNumber * roundCount;

@end
