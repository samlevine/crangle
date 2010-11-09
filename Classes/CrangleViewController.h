//
//  CrangleViewController.h
//  Crangle
//
//  Created by Samuel Levine on 11/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CrangleViewController : UIViewController {
	IBOutlet UISegmentedControl *destinationControl;
	IBOutlet UIBarButtonItem *sendButton;
	IBOutlet UITextField *addressField;
	IBOutlet UITextField *emailField;

}

@property (nonatomic, retain) IBOutlet UISegmentedControl *destinationControl;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *sendButton;
@property (nonatomic, retain) IBOutlet UITextField *addressField;
@property (nonatomic, retain) IBOutlet UITextField *emailField;

-(IBAction) sendButtonClicked: (id) sender;
- (void) sendEmailTo:(NSString *)to withSubject:(NSString *) subject withBody:(NSString *)body;
- (BOOL)textFieldShouldReturn:(UITextField *)textField;

@end

