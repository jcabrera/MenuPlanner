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


@interface MealListTableViewController ()

@property NSMutableArray *mealItems;

@end

@implementation MealListTableViewController

- (IBAction)unwindToList:(UIStoryboardSegue *)segue {
    AddMealViewController *source = [segue sourceViewController];
    self.meal = source.meal;
    if (self.meal != nil) {
        [self.mealItems addObject:self.meal];
        [self.tableView reloadData];
    }
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    
        
        UIApplication *app = [UIApplication sharedApplication];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationWillResignActive:)
                                                     name:UIApplicationWillResignActiveNotification
                                                   object:app];
       
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
    
    
    /*
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSError *error;
    for (int i = 0; i < [self.mealItems count]; i++) {
        Meal *meal = self.mealItems[i];
        NSString *mealName = meal.mealName;
        NSLog(@"resigning: %@", mealName);
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:kMealEntityName];
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"(%K = %s)", kMealNameKey, mealName];
        [request setPredicate:pred];
        NSArray *objects = [context executeFetchRequest:request error:&error];
        if (objects == nil) {
            NSLog(@"There was an error!");
            // Do whatever error handling is appropriate
        }
            NSManagedObject *theMeal = nil;
            if ([objects count] > 0) {
                theMeal = [objects objectAtIndex:0];
            }
                else {
                    theMeal = [NSEntityDescription insertNewObjectForEntityForName:kMealEntityName inManagedObjectContext:context];
                }
            [theMeal setValue:[NSString stringWithString:mealName] forKey:kMealNameKey];
           
        }
     */
    
        
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ListPrototypeCell" forIndexPath:indexPath];
    
    Meal *meal = [self.mealItems objectAtIndex:indexPath.row];
    cell.textLabel.text = meal.mealName;
    NSString *dateString = [NSDateFormatter localizedStringFromDate:meal.lastDate
                                                          dateStyle:NSDateFormatterShortStyle
                                                          timeStyle:NSDateFormatterNoStyle];
    cell.detailTextLabel.text = dateString;
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

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

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([ segue.identifier isEqualToString:@"EditMeal"]) {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    EditMealViewController *editVC = (EditMealViewController *)[segue destinationViewController];
    Meal *selectedMeal = self.mealItems[indexPath.row];
        editVC.meal = selectedMeal;}
    
    
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    //code to execute when a row is tapped. See "Tutorial: Add Data" for more
   
}

@end
