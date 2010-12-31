//
//  CrangleViewController.h
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

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "CrangleAppDelegate.h"
#import "JSON.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <MapKit/MKReverseGeocoder.h>
#import <MapKit/MapKit.h>
#import "PinPointAnnotation.h"


@interface CrangleViewController : UIViewController < CLLocationManagerDelegate,
													  ABPeoplePickerNavigationControllerDelegate,
													  MFMailComposeViewControllerDelegate,
													  MKReverseGeocoderDelegate,
													  UIGestureRecognizerDelegate,
													  MKMapViewDelegate,
													  UITextFieldDelegate>
{
	IBOutlet UISegmentedControl *destinationControl;
	IBOutlet UIBarButtonItem *sendButton;
	IBOutlet UITextField *addressField;
	IBOutlet UITextField *emailField;
	IBOutlet MKMapView *centerMapView;
	UIButton *contactsButton;
	
	// location related items
	NSMutableArray *eventsArray;
	NSManagedObjectContext *managedObjectContext;	    
    CLLocationManager *locationManager;
	NSString *currentCity;
	BOOL mapInitialized;
	//PinPointAnnotation *pinAnnotation;
}

@property (nonatomic, retain) IBOutlet UISegmentedControl *destinationControl;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *sendButton;
@property (nonatomic, retain) IBOutlet UITextField *addressField;
@property (nonatomic, retain) IBOutlet UITextField *emailField;
@property (nonatomic, retain) IBOutlet MKMapView *centerMapView;
@property (nonatomic, retain) UIButton *contactsButton;

// for using core data later
@property (nonatomic, retain) NSMutableArray *eventsArray;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) NSString *currentCity;
@property (nonatomic) BOOL mapInitialized;
//@property (nonatomic, retain) PinPointAnnotation *pinAnnotation;


-(IBAction) sendButtonClicked: (id) sender;
-(IBAction) directionButtonClicked: (id) sender;
- (void) sendEmailTo:(NSArray *)to withSubject:(NSString *) subject withBody:(NSString *)body;
- (BOOL)textFieldShouldReturn:(UITextField *)textField;

// for core data model
- (void)addEvent;

//people picker stuff
-(IBAction)showPeoplePickerController;

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch;
- (void)addCoordinateAsPin:(CLLocationCoordinate2D) mapCoordinate
		   annotationTitle:(NSString *)annotationTitle annotationSubtitle:(NSString *) annotationSubtitle;

- (NSString *)cleanAddressForSearch:(NSString *)inputAddress;
- (NSString *)getCurrentOrigin;

@end

