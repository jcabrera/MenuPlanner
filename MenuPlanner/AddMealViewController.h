//
//  AddMealViewController.h
//  MenuPlanner
//
//  Created by Jennifer Cabrera on 1/20/15.
//  Copyright (c) 2015 Jennifer Cabrera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Meal.h"
#define MR_SHORTHAND
#import <MagicalRecord/CoreData+MagicalRecord.h>
#import <AMRatingControl.h>

@class AMRatingControl;

@interface AddMealViewController : UIViewController

@property Meal *meal;
@property (strong, nonatomic) IBOutlet AMRatingControl *ratingControl;

@end
