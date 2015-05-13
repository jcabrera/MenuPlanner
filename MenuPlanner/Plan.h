//
//  Plan.h
//  MenuPlanner
//
//  Created by Jennifer Cabrera on 4/3/15.
//  Copyright (c) 2015 Jennifer Cabrera. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <Foundation/Foundation.h>
#import <MagicalRecord/CoreData+MagicalRecord.h>
#define MR_SHORTHAND

@interface Plan : NSManagedObject

@property (nonatomic, retain) NSString * day0;
@property (nonatomic, retain) NSString * day1;
@property (nonatomic, retain) NSString * day2;
@property (nonatomic, retain) NSString * day3;
@property (nonatomic, retain) NSString * day4;
@property (nonatomic, retain) NSString * day5;
@property (nonatomic, retain) NSString * day6;

@end



