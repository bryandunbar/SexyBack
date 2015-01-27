//
//  SB30DayPageViewController.m
//  SexyBack
//
//  Created by Bryan Dunbar on 9/23/14.
//  Copyright (c) 2014 Knight, Norvell and Pater, LLC. All rights reserved.
//

#import "SB30DayPageViewController.h"
#import "SB30DayContentViewController.h"
#import "Constants.h"

@interface SB30DayPageViewController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate>
@property (nonatomic,strong) NSArray *challengeDays;
@property (nonatomic,strong) PFObject *programProgress;
@end

@implementation SB30DayPageViewController

- (void)viewWillAppear:(BOOL)animated {
   // [super viewDidLoad];
    self.delegate = self;
    self.dataSource = self;

    // Get the user's progress
    PFQuery *progressQuery = [PFQuery queryWithClassName:@"ProgramProgress"];
    [progressQuery includeKey:@"completeChallenges"];
    [progressQuery whereKey:@"program" equalTo:self.program];
    [progressQuery whereKey:@"user" equalTo:STATE.user.parseUser];
    [progressQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (objects.count > 0) {
            self.programProgress = objects[0];
        } else {
            self.programProgress = [PFObject objectWithClassName:@"ProgramProgress"];
            self.programProgress[@"program"] = self.program;
            self.programProgress[@"user"] = STATE.user.parseUser;
            //[self.programProgress saveInBackground];
        }
        
        // Get the challenges
        PFQuery *challengeQuery = [PFQuery queryWithClassName:@"Challenge"];
        [challengeQuery whereKey:@"program" equalTo:self.program];
        [challengeQuery orderByAscending:@"day"];
        [challengeQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            self.challengeDays = objects;
            
            self.delegate = self;
            self.dataSource = self;
            SB30DayContentViewController *startingViewController = [self viewControllerAtIndex:0];
            NSArray *viewControllers = @[startingViewController];
            [self setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
            
        }];
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((SB30DayContentViewController*) viewController).pageIndex;
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((SB30DayContentViewController*) viewController).pageIndex;
    
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [self.challengeDays count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

- (SB30DayContentViewController *)viewControllerAtIndex:(NSUInteger)index
{
    // Create a new view controller and pass suitable data.
    SB30DayContentViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SB30DayContentViewController"];
    pageContentViewController.pageIndex = index;
    pageContentViewController.challengeObj = self.challengeDays[index];
    pageContentViewController.program = self.program;
    pageContentViewController.programProgress = self.programProgress;
    return pageContentViewController;
}

@end
