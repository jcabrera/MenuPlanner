//
//  GenerateMealsTableViewController.m
//  MenuPlanner
//
//  Created by Jennifer Cabrera on 3/9/15.
//  Copyright (c) 2015 Jennifer Cabrera. All rights reserved.
//

#import "GenerateMealsTableViewController.h"
#import "Meal.h"
#import "AppDelegate.h"

@interface GenerateMealsTableViewController ()
@property NSMutableArray *mealItems;
@property NSMutableArray *myMeals;
@end

@implementation GenerateMealsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self fetchAllMeals];
    self.myMeals = [[NSMutableArray alloc] init];
    for (int i=0; i < self.numberOfMeals; i++) {
        Meal *currentMeal = self.mealItems[i];
        NSLog(@"Current meal name: %@", currentMeal.mealName);
        self.myMeals[i] = currentMeal.mealName;
        NSLog(@"My Meals: %@", self.myMeals[i]);
        
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.numberOfMeals;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MealCell" forIndexPath:indexPath];
    
    cell.textLabel.text = self.myMeals[indexPath.row];
    NSLog(@"Table cell: %@", self.myMeals[indexPath.row]);
    
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
