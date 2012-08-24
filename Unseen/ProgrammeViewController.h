//
//  ProgrammeViewController.h
//  Unseen
//
//  Created by Matthew Atkins on 23/08/2012.
//  Copyright (c) 2012 Yoomee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>

@interface ProgrammeViewController : UIViewController <RKObjectLoaderDelegate>{
    UITableView *tableView;
}

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *daySelectorsView;
@property (nonatomic, strong) NSArray *events;


- (IBAction)didPressDaySelector:(id)sender;
- (void) loadData;
- (void)loadObjectsFromDataStoreForDay:(NSInteger)day;
-(NSInteger)selectedDay;

@end
