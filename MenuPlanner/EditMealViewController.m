//
//  EditMealViewController.m
//  MenuPlanner
//
//  Created by Jennifer Cabrera on 2/24/15.
//  Copyright (c) 2015 Jennifer Cabrera. All rights reserved.
//

#import "EditMealViewController.h"

@interface EditMealViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *mealNameTextField;
@property (weak, nonatomic) IBOutlet UIDatePicker *mealDatePicker;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property (strong, nonatomic) IBOutlet AMRatingControl *ratingControl;

@end

@implementation EditMealViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[self mealNameTextField] setDelegate:self];
    self.mealNameTextField.text = self.meal.mealName;
    if (self.meal.lastDate) {
        self.mealDatePicker.date = self.meal.lastDate;}
    CGPoint ratingLocation = {self.mealDatePicker.frame.origin.x, self.mealDatePicker.frame.origin.y + 280};
    if (!self.ratingControl) {
        self.ratingControl = [[AMRatingControl alloc] initWithLocation:(CGPoint)ratingLocation
                                                                                andMaxRating:5];
    }
    if ([self.meal.mealRating integerValue] <= 5) {
        self.ratingControl.rating = [self.meal.mealRating integerValue];}
    else {self.ratingControl.rating = 0;}
    //ratingControl.starSpacing = 5;
    [self.ratingControl addTarget:self
                           action:@selector(updateRating)
                 forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:self.ratingControl];
    [self.mealDatePicker addTarget:self action:@selector(pickerChanged:)               forControlEvents:UIControlEventValueChanged];
    
}

- (void)pickerChanged:(id)sender
{
    
    [self.mealNameTextField resignFirstResponder];
}
 

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.mealNameTextField resignFirstResponder];
    //[self saveContext];
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
    [self.view endEditing:YES];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    if(![touch.view isMemberOfClass:[UITextField class]]) {
        [touch.view endEditing:YES];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    if (theTextField == self.mealNameTextField) {
        [theTextField resignFirstResponder];
    }
    return YES;
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



- (void)updateRating {
    self.meal.mealRating = @(self.ratingControl.rating);
    NSLog(@"updateRating called. mealRating = %@", self.meal.mealRating);
}


#pragma mark - Navigation

 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     if (sender != self.saveButton) return; else
     {
     self.meal.mealName = self.mealNameTextField.text;
     self.meal.lastDate = self.mealDatePicker.date;
     self.meal.mealRating = @(self.ratingControl.rating);
         [self saveContext];}
     

 }


@end
