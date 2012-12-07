//
//  AXLSharedContext.m
//  MathGame
//
//  Created by Axel Lundbäck on 2012-01-17.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AXLSharedContext.h"

static NSManagedObjectContext *sharedContext = nil;

@implementation AXLSharedContext

+(NSManagedObjectContext *)getSharedContext {
    return sharedContext;
}

+(void)setSharedContext:(NSManagedObjectContext *)context {
    sharedContext = context;
}

@end