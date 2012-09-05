//
//  ProfileViewController.h
//  Unseen
//
//  Created by Matthew Atkins on 30/08/2012.
//  Copyright (c) 2012 Yoomee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>

@class Photo;

@interface ProfileViewController : UIViewController <RKObjectLoaderDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) NSArray *photos;

@property(nonatomic) BOOL postingFavourites;

@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *name1;
@property (weak, nonatomic) IBOutlet UILabel *name2;
@property (weak, nonatomic) IBOutlet UILabel *pageNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *myCollectionLabel;

@property (weak, nonatomic) IBOutlet UIScrollView *photosView;
@property (weak, nonatomic) IBOutlet UIView *loggedOutOverlay;
@property (weak, nonatomic) IBOutlet UIButton *connectButton;

- (IBAction)didPressConnectButton:(id)sender;
- (void) loadData;
- (void) postFavourites;
- (void) renderView;
- (void) loadObjectsFromDataStore;

@end
