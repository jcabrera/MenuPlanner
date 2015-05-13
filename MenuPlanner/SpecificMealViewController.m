//
//  SpecificMealViewController.m
//  MenuPlanner
//
//  Created by Jennifer Cabrera on 3/23/15.
//  Copyright (c) 2015 Jennifer Cabrera. All rights reserved.
//

#import "SpecificMealViewController.h"
#import "AppDelegate.h"

@interface SpecificMealViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (strong, nonatomic) NSArray *mealItemsTemp;
@property (strong, nonatomic) NSMutableArray *mealItems;
@property (strong, nonatomic) NSString *specificMeal;
@property (strong, nonatomic) NSString *mealForRow;


@end

@implementation SpecificMealViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"Row to be edited: %ld", (long)self.rowToBeEdited);
    [self.textField setHidden:YES];
    [self fetchAllMeals];
    NSString *newMeal = @"New meal (add below)";
    self.mealItems = [self.mealItemsTemp mutableCopy];
    [self.mealItems addObject:newMeal];
     
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillDisappear:(BOOL)animated {
    NSLog(@"Specific Meal viewWillDisappear called");
    [super viewWillDisappear:animated];
    [self.textField resignFirstResponder];
    
}

- (void)fetchAllMeals {
    // 1. Get the sort key
    // NSString *sortKey = [[NSUserDefaults standardUserDefaults] objectForKey:WB_SORT_KEY];
    // 2. Determine if it is ascending
    //BOOL ascending = [sortKey isEqualToString:SORT_KEY_RATING] ? NO : YES;
    // 3. Fetch entities with MagicalRecord
    NSArray *mealItemsUnsorted = [Meal MR_findAllSortedBy:@"mealName" ascending:YES];
    NSMutableArray *mealItemNames = [[NSMutableArray alloc] init];
    for (int i=0; i < [mealItemsUnsorted count]; i++) {
        Meal *currentMeal = mealItemsUnsorted[i];
        mealItemNames[i] = currentMeal.mealName;
    }
    self.mealItemsTemp = [mealItemNames sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
  
}



#pragma mark -
#pragma mark Picker Data Source Methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
        return [self.mealItems count];
    
}

#pragma mark Picker Delegate Methods

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    self.mealForRow = self.mealItems[row];
        return self.mealForRow;
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
        self.mealForRow = self.mealItems[row];
        self.specificMeal = self.mealForRow;
    if ([self.specificMeal isEqualToString: @"New meal (add below)"]) {
        [self.textField setHidden:NO];}
            
        else {
            [self.textField setHidden:YES];
        
    }
   
    
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if (([self.specificMeal isEqualToString: @"New meal (add below)"]) && (self.textField.text.length == 0)) {
        UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"Enter your meal in the text box before saving" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil]; [controller addAction:okAction];
        UIPopoverPresentationController *ppc = controller.popoverPresentationController;
        if (ppc != nil) {
            ppc.sourceView = sender;
            ppc.sourceRect = ((UIView *)sender).bounds;
        }
        [self presentViewController:controller animated:YES completion:nil];
        return NO;}
    else {return YES;}
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if (sender != self.saveButton) {
        return;}
  
    
    if (([self.specificMeal isEqualToString: @"New meal (add below)"]) && (self.textField.text.length > 0)) {
        self.meal = [Meal MR_createEntity];
        self.meal.mealName = self.textField.text;
        NSDate *now = [NSDate date];
        // Set new meal's date to today to put it near the end of the list
        self.meal.lastDate = now;
        [self saveContext];
        AppDelegate *appDelegate        =   [[UIApplication  sharedApplication] delegate];
        [appDelegate.tentativeMealPlan replaceObjectAtIndex:self.rowToBeEdited withObject:self.meal.mealName];
        NSLog(@" SpecificMeal PrepareForSegue completed");
    }
    else {
        AppDelegate *appDelegate        =   [[UIApplication  sharedApplication] delegate];
        [appDelegate.tentativeMealPlan replaceObjectAtIndex:self.rowToBeEdited withObject:self.mealForRow];
              
    }
   
}


- (void)saveContext {
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
        if (success) {
            NSLog(@"You successfully saved your context in SpecificMeal.");
        } else if (error) {
            NSLog(@"Error saving context: %@", error.description);
        }
    }];
    
}


/*
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:
(UIView *)view {
    UILabel* tView = (UILabel*)view;
    
    if (pickerView == self.soldToPicker) {
        
        if (!tView){
            tView = [[UILabel alloc] init];
            tView.adjustsFontSizeToFitWidth = YES;
            
            
            tView.text = [self.customerNames objectAtIndex:row];
        }
    }
    else {
        
        if (!tView){
            tView = [[UILabel alloc] init];
            tView.adjustsFontSizeToFitWidth = NO;
            tView.text = [self.productNames objectAtIndex:row];
        }
    }
    return tView;
}
 */



@end
