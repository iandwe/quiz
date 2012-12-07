//
//  Round.h
//  The Quizzle
//
//  Created by Axel Lundbäck on 2012-11-29.
//  Copyright (c) 2012 Axel Lundbäck. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Round : NSManagedObject

@property (nonatomic, retain) NSString * playerOneScore;
@property (nonatomic, retain) NSString * playerTwoScore;
@property (nonatomic, retain) NSDate * playerOneDate;
@property (nonatomic, retain) NSDate * playerTwoDate;

@end
