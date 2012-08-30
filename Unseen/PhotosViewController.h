//
//  PhotosViewController.h
//  Unseen
//
//  Created by Matthew Atkins on 30/08/2012.
//  Copyright (c) 2012 Yoomee. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Photo;

@interface PhotosViewController : UIViewController <UIScrollViewDelegate>

@property (nonatomic, strong) NSArray *photos;
@property (nonatomic, strong) Photo *selectedPhoto;
@property (weak, nonatomic) IBOutlet UIScrollView *photosView;
@property (weak, nonatomic) IBOutlet UILabel *pageNumberLabel;
@property(nonatomic, assign) int numberOfPages;

- (void)loadObjectsFromDataStore;
- (IBAction)showPhoto:(id)sender;

@end
