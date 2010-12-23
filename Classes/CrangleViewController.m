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
//#import "PinPointAnnotation.h"

@implementation CrangleViewController

@synthesize destinationControl, sendButton, addressField, emailField, centerMapView, contactsButton, eventsArray, 
			managedObjectContext, locationManager, currentCity, mapInitialized;

- (void)viewDidLoad {
	
	[super viewDidLoad];
	
	/* Create the Gesture Recognizer */
	UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc]
												initWithTarget:self
												action:@selector(pressed:)];
	//[recoginizer setNumberOfTapsRequired:1];
	recognizer.minimumPressDuration = 1.0;
	[centerMapView addGestureRecognizer:recognizer];
	recognizer.delegate = self;
	[recognizer release];
	
	[[self locationManager] startUpdatingLocation];
	
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
	
	//CLLocation *location = [locationManager location];
	//CLLocationCoordinate2D coordinate = [location coordinate];

	//[NSNumber numberWithDouble:coordinate.latitude];
	//[NSNumber numberWithDouble:coordinate.longitude];
	 
	 
	
	
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ((touch.phase == UITouchPhaseBegan)) {
		NSLog(@"pressed centerMapView");
        return YES;
    } else {
		return NO;
	}
}

- (void) pressed:(UITapGestureRecognizer*)sender{
	if ((sender.state == UIGestureRecognizerStateBegan)) {
		NSLog(@"pressed");
		CGPoint touchPoint = [sender locationInView:self.centerMapView];   
		CLLocationCoordinate2D touchMapCoordinate = [self.centerMapView 
													 convertPoint:touchPoint 
													 toCoordinateFromView:self.centerMapView];
		// remove all other annotations on map
		for (id annotationToRemove in self.centerMapView.annotations) {
			if (![annotationToRemove isKindOfClass:[MKUserLocation class]]) {
				[centerMapView removeAnnotation:annotationToRemove];
			}
			
		}
		
		PinPointAnnotation *annotation = [[PinPointAnnotation alloc] init];
		annotation.coordinate = touchMapCoordinate;
		annotation.title = @"Destination";
		annotation.subtitle = @"approximate";

		
		
		
		[self.centerMapView addAnnotation:annotation];
		[annotation release];
		
		static NSNumberFormatter *numberFormatter = nil;
		if (numberFormatter == nil) {
			numberFormatter = [[NSNumberFormatter alloc] init];
			[numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
			//[numberFormatter setMaximumFractionDigits:13];
		}
		//FIXME: ideally this should convert the coordinate into an address
		self.addressField.text = [NSString stringWithFormat:@"%f,%f", (double)touchMapCoordinate.latitude, (double)touchMapCoordinate.longitude];
    }
	
}


- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation {
	
	// if it's the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
	
	//
    if ([annotation isKindOfClass:[MKPointAnnotation class]]) // the custom pin annotation
    {
        // try to dequeue an existing pin view first
        static NSString* PinAnnotationIdentifier = @"pinAnnotationIdentifier";
        MKPinAnnotationView* pinView = (MKPinAnnotationView *)
		[centerMapView dequeueReusableAnnotationViewWithIdentifier:PinAnnotationIdentifier];
        if (!pinView)
        {
            // if an existing pin view was not available, create one
            MKPinAnnotationView* customPinView = [[[MKPinAnnotationView alloc]
												   initWithAnnotation:annotation reuseIdentifier:PinAnnotationIdentifier] autorelease];
            //customPinView.pinColor = MKPinAnnotationColorPurple;
            customPinView.animatesDrop = YES;
            customPinView.canShowCallout = YES;
            
            // add a detail disclosure button to the callout which will open a new view controller page
            //
            // note: you can assign a specific call out accessory view, or as MKMapViewDelegate you can implement:
            //  - (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control;
            //
            /*UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            [rightButton addTarget:self
                            action:@selector(showDetails:)
                  forControlEvents:UIControlEventTouchUpInside];
            customPinView.rightCalloutAccessoryView = rightButton;*/
			
            return customPinView;
        }
        else
        {
            pinView.annotation = annotation;
        }
        return pinView;
    }
	return nil;
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



- (void)directionButtonClicked: (id)sender {	}


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
		//[numberFormatter setMaximumFractionDigits:13];
	}
	//Event *event = (Event *)[eventsArray objectAtIndex:[eventsArray count] -1 ];
	Event *event = (Event *)[eventsArray objectAtIndex:0];
	
	// origin=lat,lon 
	NSString *addressFieldText = [[addressField text] lowercaseString];
	NSString *destination;
	if ([addressFieldText hasSuffix:@"st"] ||
		[addressFieldText hasSuffix:@"street"] ||
		[addressFieldText hasSuffix:@"ave"] || 
		[addressFieldText hasSuffix:@"avenue"] ||
		[addressFieldText hasSuffix:@"lp"] ||
		[addressFieldText hasSuffix:@"loop"] ||
		[addressFieldText hasSuffix:@"blvd"] ||
		[addressFieldText hasSuffix:@"boulevard"] || 
		[addressFieldText hasSuffix:@"street"] ||
		[addressFieldText hasSuffix:@"dr"] ||
		[addressFieldText hasSuffix:@"drive"] ||
		[addressFieldText hasSuffix:@"ln"] || 
		[addressFieldText hasSuffix:@"lane"] ||
		[addressFieldText hasSuffix:@"rd"] ||
		[addressFieldText hasSuffix:@"road"] ||
		[addressFieldText hasSuffix:@"pl"] || 
		[addressFieldText hasSuffix:@"place"] ||
		[addressFieldText hasSuffix:@"way"]
		) 
	{
		destination = [NSString stringWithFormat:@"%@ %@", addressFieldText, currentCity];
	} else {
		destination = [addressField text];
	}
	
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
	
	NSString *duration = [NSString stringWithFormat:@"%d", seconds / 60];
	NSString *formattedNumberString;
	if ([numberFormatter stringFromNumber:[event kph]]) {
		formattedNumberString = [numberFormatter stringFromNumber:[event kph]];
	} else {
		formattedNumberString = @"0";
	}

	
	NSString *body = [NSString stringWithFormat:@"I am %@ near <a href=\"http://maps.google.com/maps?f=q&source=s_q&hl=en&geocode=&q=%@,%@\">here</a> at %@ kph.\n My ETA is %@ minutes.",
					  travelMethod,
					  [numberFormatter stringFromNumber:[event latitude]],
					  [numberFormatter stringFromNumber:[event longitude]],
					  formattedNumberString,
					  duration];
					 
	[self sendEmailTo:[NSArray arrayWithObject:[emailField text]]
		  withSubject:[NSString stringWithFormat:@"I'll be there in about %@ minutes", duration]
			 withBody:body];
	
	// FIXME: this feature doesn't work
	// currently it opens the maps app before sending off an e-mail
	//open the maps app
	//NSURL *mapsURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://maps.google.com/maps?daddr=%@&saddr=%@", destination, origin]];
	//[[UIApplication sharedApplication] openURL:mapsURL];

}

/* sendEmailTo method thanks to: 
Brandon Trebitowski: http://icodeblog.com/2009/02/20/iphone-programming-tutorial-using-openurl-to-send-email-from-your-app/
Dan Grigsby: http://mobileorchard.com/new-in-iphone-30-tutorial-series-part-2-in-app-email-messageui/
*/

- (void) sendEmailTo:(NSArray *)to withSubject:(NSString *) subject withBody:(NSString *)body {
	
	if ([MFMailComposeViewController canSendMail]) {
		
		MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
		mailViewController.mailComposeDelegate = self;
		[mailViewController setToRecipients:to];
		[mailViewController setSubject:subject];
		// we are sending HTML e-mail becaus
		[mailViewController setMessageBody:body isHTML:YES];
		
		[self presentModalViewController:mailViewController animated:YES];
		[mailViewController release];
		
	}
	
	else {
		
		//FIXME: add alert to end user that they cannot send e-mail
		
	}


}
	

-(void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
	
	[self dismissModalViewControllerAnimated:YES];
	
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


// this delegate is called when the app successfully finds your current location
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation 
{
    // this creates a MKReverseGeocoder to find a placemark using the found coordinates
	// FIXME: figure out the best way to release this as it's currently a memory leak
    MKReverseGeocoder *geoCoder = [[MKReverseGeocoder alloc] initWithCoordinate:newLocation.coordinate];
    geoCoder.delegate = self;
    [geoCoder start];
}

// this delegate is called when the reverseGeocoder finds a placemark
- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark
{
	MKPlacemark *myPlacemark = placemark;
    // with the placemark you can now retrieve the city name
    currentCity = [myPlacemark.addressDictionary objectForKey:(NSString*) kABPersonAddressCityKey];
	
	
	if (!mapInitialized) {
		CLLocation *location = [locationManager location];
		CLLocationCoordinate2D coordinate = [location coordinate];
		//MKCoordinateRegion region;
		MKCoordinateSpan span;
		span.latitudeDelta = .02;
		span.longitudeDelta = .02;
		MKCoordinateRegion region = MKCoordinateRegionMake(coordinate, span);
		//region.center = coordinate;
		[centerMapView setRegion:region animated:TRUE];
		[centerMapView regionThatFits:region];
		centerMapView.showsUserLocation = YES;
		mapInitialized = YES;
	}

	
	
	//[centerMapView setCenterCoordinate:coordinate animated:YES];
}

// this delegate is called when the reversegeocoder fails to find a placemark
- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error
{
    NSLog(@"reverseGeocoder:%@ didFailWithError:%@", geocoder, error);
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
