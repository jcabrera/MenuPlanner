//
//  SpecificMealViewController.h
//  MenuPlanner
//
//  Created by Jennifer Cabrera on 3/23/15.
//  Copyright (c) 2015 Jennifer Cabrera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Meal.h"

@interface SpecificMealViewController : UIViewController

@property Meal *meal;
@property (assign, nonatomic) NSInteger rowToBeEdited;

@end
