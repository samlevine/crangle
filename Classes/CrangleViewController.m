//
//  CrangleViewController.m
//  Crangle
//
//  Copyright 2010 Samuel Levine.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import "CrangleViewController.h"
#import "CrangleAppDelegate.h"
#import "Event.h"

@implementation CrangleViewController

@synthesize destinationControl, sendButton, addressField, emailField, contactsButton, eventsArray, 
			managedObjectContext, locationManager;

- (void)viewDidLoad {
	
	[super viewDidLoad];
	
	
	
	
	
	UIButton *_contactsButton = [UIButton buttonWithType:UIButtonTypeCustom];
	// FIXME: This image is pretty mediocre. It also should be 24 pixels
	[_contactsButton setImage:[UIImage imageNamed:@"PlusIcon.png"] forState:UIControlStateNormal];
	//[_contactsButton setImage:[UIImage imageNamed:@"Plusicon.png"] forState:UIControlStateSelected];
	[_contactsButton setImage:[UIImage imageNamed:@"PlusIcon.png"] forState:UIControlStateHighlighted];
	_contactsButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
	_contactsButton.bounds = CGRectMake(0, 0, 24, 24);
	[_contactsButton addTarget:self action:@selector(showPeoplePickerController) forControlEvents:UIControlEventTouchUpInside];
	emailField.rightView = _contactsButton;
	emailField.rightViewMode = UITextFieldViewModeAlways;
	
	
	[[self locationManager] startUpdatingLocation];
	
	//[self addEvent];

	 
	 
	 
	
	
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



- (NSString *)longestDuration: (id)array {
	//id object;
	//id innerObject;
	//id moreInnerObject;
	//NSString *currentLongestDuration;
	NSString *returnLongestDuration;
	//NSString *thisLongestDuration;
	//NSMutableString *resultLongestDurationString = [NSMutableString stringWithString:@""];
	//NSMutableString *longestDurationString = [NSMutableString stringWithString:@""];
	//BOOL compare = NO;
	
	// this is a horrible hack
	returnLongestDuration = [[[[[[array valueForKey: @"routes"] objectAtIndex:0] objectForKey: @"legs"] objectAtIndex:0] objectForKey: @"duration"] objectForKey: @"text"];
	
							 /*
							 
	call (id)[array valueForKey: @"routes"]
	call (id)[$1 objectAtIndex:0]
	call (id)[$2 objectForKey: @"legs"]
	call (id)[$3 objectAtIndex:0]
	call (id)[$4 objectForKey: @"duration"]
	call (id)[$5 objectForKey: @"text"]
	*/
	/*
	if ([array respondsToSelector: @selector(objectEnumerator)]
		&& [array respondsToSelector: @selector(objectForKey:)]) {
		@try {
			if ([array objectForKey:@"duration"]) {
				//NSLog(@"%@", [array objectForKey:@"duration"]);
				NSLog(@"%@", [[array objectForKey:@"duration"] objectForKey:@"text"]);
				thisLongestDuration = [[array objectForKey:@"duration"] objectForKey:@"text"];
				//longestDurationString = [NSMutableString stringWithString:currentLongestDuration];
				compare = YES;
			}
			
		}
		@catch (NSException * e) {
			//do nothing
		}
	 
	 */
	/*
		NSEnumerator *e = [array objectEnumerator];
		while (object = [e nextObject]) {
			if ([object respondsToSelector: @selector(objectEnumerator)]) {
				NSEnumerator *innerE = [object objectEnumerator];
				while (innerObject = [innerE nextObject]) {
					@try {
						
						if ([innerObject objectForKey:@"legs"]) {
							NSEnumerator *moreInnerE = [innerObject objectEnumerator];
							while (moreInnerObject  = [moreInnerE nextObject]) {
								if ([moreInnerObject objectForKey:@"legs"]) {
									//NSLog(@"%@", [array objectForKey:@"duration"]);
									//NSLog(@"%@", [[object objectForKey:@"duration"] objectForKey:@"text"]);
									returnLongestDuration = [[[innerObject objectForKey:@"legs"]
															  objectForKey:@"duration"]
															 objectForKey:@"text"];
									//longestDurationString = [NSMutableString stringWithString:currentLongestDuration];
									compare = YES;
								}

							}

						}
						
					}
					@catch (NSException * e) {
						continue;
					}
				}

			
			
			
			//NSString *nextLongestDuration = [self longestDuration:object];
			/*	
			if (compare && thisLongestDuration) {
				NSComparisonResult result = [thisLongestDuration compare:currentLongestDuration];
				if (result == NSOrderedAscending) {
					// currentLongestDuration is equal to nextLongestDuration;
					compare = NO;
				} else {
					currentLongestDuration = thisLongestDuration;
					compare = NO;
				}

			} */
	/*
		}
		//resultLongestDurationString = [NSMutableString stringWithString:longestDurationString];
	} 
	*/
	

	return returnLongestDuration;
}


- (void)sendButtonClicked: (id)sender {	
	
	// If it's not possible to get a location, then return.
	// FIXME: let the end user know what happened
	CLLocation *location = [locationManager location];
	if (!location) {
		return;
	}
	
	[self addEvent];
	
	/*
	 Fetch existing events.
	 Create a fetch request; find the Event entity and assign it to the request; add a sort descriptor; then execute the fetch.
	 */
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Event" inManagedObjectContext: managedObjectContext];
	[request setEntity:entity];
	
	// Order the events by creation date, most recent first.
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"creationDate" ascending:NO];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
	[request setSortDescriptors:sortDescriptors];
	[sortDescriptor release];
	[sortDescriptors release];
	
	// Execute the fetch -- create a mutable copy of the result.
	NSError *error = nil;
	NSMutableArray *mutableFetchResults = [[managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
	if (mutableFetchResults == nil) {
		// Handle the error.
	}
	
	// Set self's events array to the mutable array, then clean up.
	[self setEventsArray:mutableFetchResults];
	[mutableFetchResults release];
	[request release];
	
	//[eventsArray getObjects:<#(id *)objects#> range:<#(NSRange)range#>
	
	static NSNumberFormatter *numberFormatter = nil;
	if (numberFormatter == nil) {
		numberFormatter = [[NSNumberFormatter alloc] init];
		[numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
		[numberFormatter setMaximumFractionDigits:1];
	}
	Event *event = (Event *)[eventsArray objectAtIndex:[eventsArray count] -1 ];
	
	// origin=lat,lon 
	NSString *destination = [addressField text];
	destination = [destination stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
	NSString *travelMethod;
	switch ([destinationControl selectedSegmentIndex]) {
		case 1:
			travelMethod = @"bicycling";
			break;
		case 2:
			travelMethod = @"walking";
			break;
		default:
			travelMethod = @"driving";
			break;
	}
	
	NSString *origin = [NSString stringWithFormat:@"%@,%@",
						[numberFormatter stringFromNumber:[event latitude]],
						[numberFormatter stringFromNumber:[event longitude]]];
	
	//url should be something like http://maps.googleapis.com/maps/api/directions/json?origin=Seattle,WA&destination=Ballard,WA&mode=bicycling&sensor=true
	NSString *url = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/directions/json?origin=%@&destination=%@&mode=%@&sensor=true", origin, destination, travelMethod];
	
	//NSData *directionData = [NSData dataWithContentsOfURL: [NSURL URLWithString:url]];
	
	NSString *directionString = [NSString stringWithContentsOfURL: [NSURL URLWithString:url] encoding:NSASCIIStringEncoding error:&error];
	
	NSDictionary *directionResults = [directionString JSONValue];
	NSArray *durationResults = [directionResults objectForKey:@"routes"];
	NSInteger seconds = 0;

	for (NSDictionary *result in durationResults) {
		NSArray *legsArray = [result objectForKey:@"legs"];
		for (NSDictionary *legsResult in legsArray) {
			NSArray *stepsArray = [legsResult objectForKey:@"steps"];
			for (NSDictionary *stepsResult in stepsArray) {
				NSNumber *item = [[stepsResult objectForKey:@"duration"] objectForKey:@"value"];
				seconds += [item intValue];
			}
		}
	}
	
	
	//NSArray *arrayFromString = [directionData yajl_JSON];
	//NSString *duration = [self longestDuration:arrayFromString];
	NSString *duration = [NSString stringWithFormat:@"%d", seconds / 60];
	NSString *formattedNumberString;
	if ([numberFormatter stringFromNumber:[event kph]]) {
		formattedNumberString = [numberFormatter stringFromNumber:[event kph]];
	} else {
		formattedNumberString = @"0";
	}

	
	NSString *body = [NSString stringWithFormat:@"transportation: %@\nlat: %@\nlon: %@\nkph: %@\nETA: %@",
					  [destinationControl titleForSegmentAtIndex:[destinationControl selectedSegmentIndex]],
					  [numberFormatter stringFromNumber:[event latitude]],
					  [numberFormatter stringFromNumber:[event longitude]],
					  formattedNumberString,
					  duration];
					 
	[self sendEmailTo:[emailField text]
		  withSubject:[addressField text]
			 withBody:body];
	
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

- (void)addEvent {
	
	// If it's not possible to get a location, then return.
	CLLocation *location = [locationManager location];
	if (!location) {
		return;
	}
	
	/*
	 Create a new instance of the Event entity.
	 */
	Event *event = (Event *)[NSEntityDescription insertNewObjectForEntityForName:@"Event" inManagedObjectContext:managedObjectContext];
	
	// Configure the new event with information from the location.
	CLLocationCoordinate2D coordinate = [location coordinate];
	CLLocationSpeed speed = [location speed];
	[event setLatitude:[NSNumber numberWithDouble:coordinate.latitude]];
	[event setLongitude:[NSNumber numberWithDouble:coordinate.longitude]];
	// need to test this in a moving vehicle of sorts
	if (speed > 0) {
		[event setKph:[NSNumber numberWithDouble:speed]];
	} else {
		[event setKph:0];
	}

	
	//NSLog( @"%@", [location description]);
	// Should be the location's timestamp, but this will be constant for simulator.
	// [event setCreationDate:[location timestamp]];
	[event setCreationDate:[NSDate date]];
	
	// Commit the change.
	NSError *error;
	if (![managedObjectContext save:&error]) {
		// Handle the error.
	}
	
	/*
	 Since this is a new event, and events are displayed with most recent events at the top of the list,
	 add the new event to the beginning of the events array; then redisplay the table view.
	 */
    [eventsArray insertObject:event atIndex:0];
	//NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
	//[self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
	//[self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

#pragma mark People picker methods

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person
{
	return YES;
}

// Does not allow users to perform default actions such as dialing a phone number, when they select a person property.
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person 
								property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
	id theProperty = (id)ABRecordCopyValue(person, property);
	int propertyType = ABPersonGetTypeOfProperty(property);
	
	if (propertyType == kABStringPropertyType) {
		printf("kABStringPropertyType %s\n", [theProperty UTF8String]);
	} else if (propertyType == kABIntegerPropertyType) {
		printf("kABIntegerPropertyType %d\n", [theProperty integerValue]);
	} else if (propertyType == kABRealPropertyType) {
		printf("kABRealPropertyType %f\n", [theProperty floatValue]);
	} else if (propertyType == kABDateTimePropertyType) {
		printf("kABDateTimePropertyType %s\n", [[theProperty description] UTF8String]);
	} else if (propertyType == kABMultiStringPropertyType) {
		printf("kABMultiStringPropertyType %s\n",
			   [[(NSArray *)ABMultiValueCopyArrayOfAllValues(theProperty)
				 objectAtIndex:identifier] UTF8String]);
		emailField.text = [(NSArray *)ABMultiValueCopyArrayOfAllValues(theProperty) objectAtIndex:identifier];
		
		[self dismissModalViewControllerAnimated:YES];
		CFRelease(theProperty);
		return NO;
	} else if (propertyType == kABMultiIntegerPropertyType) {
		printf("kABMultiIntegerPropertyType %d\n",
			   [[(NSArray *)
				 ABMultiValueCopyArrayOfAllValues(theProperty)
				 objectAtIndex:identifier] integerValue]);
	} else if (propertyType == kABMultiRealPropertyType) {
		printf("kABMultiRealPropertyType %f\n",
			   [[(NSArray *)
				 ABMultiValueCopyArrayOfAllValues(theProperty)
				 objectAtIndex:identifier] floatValue]);
	} else if (propertyType == kABMultiDateTimePropertyType) {
		printf("kABMultiDateTimePropertyType %s\n",
			   [[[(NSArray *)ABMultiValueCopyArrayOfAllValues(theProperty)
				  objectAtIndex:identifier] description] UTF8String]);
	} else if (propertyType == kABMultiDictionaryPropertyType) {
		printf("kABMultiDictionaryPropertyType %s\n",
			   [[[(NSArray *)ABMultiValueCopyArrayOfAllValues(theProperty)
				 objectAtIndex:identifier] description] UTF8String]);
	}
	
	
	//emailField.text = [(NSArray *)ABMultiValueCopyArrayOfAllValues(theProperty) objectAtIndex:identifier];
	
	//[self dismissModalViewControllerAnimated:YES];
	//CFRelease(theProperty);
	return NO;
}

// Dismisses the people picker and shows the application when users tap Cancel. 
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker;
{
	[self dismissModalViewControllerAnimated:YES];
}

// Called when users tap "Display Picker" in the application. Displays a list of contacts and allows users to select a contact from that list.
// The application only shows the phone, email, and birthdate information of the selected contact.
-(void)showPeoplePickerController
{
	ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc] init];
    picker.peoplePickerDelegate = self;
	// Display only a person's email
	NSArray *displayedItems = [NSArray arrayWithObjects: [NSNumber numberWithInt:kABPersonEmailProperty], nil];
	
	
	picker.displayedProperties = displayedItems;
	// Show the picker 
	[self presentModalViewController:picker animated:YES];
    [picker release];	
}

#pragma mark cleanup


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	contactsButton = nil;
	// Release any properties that are loaded in viewDidLoad or can be recreated lazily.
	self.eventsArray = nil;
	self.locationManager = nil;
	//self.addButton = nil;
}


- (void)dealloc {
	[contactsButton release];
    [super dealloc];
}

@end
