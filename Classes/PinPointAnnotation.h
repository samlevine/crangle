//
//  PinPointAnnotationView.h
//  Crangle
//
//  Created by Samuel Levine on 12/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

//@class PinPointAnnotation;
@interface PinPointAnnotation : MKPointAnnotation <MKAnnotation>{
	CLLocationCoordinate2D coordinate;
	NSString *title;
	NSString *subtitle;
}

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *subtitle;

@end
