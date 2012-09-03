//
//  Favourite.h
//  Unseen
//
//  Created by Matthew Atkins on 31/08/2012.
//  Copyright (c) 2012 Yoomee. All rights reserved.
//

#import <RestKit/RestKit.h>
#import <RestKit/CoreData.h>

@class Photo;

@interface Favourite : NSManagedObject {
}

@property (nonatomic, retain) NSNumber * favouriteID;
@property (nonatomic, retain) NSManagedObject *favouriteable;
@property (nonatomic, retain) Photo *photo;

@end
