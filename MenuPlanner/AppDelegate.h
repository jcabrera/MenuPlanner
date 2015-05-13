//
//  AppDelegate.h
//  MenuPlanner
//
//  Created by Jennifer Cabrera on 1/20/15.
//  Copyright (c) 2015 Jennifer Cabrera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <MagicalRecord/CoreData+MagicalRecord.h>
#import "Plan.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (strong, nonatomic) NSMutableArray *tentativeMealPlan;
@property (strong, nonatomic) NSMutableArray *savedMealPlan;
@property (assign, nonatomic) BOOL tentativePlanExists;
@property (assign, nonatomic) BOOL savedPlanExists;
@property (strong, nonatomic) NSDate *lastPlanDate;
@property (assign, nonatomic) BOOL planIsSavedToCoreData;


@end

