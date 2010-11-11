//
//  CrangleAppDelegate.h
//  Crangle
//
//  Created by Samuel Levine on 11/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CrangleViewController;

@interface CrangleAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    CrangleViewController *viewController;
	
//	NSPersistentStoreCoordinator *persistentStoreCoordinator;
//    NSManagedObjectModel *managedObjectModel;
//    NSManagedObjectContext *managedObjectContext;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet CrangleViewController *viewController;

@end

