//
//  CrangleViewController.h
//  Crangle
//
//  Created by Samuel Levine on 11/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "CrangleAppDelegate.h"


@interface CrangleViewController : UIViewController <CLLocationManagerDelegate> {
	IBOutlet UISegmentedControl *destinationControl;
	IBOutlet UIBarButtonItem *sendButton;
	IBOutlet UITextField *addressField;
	IBOutlet UITextField *emailField;
	UIButton *contactsButton;
	
	// location related items
	NSMutableArray *eventsArray;
	//NSManagedObjectContext *managedObjectContext;	    
    CLLocationManager *locationManager;
	
}

@property (nonatomic, retain) IBOutlet UISegmentedControl *destinationControl;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *sendButton;
@property (nonatomic, retain) IBOutlet UITextField *addressField;
@property (nonatomic, retain) IBOutlet UITextField *emailField;
@property (nonatomic, retain) UIButton *contactsButton;

// for using core data later
@property (nonatomic, retain) NSMutableArray *eventsArray;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) CLLocationManager *locationManager;


-(IBAction) sendButtonClicked: (id) sender;
- (void) sendEmailTo:(NSString *)to withSubject:(NSString *) subject withBody:(NSString *)body;
- (BOOL)textFieldShouldReturn:(UITextField *)textField;

// for core data model later
- (void)addEvent;

@end

