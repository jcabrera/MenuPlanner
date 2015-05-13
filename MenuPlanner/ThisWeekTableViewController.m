//
//  ThisWeekTableViewController.m
//  MenuPlanner
//
//  Created by Jennifer Cabrera on 3/18/15.
//  Copyright (c) 2015 Jennifer Cabrera. All rights reserved.
//

#import "ThisWeekTableViewController.h"
#import "Meal.h"
#import "AppDelegate.h"
#import "Plan.h"

@interface ThisWeekTableViewController ()
@property NSMutableArray *mealItems;
@property NSMutableArray *myMeals;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (assign) BOOL planIsSaved;
@property NSArray *thisWeek;
@property Plan *currentSavedPlan;

@end

@implementation ThisWeekTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    AppDelegate *appDelegate = [[UIApplication  sharedApplication] delegate];
    NSLog(@"ThisWeek viewWillAppear. savedPlanExists = %d, PlanIsSavedToCoreData = %d", appDelegate.savedPlanExists, appDelegate.planIsSavedToCoreData);
    
    self.myMeals = [[NSMutableArray alloc] init];
    self.thisWeek = [Plan MR_findAll];
    
    if ([self.thisWeek count] > 0) {
        Plan *thisWeekPlan = self.thisWeek[0];
        NSLog(@"thisWeekPlan from ThisWeekTableViewController: %@", thisWeekPlan);
        
        self.myMeals[0] = thisWeekPlan.day0;
        self.myMeals[1] = thisWeekPlan.day1;
        self.myMeals[2] = thisWeekPlan.day2;
        self.myMeals[3] = thisWeekPlan.day3;
        self.myMeals[4] = thisWeekPlan.day4;
        self.myMeals[5] = thisWeekPlan.day5;
        self.myMeals[6] = thisWeekPlan.day6;
        
    }
    else {
        self.thisWeek = appDelegate.savedMealPlan;
        if ([self.thisWeek count] == 0) {
             self.myMeals = [@[@"",@"",@"",@"",@"",@"",@""] mutableCopy];
        }
    }

    [self.tableView reloadData];
    UINavigationController *navCon  = (UINavigationController*) [self.navigationController.viewControllers objectAtIndex:0];
    //NSDate *nextMonday = [self getNextMonday];
    //NSLog(@"This week: nextMonday before adjustment: %@", nextMonday);
    //if (appDelegate.lastPlanDate > nextMonday) {
        //nextMonday = [appDelegate.lastPlanDate dateByAddingTimeInterval:60*60*24*7];
    //}
    //NSLog(@"This Week: LastPlanDate = %@, next Monday = %@", appDelegate.lastPlanDate, nextMonday);
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateStyle = NSDateFormatterShortStyle;
    NSString *navTitle = [NSString stringWithFormat:@"Week of %@", [dateFormatter stringFromDate:appDelegate.lastPlanDate]];
    navCon.navigationItem.title = navTitle;
    

    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 7;
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MealCell" forIndexPath:indexPath];
    if ([self.myMeals[indexPath.section] isEqualToString:@"Tap to add a meal"]){
        cell.textLabel.text = @"";
    } else {
    cell.textLabel.text = self.myMeals[indexPath.section];
    }
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

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end


