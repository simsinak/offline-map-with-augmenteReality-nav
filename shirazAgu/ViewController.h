//
//  ViewController.h
//  Shiraz Augmented
//
//  Created by sina askarnejad on 3/11/14.
//  Copyright (c) 2014 sina askarnejad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Mapbox/Mapbox.h>
#import <CoreLocation/CoreLocation.h>
#import "informations.h"
#import "POI.h"
#import "annotations.h"
#import "PageContentViewController.h"

@class ViewController;
@protocol ViewControllerDataDelegate <NSObject>

-(void) requestDatafromController:(ViewController *)controller informations:(NSArray *)inormation fromOrigin:(RMUserLocation *)currentUserLocationInMap;

@end
@interface ViewController : UIViewController <CLLocationManagerDelegate,UIAlertViewDelegate , RMMapViewDelegate ,UIPageViewControllerDataSource>
@property (nonatomic , strong) RMMapView *shirazMap;
@property (nonatomic , strong) CLLocationManager *locationManager;
@property (nonatomic , strong) CLLocation *currentLocation;
@property (nonatomic , strong) UIButton *around;
@property (nonatomic , strong) UIButton *info;
@property (nonatomic , strong) UIDynamicAnimator *myanimator;
@property (nonatomic , strong) UICollisionBehavior *mycol;
@property (nonatomic , strong) UISnapBehavior *mysnap;
@property (nonatomic , strong) UISnapBehavior *mysnap2;
@property (nonatomic , strong) UIButton *updateCurrentLocation;
@property (nonatomic , strong) NSMutableArray *POIPINS;
@property (nonatomic , strong) id<ViewControllerDataDelegate> delegate;
@property (nonatomic , strong) NSMutableArray *annotationsArray;
@property (nonatomic , strong)UIPageViewController *TutorialPage;
@property (nonatomic , strong)NSArray *images;
@property (nonatomic , strong)NSArray *texts;
@property BOOL showmaps;
@property BOOL ItsNotFirstTimeTrigerRound;
@end

