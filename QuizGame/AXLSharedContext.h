//
//  AXLSharedContext.h
//  MathGame
//
//  Created by Axel Lundbäck on 2012-01-17.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AXLSharedContext : NSObject

+(void)setSharedContext:(NSManagedObjectContext*)context;
+(NSManagedObjectContext*)getSharedContext;


@end
