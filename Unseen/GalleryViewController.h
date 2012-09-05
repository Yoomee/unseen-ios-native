//
//  GalleryViewController.h
//  Unseen
//
//  Created by Matthew Atkins on 29/08/2012.
//  Copyright (c) 2012 Yoomee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>

@class DDPageControl, Gallery, Photographer, Photo;

@interface GalleryViewController : UIViewController<RKRequestDelegate, RKObjectLoaderDelegate, UIScrollViewDelegate>{
    DDPageControl *pageControl;
}

@property (nonatomic, strong) Gallery *gallery;
@property (nonatomic, strong) Photographer *selectedPhotographer;
@property (nonatomic, strong) Photo *selectedPhoto;

@property (nonatomic, strong) NSArray *photographers;
@property (nonatomic, strong) NSArray *photos;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *representedArtistsLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *photosView;
@property (weak, nonatomic) IBOutlet UITextView *galleryTextView;
@property (weak, nonatomic) IBOutlet UIButton *favouriteButton;

- (IBAction)showPhotographer:(id)sender;
- (IBAction)showPhoto:(id)sender;
- (IBAction)didPressFavouriteButton:(id)sender;

@end
