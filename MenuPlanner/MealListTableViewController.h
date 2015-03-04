//
//  MealListTableViewController.h
//  MenuPlanner
//
//  Created by Jennifer Cabrera on 1/21/15.
//  Copyright (c) 2015 Jennifer Cabrera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MagicalRecord/CoreData+MagicalRecord.h>
#import <AMRatingControl.h>
@class Meal;


@interface MealListTableViewController : UITableViewController

@property (nonatomic, strong) Meal *meal;
- (IBAction)unwindToList:(UIStoryboardSegue *)segue;

@end
