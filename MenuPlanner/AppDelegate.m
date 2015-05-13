//
//  AppDelegate.m
//  MenuPlanner
//
//  Created by Jennifer Cabrera on 1/20/15.
//  Copyright (c) 2015 Jennifer Cabrera. All rights reserved.
//

#import "AppDelegate.h"
#import "Meal.h"

@interface AppDelegate ()



@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [MagicalRecord setupCoreDataStackWithStoreNamed:@"MealModel"];
    // Setup App with prefilled meals.
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"MP_HasPrefilledMeals"]) {
       
        Meal *burger = [Meal MR_createEntity];
        burger.mealName  = @"Burgers";
        NSDateComponents *comps = [[NSDateComponents alloc] init];
        [comps setDay:9];
        [comps setMonth:3];
        [comps setYear:2015];
        burger.lastDate = [[NSCalendar currentCalendar] dateFromComponents:comps];
        Meal *pulledPork = [Meal MR_createEntity];
        pulledPork.mealName  = @"Pulled Pork";
        [comps setDay:17];
        pulledPork.lastDate = [[NSCalendar currentCalendar] dateFromComponents:comps];
        Meal *ham= [Meal MR_createEntity];
        ham.mealName  = @"Ham";
        [comps setDay:18];
        ham.lastDate = [[NSCalendar currentCalendar] dateFromComponents:comps];
        Meal *tacos = [Meal MR_createEntity];
        tacos.mealName  = @"Tacos";
        [comps setDay:19];
        tacos.lastDate = [[NSCalendar currentCalendar] dateFromComponents:comps];
        Meal *porkChops = [Meal MR_createEntity];
        porkChops.mealName  = @"Pork Chops";
        [comps setDay:23];
        porkChops.lastDate = [[NSCalendar currentCalendar] dateFromComponents:comps];
        Meal *meatloaf = [Meal MR_createEntity];
        meatloaf.mealName  = @"Meatloaf";
        [comps setDay:26];
        meatloaf.lastDate = [[NSCalendar currentCalendar] dateFromComponents:comps];
        Meal *turkey = [Meal MR_createEntity];
        turkey.mealName  = @"Turkey";
        [comps setMonth:4];
        [comps setDay:1];
        turkey.lastDate = [[NSCalendar currentCalendar] dateFromComponents:comps];
        // Save Managed Object Context
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:nil];
        
        // Set User Default to prevent another preload of data on startup.
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"MP_HasPrefilledMeals"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        self.tentativePlanExists = NO;
        self.savedPlanExists = NO;
        self.lastPlanDate = [NSDate date];
        self.planIsSavedToCoreData = NO;
        NSDate *now = [NSDate date];
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *components = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSWeekCalendarUnit | NSWeekdayCalendarUnit fromDate:now];
        NSUInteger weekdayToday = [components weekday];
        NSInteger daysFromMonday = (weekdayToday + 5) % 7;
        self.lastPlanDate = [now  dateByAddingTimeInterval:-1 * (60*60*24*daysFromMonday)];
        NSLog(@"lastPlanDate = %@", self.lastPlanDate);
    });
   
    return YES;
    
}

//- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.}

- (void) applicationWillResignActive:(NSNotification *) notification {
        NSString *filePath = [self dataFilePath];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    array[0] = [NSNumber numberWithBool:self.savedPlanExists];
    array[1] = [NSNumber numberWithBool:self.planIsSavedToCoreData];
    array[2] = self.lastPlanDate;
        [array writeToFile:filePath atomically:YES]; }


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    NSString *filePath = [self dataFilePath];
    if ([[ NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSArray *array = [[ NSArray alloc] initWithContentsOfFile:filePath];
        self.savedPlanExists = array[0];
        self.planIsSavedToCoreData = array[1];
       self.lastPlanDate = array[2];
        NSLog(@"Retrieving data from storage: %@", array);
    }
    UIApplication *app = [UIApplication sharedApplication];
    
    [[ NSNotificationCenter defaultCenter] addObserver:self selector:@ selector( applicationWillResignActive:) name:UIApplicationWillResignActiveNotification object:app];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (NSString *) dataFilePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex: 0];
    return [documentsDirectory stringByAppendingPathComponent:@" data.plist"];
}


@end
