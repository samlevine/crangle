//
//  CrangleViewController.m
//  Crangle
//
//  Created by Samuel Levine on 11/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CrangleViewController.h"

@implementation CrangleViewController

@synthesize destinationControl, sendButton, addressField, emailField, contactsButton, locationManager;
//,eventsArray, managedObjectContext, locationManager;

- (void)viewDidLoad {
	
	[super viewDidLoad];
	// FIXME
	UIButton *_contactsButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[_contactsButton setImage:[UIImage imageNamed:@"PlusIcon.png"] forState:UIControlStateNormal];
	[_contactsButton setImage:[UIImage imageNamed:@"Plusicon.png"] forState:UIControlStateSelected];
	[_contactsButton setImage:[UIImage imageNamed:@"PlusIcon.png"] forState:UIControlStateHighlighted];
	//_contactsButton.imageEdgeInsets = UIEdgeInsetsMake(0, -16, 0, 0);
	//[_contactsButton addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventTouchUpInside];
	emailField.rightView = _contactsButton;
	emailField.rightViewMode = UITextFieldViewModeAlways;
	// ENDFIXME
	
	[[self locationManager] startUpdatingLocation];
}

/**
 Return a location manager -- create one if necessary.
 */
- (CLLocationManager *)locationManager {
	
    if (locationManager != nil) {
		return locationManager;
	}
	
	locationManager = [[CLLocationManager alloc] init];
	[locationManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
	[locationManager setDelegate:self];
	
	return locationManager;
}

- (void)sendButtonClicked: (id)sender {

	//NSLog(@"address: %@, e-mail: %@, transportation: %@", 
	//	  [addressField text],
	//	  [emailField text],
	//	  [destinationControl titleForSegmentAtIndex:[destinationControl selectedSegmentIndex]]);
	[self sendEmailTo:[emailField text]
		  withSubject:[addressField text]
			 withBody:[destinationControl titleForSegmentAtIndex:[destinationControl selectedSegmentIndex]]];
	
}

// sendEmailTo method thanks to Brandon Trebitowski
// http://icodeblog.com/2009/02/20/iphone-programming-tutorial-using-openurl-to-send-email-from-your-app/

- (void) sendEmailTo:(NSString *)to withSubject:(NSString *) subject withBody:(NSString *)body {
	NSString *mailString = [NSString stringWithFormat:@"mailto:?to=%@&subject=%@&body=%@",
							[to stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding],
							[subject stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding],
							[body  stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
	
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:mailString]];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	if ([textField isEqual:addressField])
	{
		[emailField becomeFirstResponder];
	}
		
	if ([textField isEqual:emailField])
	{
		[textField resignFirstResponder];
	}
	return NO;
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	contactsButton = nil;
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[contactsButton release];
    [super dealloc];
}

@end
