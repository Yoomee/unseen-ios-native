//
//  PhotographerViewController.h
//  Unseen
//
//  Created by Matthew Atkins on 28/08/2012.
//  Copyright (c) 2012 Yoomee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Photographer.h"

@class DDPageControl;

@interface PhotographerViewController : UIViewController <UIScrollViewDelegate> {
    DDPageControl *pageControl;
}

@property (nonatomic, strong) Photographer *photographer;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *name1;
@property (weak, nonatomic) IBOutlet UILabel *name2;
@property (weak, nonatomic) IBOutlet UILabel *galleryLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *photosView;
@property (weak, nonatomic) IBOutlet UITextView *bioTextView;

@end
