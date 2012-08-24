//
//  PhotographersViewController.h
//  Unseen
//
//  Created by Matthew Atkins on 24/08/2012.
//  Copyright (c) 2012 Yoomee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>

@interface PhotographersViewController : UITableViewController <RKObjectLoaderDelegate>{
    
}

@property (nonatomic, strong) NSArray *photographers;

- (void) loadData;
- (void) loadObjectsFromDataStore;

@end
