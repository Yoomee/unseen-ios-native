//
//  AppDelegate.m
//  Unseen
//
//  Created by Matthew Atkins on 23/08/2012.
//  Copyright (c) 2012 Yoomee. All rights reserved.
//

#import <RestKit/RestKit.h>
#import <RestKit/CoreData.h>
#import "AppDelegate.h"
#import "constants.h"
#import "Event.h"
#import "Favourite.h"
#import "FavouritesSync.h"
#import "Gallery.h"
#import "Page.h"
#import "Photographer.h"
#import "Photo.h"

@implementation AppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{   
    
//    RKLogConfigureByName("RestKit", RKLogLevelWarning); 
//    RKLogConfigureByName("RestKit/ObjectMapping", RKLogLevelTrace);
//    RKLogConfigureByName("RestKit/Network", RKLogLevelTrace);
    
    // Load default defaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults registerDefaults:[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Defaults" ofType:@"plist"]]];
    [defaults synchronize];
    
    // Initialize RestKit
    RKClient* client = [RKClient clientWithBaseURL:[NSURL URLWithString:kBaseURL]];  
    [client setValue:[defaults stringForKey:@"UserApiKey"] forHTTPHeaderField:@"APIKEY"];
    
    RKObjectManager* objectManager = [RKObjectManager managerWithBaseURLString:[NSString stringWithFormat:@"%@/api/2", kBaseURL]];
    [[objectManager client] setValue:[defaults stringForKey:@"UserApiKey"] forHTTPHeaderField:@"APIKEY"];
    
    // Enable automatic network activity indicator management
    objectManager.client.requestQueue.showsNetworkActivityIndicatorWhenBusy = YES;
    
    // Initialize object store
    NSString *seedDatabaseName = @"UnseenSeed.sqlite";
    NSString *databaseName = @"Unseen.sqlite";
    
    if (NO) {
        NSLog(@"Replacing database");
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
        NSString *documentsDirectoryPath = [paths objectAtIndex:0];
        NSString *dbFilePath = [documentsDirectoryPath stringByAppendingPathComponent:databaseName];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtPath:dbFilePath error:NULL];
        
        NSDate *today = [NSDate date];
        NSDate *yesterday = [today dateByAddingTimeInterval: -86400.0];
        [[NSUserDefaults standardUserDefaults] setObject:yesterday forKey:@"EventsLastUpdatedAt"];
        [[NSUserDefaults standardUserDefaults] setObject:yesterday forKey:@"GalleriesLastUpdatedAt"];
        [[NSUserDefaults standardUserDefaults] setObject:yesterday forKey:@"PagesLastUpdatedAt"];
        [[NSUserDefaults standardUserDefaults] setObject:yesterday forKey:@"PhotographersLastUpdatedAt"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } 
    
    //objectManager.objectStore = [RKManagedObjectStore objectStoreWithStoreFilename:databaseName usingSeedDatabaseName:seedDatabaseName managedObjectModel:nil delegate:self];
    objectManager.objectStore =[RKManagedObjectStore objectStoreWithStoreFilename:databaseName];
    
    // Setup our object mappings
    /*!
     Mapping by entity. Here we are configuring a mapping by targetting a Core Data entity with a specific
     name. This allows us to map back Twitter user objects directly onto NSManagedObject instances --
     there is no backing model class!
     */
    
    RKManagedObjectMapping* pageMapping = [RKManagedObjectMapping mappingForClass:[Page class] inManagedObjectStore:objectManager.objectStore];
    pageMapping.primaryKeyAttribute = @"pageID";
    [pageMapping mapKeyPath:@"id" toAttribute:@"pageID"];
    [pageMapping mapKeyPath:@"parent_id" toAttribute:@"parentID"];
    [pageMapping mapKeyPath:@"title" toAttribute:@"title"];
    [pageMapping mapKeyPath:@"text" toAttribute:@"text"];
    [pageMapping mapKeyPath:@"image_url_for_api" toAttribute:@"imageURL"];
    [pageMapping mapKeyPath:@"image_height_for_api" toAttribute:@"imageHeight"];
    [pageMapping mapKeyPath:@"thumbnail_image_url_for_api" toAttribute:@"thumbnailImageURL"];
    [pageMapping mapKeyPath:@"publication_date" toAttribute:@"publicationDate"];
    [objectManager.mappingProvider setObjectMapping:pageMapping forResourcePathPattern:@"/pages"];
    [pageMapping mapRelationship:@"parent" withMapping:pageMapping];
    [pageMapping mapRelationship:@"children" withMapping:pageMapping];
    
    RKManagedObjectMapping* eventMapping = [RKManagedObjectMapping mappingForClass:[Event class] inManagedObjectStore:objectManager.objectStore];
    eventMapping.primaryKeyAttribute = @"eventID";
    [eventMapping mapKeyPath:@"id" toAttribute:@"eventID"];
    [eventMapping mapKeyPath:@"title" toAttribute:@"title"];
    [eventMapping mapKeyPath:@"description" toAttribute:@"text"];
    [eventMapping mapKeyPath:@"image_url_for_api" toAttribute:@"imageURL"];
    [eventMapping mapKeyPath:@"image_height_for_api" toAttribute:@"imageHeight"];
    [eventMapping mapKeyPath:@"venue_name" toAttribute:@"venue"];
    [eventMapping mapKeyPath:@"time_string" toAttribute:@"time"];
    [eventMapping mapKeyPath:@"day1" toAttribute:@"day1"];
    [eventMapping mapKeyPath:@"day2" toAttribute:@"day2"];
    [eventMapping mapKeyPath:@"day3" toAttribute:@"day3"];
    [eventMapping mapKeyPath:@"day4" toAttribute:@"day4"];
    [eventMapping mapKeyPath:@"day5" toAttribute:@"day5"];    
    [objectManager.mappingProvider setObjectMapping:eventMapping forResourcePathPattern:@"/events"];
    
    RKManagedObjectMapping* galleryMapping = [RKManagedObjectMapping mappingForClass:[Gallery class] inManagedObjectStore:objectManager.objectStore];
    galleryMapping.primaryKeyAttribute = @"galleryID";
    [galleryMapping mapKeyPath:@"id" toAttribute:@"galleryID"];
    [galleryMapping mapKeyPath:@"title" toAttribute:@"name"];
    [galleryMapping mapKeyPath:@"contact_details" toAttribute:@"text"];
    [objectManager.mappingProvider setObjectMapping:galleryMapping forResourcePathPattern:@"/galleries"];
    
    RKManagedObjectMapping* photographerMapping = [RKManagedObjectMapping mappingForClass:[Photographer class] inManagedObjectStore:objectManager.objectStore];
    photographerMapping.primaryKeyAttribute = @"photographerID";
    [photographerMapping mapKeyPath:@"id" toAttribute:@"photographerID"];
    [photographerMapping mapKeyPath:@"full_name" toAttribute:@"name"];
    [photographerMapping mapKeyPath:@"bio" toAttribute:@"bio"];
    [photographerMapping mapKeyPath:@"image_url_for_api" toAttribute:@"imageURL"];
    [objectManager.mappingProvider setObjectMapping:photographerMapping forResourcePathPattern:@"/photographers"];
    
    RKManagedObjectMapping *photoMapping = [RKManagedObjectMapping mappingForClass:[Photo class] inManagedObjectStore:objectManager.objectStore];
    photoMapping.primaryKeyAttribute = @"photoID";
    [photoMapping mapKeyPath:@"id" toAttribute:@"photoID"];
    [photoMapping mapKeyPath:@"image_url_for_api" toAttribute:@"imageURL"];
    [photoMapping mapKeyPath:@"caption" toAttribute:@"caption"];
    
    [photographerMapping mapKeyPath:@"galleries" toRelationship:@"galleries" withMapping:galleryMapping serialize:NO];
    [photographerMapping mapKeyPath:@"photos" toRelationship:@"photos" withMapping:photoMapping serialize:NO];
    
    [galleryMapping mapKeyPath:@"photographers" toRelationship:@"photographers" withMapping:photographerMapping serialize:NO];
    [galleryMapping mapKeyPath:@"photos" toRelationship:@"photos" withMapping:photoMapping serialize:NO];
    
    RKManagedObjectMapping* favouriteMapping = [RKManagedObjectMapping mappingForClass:[Favourite class] inManagedObjectStore:objectManager.objectStore];
    favouriteMapping.primaryKeyAttribute = @"favouriteID";
    [favouriteMapping mapKeyPath:@"id" toAttribute:@"favouriteID"];
    [favouriteMapping mapKeyPath:@"deleted" toAttribute:@"destroyed"];
    [favouriteMapping mapKeyPath:@"synced" toAttribute:@"synced"];
    [favouriteMapping mapKeyPath:@"updated_at" toAttribute:@"updatedAt"];
    [favouriteMapping mapRelationship:@"event" withMapping:eventMapping];
    [favouriteMapping mapRelationship:@"gallery" withMapping:galleryMapping];
    [favouriteMapping mapRelationship:@"photo" withMapping:photoMapping];
    [favouriteMapping mapRelationship:@"photographer" withMapping:photographerMapping];
    [objectManager.mappingProvider setObjectMapping:favouriteMapping forResourcePathPattern:@"/favourites"];
    
    RKObjectMapping* favouriteSerializationMapping = [favouriteMapping inverseMapping];
    [[RKObjectManager sharedManager].mappingProvider setSerializationMapping:favouriteSerializationMapping forClass:[Favourite class]]; 

    
    RKObjectRouter *router = [RKObjectManager sharedManager].router;
    [router routeClass:[Favourite class] toResourcePath:@"/favourites/:favouriteID"];
    [router routeClass:[Favourite class] toResourcePath:@"/favourites" forMethod:RKRequestMethodPOST]; 
    
    
    [eventMapping mapKeyPath:@"favourite" toRelationship:@"favourite" withMapping:favouriteMapping serialize:NO];
    [galleryMapping mapKeyPath:@"favourite" toRelationship:@"favourite" withMapping:favouriteMapping serialize:NO];
    [photoMapping mapKeyPath:@"favourite" toRelationship:@"favourite" withMapping:favouriteMapping serialize:NO];
    [photographerMapping mapKeyPath:@"favourite" toRelationship:@"favourite" withMapping:favouriteMapping serialize:NO];
    [photoMapping mapKeyPath:@"photographer" toRelationship:@"photographer" withMapping:photographerMapping serialize:NO];
    [photoMapping mapKeyPath:@"galleries" toRelationship:@"galleries" withMapping:galleryMapping serialize:NO];
    
    //now, we create mapping for the MySyncEntity
    RKObjectMapping *favouritesSyncMapping = [RKObjectMapping mappingForClass:[FavouritesSync class]];
    favouritesSyncMapping.rootKeyPath = @"sync"; 
    [favouritesSyncMapping mapKeyPath:@"favourites" toRelationship:@"favourites" withMapping:favouriteMapping];
    [favouriteMapping mapKeyPath:@"sync" toRelationship:@"sync" withMapping:favouritesSyncMapping serialize:NO];
    
    RKObjectMapping* favouritesSyncSerializationMapping = [favouritesSyncMapping inverseMapping];
    [[RKObjectManager sharedManager].mappingProvider setSerializationMapping:favouritesSyncSerializationMapping forClass:[FavouritesSync class]]; 
    
    
    [router routeClass:[FavouritesSync class] toResourcePath:@"/favourites_sync"];

    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (BOOL) application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    if ([[url host] isEqualToString:@"api"]) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSDictionary *userParams =[url queryParameters];
        for (NSString *key in userParams){
            [defaults setValue:[userParams objectForKey:key] forKey:key];   
        }
        [defaults synchronize];
        [[RKClient sharedClient] setValue:[defaults stringForKey:@"UserApiKey"] forHTTPHeaderField:@"APIKEY"];
        [[[RKObjectManager sharedManager] client] setValue:[defaults stringForKey:@"UserApiKey"] forHTTPHeaderField:@"APIKEY"];
    }
    UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
    [tabBarController setSelectedIndex:2];
    [tabBarController setSelectedIndex:3];
    return YES;
}

@end
