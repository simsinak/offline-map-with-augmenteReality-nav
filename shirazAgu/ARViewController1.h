//
//  ARViewController.h
//  Shiraz Augmented
//
//  Created by sina askarnejad on 3/25/14.
//  Copyright (c) 2014 sina askarnejad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ARKit.h"
#import "ARLocationDelegate.h"
#import "ARViewProtocol.h"
#import <Mapbox/Mapbox.h>
#import "informations.h"
#import "ViewController.h"
#import "ARGeoCoordinateView.h"
#import "POI.h"
#import "AugmentedRealityController.h"
#import "GEOLocations.h"
#import "ARGeoCoordinateView.h"
@class AugmentedRealityController;

@interface ARViewController1 : UIViewController <ViewControllerDataDelegate,ARGeoCoordinateViewDelegate,ARLocationDelegate,ARMarkerDelegate,ARDelegate>
@property (nonatomic , strong) RMUserLocation *currentUserLocation;
//for showing camera:p
@property (nonatomic , strong) AugmentedRealityController *agController;
@property (nonatomic , strong) ARViewController1 *myArViewController;
@property (nonatomic , strong) NSMutableArray *POIs;
@property (nonatomic , strong) NSMutableArray *POIsConvertedToARGeo;
@property  BOOL RadiusChanged;
@property (assign, nonatomic, setter = setDebugMode:)                       BOOL debugMode;
@property (assign, nonatomic, setter = setShowsRadar:)                      BOOL showsRadar;
@property (assign, nonatomic, setter = setScaleViewsBasedOnDistance:)       BOOL scaleViewsBasedOnDistance;
@property (assign, nonatomic, setter = setMinimumScaleFactor:)              float minimumScaleFactor;
@property (assign, nonatomic, setter = setRotateViewsBasedOnPerspective:)   BOOL rotateViewsBasedOnPerspective;
@property (strong, nonatomic, setter = setRadarPointColour:)                UIColor *radarPointColour;
@property (strong, nonatomic, setter = setRadarBackgroundColour:)           UIColor *radarBackgroundColour;
@property (strong, nonatomic, setter = setRadarViewportColour:)             UIColor *radarViewportColour;
@property (assign, nonatomic, setter = setRadarRange:)                      float radarRange;
@property (assign, nonatomic, setter = setOnlyShowItemsWithinRadarRange:)   BOOL onlyShowItemsWithinRadarRange;
@property (nonatomic, assign) id<ARLocationDelegate> delegate;
@property (nonatomic , strong)GEOLocations *locations;
@property BOOL scaled;
@property BOOL viewHiddened;
@property BOOL getCamera;
@property(nonatomic , strong)UIView *loadingView;
@property (nonatomic , strong)UIView *loadingViewForDismiss;
@property(nonatomic , strong)NSMutableArray *cameraGif;
@property(nonatomic , strong)NSMutableArray *loadingGif;
@property(nonatomic , strong)NSMutableArray *dismissGif;

-(void)popupViewForPlace:(informations *)infoParam;
@end
