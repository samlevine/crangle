//
//  CrangleViewController.m
//  Crangle
//
//  Created by Samuel Levine on 11/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CrangleViewController.h"

@implementation CrangleViewController

@synthesize destinationControl, sendButton, addressField, emailField;

- (void)sendButtonClicked: (id)sender {

	NSLog(@"address: %@, e-mail: %@, transportation: %@", 
		  [addressField text],
		  [emailField text],
		  [destinationControl titleForSegmentAtIndex:[destinationControl selectedSegmentIndex]]);
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


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

@end
