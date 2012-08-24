//
//  SecondViewController.m
//  Unseen
//
//  Created by Matthew Atkins on 23/08/2012.
//  Copyright (c) 2012 Yoomee. All rights reserved.
//

#import "SecondViewController.h"

@implementation SecondViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    //self.tabBarController.selectedIndex = 1;
    
    self.tabBarController.tabBar.backgroundImage = [UIImage imageNamed:@"tab-bar-bg"];
    self.tabBarController.tabBar.selectionIndicatorImage = [UIImage imageNamed:@"active-tab-bg"];
    self.tabBarController.tabBar.selectedImageTintColor = [UIColor colorWithWhite:1.0 alpha:1.0];
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

- (IBAction)didPressFairAndFestival:(id)sender {
    [self.tabBarController setSelectedIndex:1];
}

- (IBAction)didPressVisitOurSite:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://www.unseenamsterdam.com"]];
}
@end
