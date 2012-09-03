//
//  Photo.h
//  Unseen
//
//  Created by Matthew Atkins on 28/08/2012.
//  Copyright (c) 2012 Yoomee. All rights reserved.
//

#import <RestKit/RestKit.h>
#import <RestKit/CoreData.h>

@class Photographer, Favourite;

@interface Photo : NSManagedObject

@property (nonatomic, retain) NSNumber * photoID;
@property (nonatomic, retain) NSString * imageURL;
@property (nonatomic, retain) NSString * caption;
@property (nonatomic, retain) Photographer *photographer;
@property (nonatomic, retain) Favourite *favourite;

@end