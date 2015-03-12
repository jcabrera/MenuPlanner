//
//  MealListTableViewController.m
//  MenuPlanner
//
//  Created by Jennifer Cabrera on 1/21/15.
//  Copyright (c) 2015 Jennifer Cabrera. All rights reserved.
//

#import "MealListTableViewController.h"
#import "AddMealViewController.h"
#import "AppDelegate.h"
#import "Meal.h"
#import "EditMealViewController.h"
#import "MealTableViewCell.h"


@interface MealListTableViewController ()

@property NSMutableArray *mealItems;

@end

@implementation MealListTableViewController


- (IBAction)unwindToList:(UIStoryboardSegue *)segue {
    if ([segue  isEqual: @"AddMealSaveUnwind"]){
    AddMealViewController *source = [segue sourceViewController];
    self.meal = source.meal;
    if (self.meal != nil) {
        [self.mealItems addObject:self.meal];}
        
     [self fetchAllMeals];
    [self.tableView reloadData];
    }
    
}
 



- (void)viewDidLoad {
    [super viewDidLoad];

       
    }
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self fetchAllMeals];
    
    [self.tableView reloadData];
}

- (void)applicationWillResignActive:(NSNotification *)notification {
        
    }


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fetchAllMeals {
    // 1. Get the sort key
    // NSString *sortKey = [[NSUserDefaults standardUserDefaults] objectForKey:WB_SORT_KEY];
    // 2. Determine if it is ascending
    //BOOL ascending = [sortKey isEqualToString:SORT_KEY_RATING] ? NO : YES;
    // 3. Fetch entities with MagicalRecord
    self.mealItems = [[Meal MR_findAllSortedBy:@"lastDate" ascending:YES] mutableCopy];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return [self.mealItems count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"
                                                            forIndexPath:indexPath];
    [self configureCell:cell atIndex:indexPath];
    return cell;
}

- (void)configureCell:(UITableViewCell*)cell atIndex:(NSIndexPath*)indexPath {
   
    
    // Get current meal
    Meal *currentMeal = [self.mealItems objectAtIndex:indexPath.row];
    cell.textLabel.text = currentMeal.mealName;
    NSString *dateString = [NSDateFormatter localizedStringFromDate:currentMeal.lastDate
                                                          dateStyle:NSDateFormatterShortStyle
                                                          timeStyle:NSDateFormatterNoStyle];
    cell.detailTextLabel.text = dateString;
    // Setup AMRatingControl
    AMRatingControl *ratingControl;
   if (![cell viewWithTag:20]) {
        ratingControl = [[AMRatingControl alloc] initWithLocation:CGPointMake(190, 24)
                                                     andMaxRating:5];
        ratingControl.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        ratingControl.userInteractionEnabled = NO;
       ratingControl.tag = 20;
    [cell addSubview:ratingControl];
   } else {
       ratingControl = (AMRatingControl*)[cell viewWithTag:20];
   }
    // Put meal rating in cell
    ratingControl.rating = [currentMeal.mealRating integerValue];
   


}



/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/






#pragma mark - Navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([ segue.identifier isEqualToString:@"EditMeal"]) {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    UINavigationController *navController = [segue destinationViewController];
    EditMealViewController *editVC = (EditMealViewController *)[navController viewControllers][0];
    Meal *selectedMeal = self.mealItems[indexPath.row];
        editVC.meal = selectedMeal;}
    
    
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    //code to execute when a row is tapped. See "Tutorial: Add Data" for more
   
}

@end
