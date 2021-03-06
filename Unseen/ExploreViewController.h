//
//  ExploreViewController.h
//  Unseen
//
//  Created by Matthew Atkins on 06/09/2012.
//  Copyright (c) 2012 Yoomee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>

@interface ExploreViewController : UITableViewController <RKObjectLoaderDelegate>{    
}

@property (nonatomic, strong) NSArray *pages;

- (void) loadData;
- (void) loadObjectsFromDataStore;

@end
