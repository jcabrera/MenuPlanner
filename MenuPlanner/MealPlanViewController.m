//
//  MealPlanViewController.m
//  MenuPlanner
//
//  Created by Jennifer Cabrera on 3/9/15.
//  Copyright (c) 2015 Jennifer Cabrera. All rights reserved.
//

#import "MealPlanViewController.h"
#import "Meal.h"
#import "GenerateMealsTableViewController.h"

@interface MealPlanViewController ()
@property (weak, nonatomic) IBOutlet UIPickerView *numberOfMeals;
@property (weak, nonatomic) IBOutlet UIButton *mealButton;
@property (assign, nonatomic) long howManyMeals;
@end

@implementation MealPlanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.

        GenerateMealsTableViewController *editVC = (GenerateMealsTableViewController *)[segue destinationViewController];
        editVC.numberOfMeals = self.howManyMeals;
    //self.planExists = [PlanExists MR_createEntity];
    //self.meal.mealName = self.textField.text;
    //self.meal.lastDate = self.lastEaten.date;
    //self.meal.mealRating = @(self.ratingControl.rating);
    //[self saveContext];
    //self.planExists = TRUE;
     //self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"New plan" style:UIBarButtonItemStylePlain target:nil action:nil];
}

- (void)performSegueWithIdentifier:(UIStoryboardSegue *)segue sender:(id)sender {

}


#pragma mark -
#pragma mark Picker Data Source Methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return kMaxNumberOfMeals;
}

#pragma mark Picker Delegate Methods

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [NSString stringWithFormat:@"%ld", (row+1)];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.howManyMeals = row + 1;
     NSLog(@"Number of meals: %ld", self.howManyMeals);
    
}

@end
