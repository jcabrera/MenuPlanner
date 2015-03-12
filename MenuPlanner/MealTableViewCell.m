//
//  MealTableViewCell.m
//  MenuPlanner
//
//  Created by Jennifer Cabrera on 3/6/15.
//  Copyright (c) 2015 Jennifer Cabrera. All rights reserved.
//

#import "MealTableViewCell.h"

@interface MealTableViewCell ()

@property (nonatomic, weak) IBOutlet UILabel* detailLabel;
@property (nonatomic, weak) IBOutlet UILabel* titleLabel;

@end
@implementation MealTableViewCell


- (UILabel*)detailTextLabel
{
    return self.detailLabel;
}


- (UILabel*)textLabel
{
    return self.titleLabel;
}
@end

