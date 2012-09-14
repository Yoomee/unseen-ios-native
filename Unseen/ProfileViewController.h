//
//  ProfileViewController.h
//  Unseen
//
//  Created by Matthew Atkins on 30/08/2012.
//  Copyright (c) 2012 Yoomee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>

@class Photo, Event, Photographer, Gallery;

@interface ProfileViewController : UIViewController <RKObjectLoaderDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) NSArray *photos;
@property (nonatomic, strong) NSArray *events;
@property (nonatomic, strong) NSArray *galleries;
@property (nonatomic, strong) NSArray *photographers;

@property(nonatomic) BOOL postingFavourites;
@property (weak, nonatomic) IBOutlet UIView *eventsView;
@property (weak, nonatomic) IBOutlet UIView *favouritesView;

@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *name1;
@property (weak, nonatomic) IBOutlet UILabel *name2;
@property (weak, nonatomic) IBOutlet UILabel *pageNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *myCollectionLabel;
@property (weak, nonatomic) IBOutlet UILabel *myProgrammeLabel;
@property (weak, nonatomic) IBOutlet UILabel *myFavouritesLabel;

@property (nonatomic, strong) Photo *selectedPhoto;
@property (nonatomic, strong) Event *selectedEvent;
@property (nonatomic, strong) Photographer *selectedPhotographer;
@property (nonatomic, strong) Gallery *selectedGallery;

@property (weak, nonatomic) IBOutlet UIScrollView *photosView;
@property (weak, nonatomic) IBOutlet UIView *loggedOutOverlay;
@property (weak, nonatomic) IBOutlet UIButton *connectButton;

- (IBAction)didPressConnectButton:(id)sender;
- (void) loadData;
- (void) postFavourites;
- (void) renderView;
- (void) loadObjectsFromDataStore;

@end
