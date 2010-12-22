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
@interface PinPointAnnotation : MKPointAnnotation {
	CLLocationCoordinate2D coordinate;
}

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;


@end
