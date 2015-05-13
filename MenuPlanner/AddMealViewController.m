//
//  AddMealViewController.m
//  MenuPlanner
//
//  Created by Jennifer Cabrera on 1/20/15.
//  Copyright (c) 2015 Jennifer Cabrera. All rights reserved.
//

#import "AddMealViewController.h"

@interface AddMealViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (weak, nonatomic) IBOutlet UIDatePicker *lastEaten;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;


@end

@implementation AddMealViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[self textField] setDelegate:self];
    CGPoint ratingLocation = {self.ratingLabel.frame.origin.x +self.ratingLabel.frame.size.width+10, self.ratingLabel.frame.origin.y + 52};
    self.ratingControl = [[AMRatingControl alloc] initWithLocation:(CGPoint)ratingLocation
                                                      andMaxRating:5];
    
    self.ratingControl.starSpacing = 5;
    [self.ratingControl addTarget:self
                           action:@selector(updateRating)
                 forControlEvents:UIControlEventEditingChanged];
      [self.view addSubview:self.ratingControl];
    [self.lastEaten addTarget:self action:@selector(pickerChanged:)               forControlEvents:UIControlEventValueChanged];

   
}

- (void)pickerChanged:(id)sender
{
    
    [self.textField resignFirstResponder];
}



- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.textField resignFirstResponder];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ([textField.text length] > 0) {
        self.title = textField.text;
        self.meal.mealName = textField.text;
    }
    [self.textField resignFirstResponder];
    [self.view endEditing:YES];
  
}



/*

- (void)cancelAdd {
    [self.meal MR_deleteEntity];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addNewMeal {
    [self.navigationController popViewControllerAnimated:YES];
}
*/

// Updates rating
- (void)updateRating {
    self.meal.mealRating = @(self.ratingControl.rating);
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if (sender != self.saveButton) {
        return;}
    if (self.textField.text.length > 0) {
        self.meal = [Meal MR_createEntity];
        self.meal.mealName = self.textField.text;
        self.meal.lastDate = self.lastEaten.date;
        self.meal.mealRating = @(self.ratingControl.rating);
        [self saveContext];
       
    }
}


@end
