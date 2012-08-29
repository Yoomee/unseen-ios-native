//
//  GalleryViewController.h
//  Unseen
//
//  Created by Matthew Atkins on 29/08/2012.
//  Copyright (c) 2012 Yoomee. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DDPageControl, Gallery, Photographer;

@interface GalleryViewController : UIViewController<UIScrollViewDelegate>{
    DDPageControl *pageControl;
}

@property (nonatomic, strong) Gallery *gallery;
@property (nonatomic, strong) Photographer *selectedPhotographer;
@property (nonatomic, strong) NSArray *photographers;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *representedArtistsLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *photosView;
@property (weak, nonatomic) IBOutlet UITextView *galleryTextView;

- (IBAction)showPhotographer:(id)sender;

@end
