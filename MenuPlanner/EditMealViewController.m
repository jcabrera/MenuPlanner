//
//  EditMealViewController.m
//  MenuPlanner
//
//  Created by Jennifer Cabrera on 2/24/15.
//  Copyright (c) 2015 Jennifer Cabrera. All rights reserved.
//

#import "EditMealViewController.h"

@interface EditMealViewController ()
@property (weak, nonatomic) IBOutlet UITextField *mealNameTextField;
@property (weak, nonatomic) IBOutlet UIDatePicker *mealDatePicker;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;

@end

@implementation EditMealViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mealNameTextField.text = self.meal.mealName;
    if (self.meal.lastDate) {
        self.mealDatePicker.date = self.meal.lastDate;}
    //CGPoint ratingLocation = {self.mealDatePicker.frame.origin.x, self.mealDatePicker.frame.origin.y + 280};
    //AMRatingControl *ratingControl = [[AMRatingControl alloc] initWithLocation:(CGPoint)ratingLocation
    //                                                              andMaxRating:5];
   
    if (self.meal.mealRating) {
        self.ratingControl.rating = (NSUInteger)self.meal.mealRating;}
    //ratingControl.starSpacing = 5;
    //[ratingControl addTarget:self
      //                     action:@selector(updateRating)
        //         forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:self.ratingControl];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.mealNameTextField resignFirstResponder];
    // Save context as view disappears
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ([textField.text length] > 0) {
        self.meal.mealName = textField.text;
        
    }
    [textField resignFirstResponder];
}




- (IBAction)saveEditedMeal:(id)sender {
    self.meal.mealName = self.mealNameTextField.text;
    self.meal.lastDate = self.mealDatePicker.date;
    [self saveContext];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)saveContext {
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
        if (success) {
            NSLog(@"You successfully saved your context.");
        } else if (error) {
            NSLog(@"Error saving context: %@", error.description);
        }
    }];
    
}

- (AMRatingControl*)ratingControl {
    if (!_ratingControl) {
        CGPoint ratingLocation = {self.mealDatePicker.frame.origin.x, self.mealDatePicker.frame.origin.y + 280};
        _ratingControl = [[AMRatingControl alloc] initWithLocation:ratingLocation
                                                      andMaxRating:5];
        _ratingControl.starSpacing = 5;
        [_ratingControl addTarget:self
                           action:@selector(updateRating)
                 forControlEvents:UIControlEventEditingChanged];
    }
    return _ratingControl;
}

- (void)updateRating {
    self.meal.mealRating = @(self.ratingControl.rating);
    NSLog(@"updateRating called. mealRating = %@", self.meal.mealRating);
}

#pragma mark - Navigation

 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 if (sender != self.saveButton) {
 return;}
 else {
     NSLog(@"prepareForSegue in Edit Meal");
 self.meal.mealName = self.mealNameTextField.text;
 self.meal.lastDate = self.mealDatePicker.date;
     self.meal.mealRating = @(self.ratingControl.rating);
 }
 }

@end
