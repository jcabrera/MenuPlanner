//
//  Meal.h
//  MenuPlanner
//
//  Created by Jennifer Cabrera on 2/11/15.
//  Copyright (c) 2015 Jennifer Cabrera. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <MagicalRecord/CoreData+MagicalRecord.h>
#define MR_SHORTHAND


@interface Meal : NSManagedObject

@property (nonatomic, retain) NSString * mealName;
@property (nonatomic, assign) NSNumber *mealRating;
@property (nonatomic, retain) NSDate * lastDate;

@end
