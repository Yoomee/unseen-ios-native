//
//  Page.h
//  Unseen
//
//  Created by Matthew Atkins on 29/08/2012.
//  Copyright (c) 2012 Yoomee. All rights reserved.
//

#import <RestKit/RestKit.h>
#import <RestKit/CoreData.h>

@class Photographer;

@interface Page : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * pageID;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSString * imageURL;
@property (nonatomic, retain) NSString * thumbnailImageURL;
@property (nonatomic, retain) NSString * videoURL;
@property (nonatomic, retain) NSNumber * imageHeight;
@property (nonatomic, retain) NSNumber * parentID;
@property (nonatomic, retain) NSSet *parent;
@property (nonatomic, retain) Page *children;

@end
