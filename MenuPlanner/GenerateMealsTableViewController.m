//
//  GenerateMealsTableViewController.m
//  MenuPlanner
//
//  Created by Jennifer Cabrera on 3/9/15.
//  Copyright (c) 2015 Jennifer Cabrera. All rights reserved.
//

#import "GenerateMealsTableViewController.h"
#import "Meal.h"
#import "Plan.h"
#import "AppDelegate.h"
#import "SpecificMealViewController.h"
#import "ThisWeekTableViewController.h"

@interface GenerateMealsTableViewController ()
@property (strong, nonatomic) NSMutableArray *mealItems;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editButton;
@property (strong, nonatomic) NSMutableArray *myMeals;
@property NSArray *thisWeek;
@property BOOL okGoAhead;

@end

@implementation GenerateMealsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"GenerateMeals viewDidLoad");
    

    
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}






- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    AppDelegate *appDelegate = [[UIApplication  sharedApplication] delegate];
    NSLog(@"GenerateMeals viewWillAppear");
    if (appDelegate.tentativePlanExists == NO) {
        [self fetchAllMeals];
        NSLog(@"Getting a new set of meals");
        self.myMeals = [[NSMutableArray alloc] init];
        if (self.numberOfMeals > [self.mealItems count]) {self.numberOfMeals = [self.mealItems count];}
        for (int i=0; i < self.numberOfMeals; i++) {
            Meal *currentMeal = self.mealItems[i];
            self.myMeals[i] = currentMeal.mealName;
            }
        appDelegate.tentativeMealPlan = self.myMeals;
        for (long i=self.numberOfMeals; i < 7; i++) {
            [appDelegate.tentativeMealPlan addObject:@"Tap to add a meal"];
            }
        appDelegate.tentativePlanExists = YES;
        
        }
    else {
        [self fetchTentativeMealPlan];
        NSLog(@"Getting meals from tentativeMealPlan");
        
    }

    
    [self.tableView reloadData];
    
}

- (void)fetchAllMeals {
    // 1. Get the sort key
    // NSString *sortKey = [[NSUserDefaults standardUserDefaults] objectForKey:WB_SORT_KEY];
    // 2. Determine if it is ascending
    //BOOL ascending = [sortKey isEqualToString:SORT_KEY_RATING] ? NO : YES;
    // 3. Fetch entities with MagicalRecord
    self.mealItems = [[Meal MR_findAllSortedBy:@"lastDate" ascending:YES] mutableCopy];
}

- (void)fetchTentativeMealPlan {
     AppDelegate *appDelegate = [[UIApplication  sharedApplication] delegate];
    self.myMeals = [appDelegate.tentativeMealPlan mutableCopy];
    self.numberOfMeals = 7;
}

- (IBAction)saveWeeklyPlan:(id)sender {
    
    AppDelegate *appDelegate =[[UIApplication  sharedApplication] delegate];
    NSLog(@"saveWeeklyPlan in Generate Meals - tentativePlanExists = %d, savedPlanExists = %d", appDelegate.tentativePlanExists, appDelegate.savedPlanExists);
   
    if (appDelegate.savedPlanExists) {
        self.okGoAhead = NO;
        UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"You already have a meal plan for this week. Do you want to make a plan for the next week?" message:@"This will replace the current meal plan, but you'll still be able to see the meal dates on the Meal List tab." preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action){ self.okGoAhead = YES;}];
        [controller addAction:yesAction];
        UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:nil];
        [controller addAction:noAction];
        UIPopoverPresentationController *ppc = controller.popoverPresentationController;
        if (ppc != nil) {
            ppc.sourceView = sender;
            ppc.sourceRect = ((UIView *)sender).bounds;
        }
        [self presentViewController:controller animated:YES completion:nil];
    }
    else self.okGoAhead = YES;
    if ((appDelegate.planIsSavedToCoreData)  && (self.okGoAhead = YES)) {
        NSLog(@"Saved plan exists in core data");
        self.thisWeek = [Plan MR_findAll];
        Plan *thisWeekPlan = self.thisWeek[0];
        thisWeekPlan.day0 = appDelegate.tentativeMealPlan[0];
        thisWeekPlan.day1 = appDelegate.tentativeMealPlan[1];
        thisWeekPlan.day2 = appDelegate.tentativeMealPlan[2];
        thisWeekPlan.day3 = appDelegate.tentativeMealPlan[3];
        thisWeekPlan.day4 = appDelegate.tentativeMealPlan[4];
        thisWeekPlan.day5 = appDelegate.tentativeMealPlan[5];
        thisWeekPlan.day6 = appDelegate.tentativeMealPlan[6];
        appDelegate.savedMealPlan[0] = appDelegate.tentativeMealPlan[0];
        appDelegate.savedMealPlan[1] = appDelegate.tentativeMealPlan[1];
        appDelegate.savedMealPlan[2] = appDelegate.tentativeMealPlan[2];
        appDelegate.savedMealPlan[3] = appDelegate.tentativeMealPlan[3];
        appDelegate.savedMealPlan[4] = appDelegate.tentativeMealPlan[4];
        appDelegate.savedMealPlan[5] = appDelegate.tentativeMealPlan[5];
        appDelegate.savedMealPlan[6] = appDelegate.tentativeMealPlan[6];
        [self savePlan];
        NSLog(@"tentativeMealPlan written to thisWeekPlan and savedMealPlan");
        NSDate *nextMonday = [self getNextMonday];
        AppDelegate *appDelegate = [[UIApplication  sharedApplication] delegate];
        NSCalendar *cal = [NSCalendar currentCalendar];
        NSDateComponents *comps = [cal components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)
                                         fromDate:nextMonday];
       nextMonday = [cal dateFromComponents:comps];
        if (appDelegate.lastPlanDate >= nextMonday) {
            nextMonday = [appDelegate.lastPlanDate dateByAddingTimeInterval:60*60*24*7];
        }
        NSLog(@"GenerateMeals: LastPlanDate = %@, next Monday = %@", appDelegate.lastPlanDate, nextMonday);
        appDelegate.lastPlanDate = nextMonday;
        [self updateMealDates];
        self.tabBarController.selectedIndex = 2;
    }
    else if (appDelegate.planIsSavedToCoreData == NO){
        NSLog(@"Saved plan doesn't exist");
        Plan *thisWeekPlan = [Plan MR_createEntity];
        NSLog(@"Tentative meal plan: %@", appDelegate.tentativeMealPlan);
        thisWeekPlan.day0 = appDelegate.tentativeMealPlan[0];
        thisWeekPlan.day1 = appDelegate.tentativeMealPlan[1];
        thisWeekPlan.day2 = appDelegate.tentativeMealPlan[2];
        thisWeekPlan.day3 = appDelegate.tentativeMealPlan[3];
        thisWeekPlan.day4 = appDelegate.tentativeMealPlan[4];
        thisWeekPlan.day5 = appDelegate.tentativeMealPlan[5];
        thisWeekPlan.day6 = appDelegate.tentativeMealPlan[6];
        appDelegate.savedMealPlan = appDelegate.tentativeMealPlan;
        NSLog(@"Generate Meals - saved plan doesn't exist - savedMealPlan: %@", appDelegate.savedMealPlan);
        [self savePlan];
        appDelegate.savedPlanExists = YES;
         NSDate *nextMonday = [self getNextMonday];
        AppDelegate *appDelegate = [[UIApplication  sharedApplication] delegate];
        NSCalendar *cal = [NSCalendar currentCalendar];
        NSDateComponents *comps = [cal components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)
                                         fromDate:nextMonday];
        nextMonday = [cal dateFromComponents:comps];
        if (appDelegate.lastPlanDate >= nextMonday) {
            nextMonday = [appDelegate.lastPlanDate dateByAddingTimeInterval:60*60*24*7];
        }
        NSLog(@"GenerateMeals: LastPlanDate = %@, next Monday = %@", appDelegate.lastPlanDate, nextMonday);
        appDelegate.lastPlanDate = nextMonday;
        [self updateMealDates];
        self.tabBarController.selectedIndex = 2;
    }
   
}

- (void)updateMealDates {
    AppDelegate *appDelegate = [[UIApplication  sharedApplication] delegate];
    for (int i = 0; i < [appDelegate.savedMealPlan count]; i++) {
        NSString *desiredMealName  = appDelegate.savedMealPlan[i];
        NSString *desiredAttribute = @"mealName";
        NSPredicate *predicate   = [NSPredicate predicateWithFormat:@"%K like %@",
                                    desiredAttribute, desiredMealName];
        NSArray *desiredMeal = [Meal MR_findAllWithPredicate:predicate];
        if (!([appDelegate.savedMealPlan[i] isEqualToString:@"Tap to add a meal"])) {
            Meal *mealToBeUpdated = desiredMeal[0];
        NSTimeInterval dateOffset = i * 86400.0;
        mealToBeUpdated.lastDate = [NSDate dateWithTimeInterval:dateOffset sinceDate:appDelegate.lastPlanDate];
            [self saveContext];}
        
        
    }
}

- (void)savePlan {
    AppDelegate *appDelegate = [[UIApplication  sharedApplication] delegate];
    appDelegate.planIsSavedToCoreData = NO;
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
        if (success) {
            NSLog(@"You successfully saved your plan in GenerateMeals");
            appDelegate.planIsSavedToCoreData = YES;
        } else if (error) {
            NSLog(@"Error saving context: %@", error.description);
        }
    }];
    
}




- (void)saveContext {
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
        if (success) {
            NSLog(@"You successfully saved your context in GenerateMeals");
        } else if (error) {
            NSLog(@"Error saving context: %@", error.description);
        }
    }];
   NSUInteger count = [[[NSManagedObjectContext MR_defaultContext] registeredObjects] count];
    NSLog (@"Managed objects count: %lu", (unsigned long)count);
    
}



- (NSDate *)getNextMonday {
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSWeekCalendarUnit | NSWeekdayCalendarUnit fromDate:now];
    
    NSUInteger weekdayToday = [components weekday];
    NSInteger daysToMonday = (9 - weekdayToday) % 7;
    
    NSDate *nextMonday = [now dateByAddingTimeInterval:60*60*24*daysToMonday];
    
    return nextMonday;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 8;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section < 7)
    {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MealCell" forIndexPath:indexPath];
    if (indexPath.section < self.numberOfMeals) {
        cell.textLabel.text = self.myMeals[indexPath.section];
    }
    else {
        cell.textLabel.text = @"Tap to add a meal";
        }
        return cell;
        
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ButtonCell" forIndexPath:indexPath];
        return cell;
    }
    
   
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
            return @"Monday";
            break;
        case 1:
            return @"Tuesday";
            break;
        case 2:
            return @"Wednesday";
            break;
        case 3:
            return @"Thursday";
            break;
        case 4:
            return @"Friday";
            break;
        case 5:
            return @"Saturday";
            break;
        case 6:
            return @"Sunday";
            break;
        default:
            return @"";
            break;
    }
}



- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    if (indexPath.section < 7) {
        return YES;}
    else {return NO;}
}



- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}


- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    if (indexPath.section < 7) {
        return YES;}
    else {return NO;}
}




- (IBAction)unwindToMealPlan:(UIStoryboardSegue *)segue {
    self.numberOfMeals++;
    self.myMeals = [[NSMutableArray alloc] init];
    AppDelegate *appDelegate = [[UIApplication  sharedApplication] delegate];
    self.myMeals = [appDelegate.tentativeMealPlan mutableCopy];
    [self.tableView reloadData];
}


#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"ChangeMeal"]){
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    self.rowToBeEdited = indexPath.section;
    UINavigationController *navController = [segue destinationViewController];
    SpecificMealViewController *editVC = (SpecificMealViewController *)[navController viewControllers][0];
        editVC.rowToBeEdited = self.rowToBeEdited;}
    if([[segue identifier] isEqualToString:@"ShowSavedPlan"]){
        [self.tabBarController setSelectedIndex:2];
    }
    
}


@end
