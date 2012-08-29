//
//  Photographer.h
//  Unseen
//
//  Created by Matthew Atkins on 23/08/2012.
//  Copyright (c) 2012 Yoomee. All rights reserved.
//

#import <RestKit/RestKit.h>
#import <RestKit/CoreData.h>

@interface Photographer : NSManagedObject{
}

@property (nonatomic, retain) NSNumber *photographerID;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *bio;
@property (nonatomic, retain) NSString *imageURL;
@property (nonatomic, retain) NSSet *photos;
@property (nonatomic, retain) NSSet *galleries;

@end

