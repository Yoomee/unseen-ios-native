//
//  CollectViewController.m
//  Unseen
//
//  Created by Matthew Atkins on 23/08/2012.
//  Copyright (c) 2012 Yoomee. All rights reserved.
//

#import "CollectViewController.h"

@implementation CollectViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    UITabBar *tabBar = self.tabBarController.tabBar;
    
    tabBar.backgroundImage = [UIImage imageNamed:@"tab-bar-bg"];
    tabBar.selectionIndicatorImage = [UIImage imageNamed:@"active-tab-bg"];
    tabBar.selectedImageTintColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    
    for(int i = 0; i < tabBar.items.count; i++){
        UITabBarItem *tabBarItem = [tabBar.items objectAtIndex:i];
        [tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [UIFont fontWithName:@"Apercu" size:10.0], UITextAttributeFont, nil]
                                  forState:UIControlStateNormal];
    }  
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction)didPressProgrammeButton:(id)sender {
    [self.tabBarController setSelectedIndex:1];
    UINavigationController *navigationController = (UINavigationController *)self.tabBarController.selectedViewController;
    UIViewController *fairViewController = [[navigationController viewControllers] objectAtIndex:0];
    [fairViewController performSegueWithIdentifier:@"ProgrammeViewController" sender:fairViewController];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
}

@end
