//
//  AddMealViewController.m
//  MenuPlanner
//
//  Created by Jennifer Cabrera on 1/20/15.
//  Copyright (c) 2015 Jennifer Cabrera. All rights reserved.
//

#import "AddMealViewController.h"

@interface AddMealViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;

@end

@implementation AddMealViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if (sender != self.saveButton) return;
    if (self.textField.text.length > 0) {
        self.mealItem = [[MealItem alloc] init];
        self.mealItem.mealName = self.textField.text;
    }
}


@end
