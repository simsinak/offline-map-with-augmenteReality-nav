//
//  ARViewController.m
//  Shiraz Augmented
//
//  Created by sina askarnejad on 3/25/14.
//  Copyright (c) 2014 sina askarnejad. All rights reserved.
//

#import "ARViewController1.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImage+animatedGIF.h"

@interface ARViewController1 ()

@end

@implementation ARViewController1

@synthesize currentUserLocation,POIs,POIsConvertedToARGeo,RadiusChanged,locations,scaled,viewHiddened,cameraGif,loadingGif,loadingView,loadingViewForDismiss,dismissGif;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setDelegate:self];
    scaled=NO;
    viewHiddened=NO;
//    [self setWantsFullScreenLayout:NO];
    
    // Defaults
    _debugMode                      = NO;
    _scaleViewsBasedOnDistance      = YES;
    _minimumScaleFactor             = 0.5;
    _rotateViewsBasedOnPerspective  = YES;
    _showsRadar                     = YES;
    _radarRange                     = 2000.0;
    _onlyShowItemsWithinRadarRange  = NO;
    
    // Create ARC
    _agController = [[AugmentedRealityController alloc] initWithViewController:self withDelgate:self];
    
    [_agController setShowsRadar:_showsRadar];
    [_agController setRadarRange:_radarRange];
    [_agController setScaleViewsBasedOnDistance:_scaleViewsBasedOnDistance];
    [_agController setMinimumScaleFactor:_minimumScaleFactor];
    [_agController setRotateViewsBasedOnPerspective:_rotateViewsBasedOnPerspective];
    [_agController setOnlyShowItemsWithinRadarRange:_onlyShowItemsWithinRadarRange];
    RadiusChanged=YES;
    _getCamera=YES;

    locations = [[GEOLocations alloc] initWithDelegate:_delegate];
    
    [locations returnLocations];
    CMMotionManager *mManager=[(AppDelegate *)[[UIApplication sharedApplication]delegate] sharedManager];
    cameraGif=[[NSMutableArray alloc]initWithCapacity:105];
    for (int i=1; i<106; i++) {
        [cameraGif addObject:[UIImage imageNamed:[NSString stringWithFormat:@"%d.png",i]]];
    }
    loadingGif=[[NSMutableArray alloc]initWithCapacity:30];
    for (int i=1; i<7; i++) {
        [loadingGif addObject:[UIImage imageNamed:[NSString stringWithFormat:@"loading-new%d.png",i]]];
    }
    dismissGif=[[NSMutableArray alloc]initWithCapacity:30];
    for (int i=1; i<31; i++) {
        [dismissGif addObject:[UIImage imageNamed:[NSString stringWithFormat:@"circular%d.png",i]]];
    }
   /* if ([mManager isAccelerometerAvailable] == YES) {
        [mManager setAccelerometerUpdateInterval:0.1];
        [mManager startAccelerometerUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
            if ( accelerometerData.acceleration.y>-0.7 && accelerometerData.acceleration.y<=0.3 && accelerometerData.acceleration.z<-0.7 && accelerometerData.acceleration.z>-1.1 ) {
                [_agController.radarView scaleItUp];
                [_agController.radarViewPort scaleItUp];
                scaled=YES;
                //*****************************
                if(!viewHiddened){
                    for (NSUInteger i=0; i<_agController.coordinates.count; i++) {
                        ARGeoCoordinate *temp=(ARGeoCoordinate *)[_agController.coordinates objectAtIndex:i];
                        [temp.displayView setAlpha:0];
                     //   [_agController.coordinates replaceObjectAtIndex:i withObject:temp];
                    }
                    viewHiddened=YES;
                }
                //*****************************
            }
            else if(scaled==YES){
                [_agController.radarView scaleItDown];
                [_agController.radarViewPort scaleItDown];
                scaled=NO;
                //*****************************
                if(viewHiddened==YES){
                    for (NSUInteger i=0; i<_agController.coordinates.count; i++) {
                        ARGeoCoordinate *temp=(ARGeoCoordinate *)[_agController.coordinates objectAtIndex:i];
                        [temp.displayView setAlpha:1];
                   //     [_agController.coordinates replaceObjectAtIndex:i withObject:temp];
                    }
                    viewHiddened=NO;
                }
                //*****************************
            }
        }];
    }*/
    

  //      for (ARGeoCoordinate *coordinate in [locations returnLocations]){
     //       ARGeoCoordinateView *cv=[[ARGeoCoordinateView alloc]initWithCoordinate:coordinate type:@"bank" delegate:self];
     //       [coordinate setDisplayView:cv];
       //     [_agController addCoordinate:coordinate];
    
        
//    }
    if ([mManager isAccelerometerAvailable] == YES) {
        [mManager setDeviceMotionUpdateInterval:0.1];
        [mManager startDeviceMotionUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMDeviceMotion *motion, NSError *error) {
            if ( motion.attitude.pitch < 0.8 && motion.attitude.pitch > -0.3 && motion.attitude.roll <0.6 && motion.attitude.roll >-0.7 ) {
                [_agController.radarView scaleItUp];
                [_agController.radarViewPort scaleItUp];
                scaled=YES;
                //*****************************
                if(!viewHiddened){
                    for (NSUInteger i=0; i<_agController.coordinates.count; i++) {
                        ARGeoCoordinate *temp=(ARGeoCoordinate *)[_agController.coordinates objectAtIndex:i];
                        [temp.displayView setAlpha:0];
                        //   [_agController.coordinates replaceObjectAtIndex:i withObject:temp];
                    }
                    viewHiddened=YES;
                }
                //*****************************
            }
            else if(scaled==YES){
                [_agController.radarView scaleItDown];
                [_agController.radarViewPort scaleItDown];
                scaled=NO;
                //*****************************
                if(viewHiddened==YES){
                    for (NSUInteger i=0; i<_agController.coordinates.count; i++) {
                        ARGeoCoordinate *temp=(ARGeoCoordinate *)[_agController.coordinates objectAtIndex:i];
                        [temp.displayView setAlpha:1];
                        //     [_agController.coordinates replaceObjectAtIndex:i withObject:temp];
                    }
                    viewHiddened=NO;
                }
                //*****************************
            }

        }];
    }
    
    [self.view setAutoresizesSubviews:YES];
  }
-(void) didTapMarker:(ARGeoCoordinate *) coordinate{
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) didUpdateHeading:(CLHeading *)newHeading{
    
}
-(void) didUpdateLocation:(CLLocation *)newLocation{
    
}
-(void) didUpdateOrientation:(UIDeviceOrientation) orientation{
    
}
-(NSMutableArray *)geoLocations{
    if (RadiusChanged) {
        [self removePreviousGeos];
        RadiusChanged=NO;
    
        NSUInteger ArraySize =[POIs count];
        POIsConvertedToARGeo=[[NSMutableArray alloc]initWithCapacity:ArraySize];
        for (informations *placeInfos in POIs) {
            //**************************************************update inghesmate:)
            ARGeoCoordinate *newGeo=[ARGeoCoordinate coordinateWithLocation:[placeInfos location] locationTitle:[placeInfos name]];
            [newGeo setSetY:YES];
           // [newGeo calibrateUsingOrigin:currentUserLocation.location];
            //****************************************************
             ARGeoCoordinateView *cv=[[ARGeoCoordinateView alloc]initWithCoordinate:newGeo type:[placeInfos type] delegate:self];
            [newGeo setDisplayView:cv];
            [_agController addCoordinate:newGeo];
            
            [POIsConvertedToARGeo addObject:newGeo];
      //  NSLog(@"return yes");
            [self setShowsRadar:YES];
            // [self setRadarBackgroundColour:[UIColor blackColor]];
            //[self setRadarViewportColour:[UIColor darkGrayColor]];
            [self setRadarPointColour:[UIColor yellowColor]];
            [self setRadarRange:2000.0];
            [self setOnlyShowItemsWithinRadarRange:YES];
            
    }
        NSLog(@"tedad:%lu",(unsigned long)[_agController.coordinates count]);
    }
    return POIsConvertedToARGeo;
}
-(void) locationClicked:(ARGeoCoordinate *) coordinate{
    
}
-(void) requestDatafromController:(ViewController *)controller informations:(NSArray *)inormation fromOrigin:(RMUserLocation *)currentUserLocationInMap{
    POIs=[NSMutableArray arrayWithArray:inormation];
    currentUserLocation=currentUserLocationInMap;
    RadiusChanged=YES;
    NSLog(@"delegates works %lu",(unsigned long)[POIs count]);
}
-(void)viewDidAppear:(BOOL)animated{
    [self shutup];
    _getCamera=NO;
    //*************************************
   // _agController=Nil;
  //  _agController = [[AugmentedRealityController alloc] initWithViewController:self withDelgate:self];
  //  [_agController setShowsRadar:_showsRadar];
  //  [_agController setRadarRange:_radarRange];
//    [_agController setScaleViewsBasedOnDistance:_scaleViewsBasedOnDistance];
//    [_agController setMinimumScaleFactor:_minimumScaleFactor];
  //  [_agController setRotateViewsBasedOnPerspective:_rotateViewsBasedOnPerspective];
 //   [_agController setOnlyShowItemsWithinRadarRange:_onlyShowItemsWithinRadarRange];
 //   RadiusChanged=YES;
    //************************************
}
-(void)shutup{
    if (!_getCamera) {
        [_agController.cameraView removeFromSuperview];
        [_agController refresh];
        [loadingView removeFromSuperview];
    } 
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   if (!_getCamera) {
       loadingView=[[UIView alloc]initWithFrame:[(AppDelegate *)[[UIApplication sharedApplication]delegate] window].bounds];
       [loadingView setBackgroundColor:[UIColor whiteColor]];
       [[(AppDelegate *)[[UIApplication sharedApplication]delegate] window] addSubview:loadingView];
       
       UIImageView *staticGif=[[UIImageView alloc]initWithFrame:CGRectMake(85, 100, 150, 150)];
       [staticGif setImage:[UIImage imageNamed:@"105.png"]];
       [loadingView addSubview:staticGif];
       // loading view gifs...
       UIImageView* animatedImageView = [[UIImageView alloc] initWithFrame:CGRectMake(85, 100, 150, 150)];
       animatedImageView.animationImages = cameraGif;
       animatedImageView.animationDuration = 6.0f;
       // animatedImageView.animationDuration = 2.0f;
       animatedImageView.animationRepeatCount = 1;
       [animatedImageView startAnimating];
       [loadingView addSubview: animatedImageView];
       UIImageView* animatedImageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(60, 350, 200, 200)];
       [animatedImageView1 setAnimationImages:loadingGif];
       animatedImageView1.animationDuration = 1.5f;
       animatedImageView1.animationRepeatCount = 0;
       [animatedImageView1 startAnimating];
       [loadingView addSubview: animatedImageView1];
   }
    [self geoLocations];
}
-(void)removePreviousGeos{
   
    [_agController removeCoordinates:POIsConvertedToARGeo];
    [POIsConvertedToARGeo removeAllObjects];
}
-(void)GeoCoordinateViewTouched:(ARGeoCoordinateView *)geoView{
    CLLocation *myLocation=[[geoView geoCoordinate]geoLocation];
    NSUInteger Arrayindex=[POIs indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        informations *temp=(informations *)obj;
        return [temp.location isEqual:myLocation];
    }];
    if (Arrayindex!=NSNotFound) {
        informations *selected=[POIs objectAtIndex:Arrayindex];
        [[POI getPOI]loadAdditionsalInfoForLocation:selected haveanswer:^(NSDictionary *param) {
            NSLog(@"response:%@", param);
            NSDictionary *AdditionalInfo=[param objectForKey:@"result"];
            [selected setAddress:[AdditionalInfo objectForKey:@"formatted_address"]];
            [selected setPhone:[AdditionalInfo objectForKey:@"formatted_phone_number"]];
            [selected setPhotoRefrence:[(NSDictionary *)[(NSArray *)[AdditionalInfo valueForKey:@"photos"]objectAtIndex:0]valueForKey:@"photo_reference"]];
            [selected setWebsite:[AdditionalInfo objectForKey:@"website"]];
            [self popupViewForPlace:selected];
        } haveError:^(NSError *param) {
            //
        }//error
    ];
}
}
-(void)popupViewForPlace:(informations *)infoParam{
    CGRect frame=[[self view]frame];
    UIView *info=[[UIView alloc]initWithFrame:CGRectMake(50.0f, 50.0f, frame.size.width - 100.0f, frame.size.height - 150.0f)];
    [info setBackgroundColor:[UIColor whiteColor]];
    [info.layer setCornerRadius:10.0];
    
    //UITextView *info=[[UITextView alloc]initWithFrame:CGRectMake(50.0f, 50.0f, frame.size.width - 100.0f, frame.size.height - 100.0f)];
    [info setCenter:[[self view] center]];
    UIView *TopImageView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, info.frame.size.width , 45)];
   // [TopImageView setImage:[UIImage imageNamed:@"orange-frame"]];
    [TopImageView setBackgroundColor:[UIColor lightGrayColor]];
    [info addSubview:TopImageView];
    UIBezierPath *maskpath=[UIBezierPath bezierPathWithRoundedRect:TopImageView.bounds byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight) cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *masklayer=[[CAShapeLayer alloc]init];
    masklayer.frame=info.bounds;
    masklayer.path=maskpath.CGPath;
    TopImageView.layer.mask=masklayer;
    UILabel *mytitle=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, info.bounds.size.width-50, 40)];
    [info addSubview:mytitle];
    [mytitle setText:[infoParam name]];
    [mytitle setTextColor:[UIColor darkGrayColor]];
    [mytitle setAdjustsFontSizeToFitWidth:YES];
    UIImageView *myimage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"info-icon.png"]];
    myimage.alpha=0.8;
    myimage.frame=CGRectMake(info.bounds.size.width-40, 7, 30, 30);
    [info addSubview:myimage];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 45, info.bounds.size.width, 2)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [info addSubview:lineView];
    
    if (infoParam.photoRefrence!=nil) {
        [[POI getPOI]loadImageForLocation:infoParam haveanswer:^(UIImage *param) {
            UIImageView *myPlaceimage=[[UIImageView alloc]initWithImage:param];
            myPlaceimage.backgroundColor=[UIColor blackColor];
            myPlaceimage.frame=CGRectMake(0, 47, info.bounds.size.width, 120);
            [info addSubview:myPlaceimage];
            
        } haveError:^(NSError *param) {
            //
        }];

    }
    else{
        UIImageView *myPlaceimage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"no-photo"]];
        myPlaceimage.backgroundColor=[UIColor blackColor];
        myPlaceimage.frame=CGRectMake(0, 47, info.bounds.size.width, 120);
        [info addSubview:myPlaceimage];
    }
    
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 167, info.bounds.size.width, 2)];
    lineView2.backgroundColor = [UIColor lightGrayColor];
    [info addSubview:lineView2];
    
    UILabel *address=[[UILabel alloc]initWithFrame:CGRectMake(10, 169, info.bounds.size.width-20, 60)];
    [address setLineBreakMode:NSLineBreakByWordWrapping];
    address.numberOfLines=0;
    if ([infoParam address]!=nil) {
        address.text=[NSString stringWithFormat:@"Address: %@" , [infoParam address]];
    }
    else{
         address.text=@"Address: Not Available";
    }
   
    address.font=[UIFont fontWithName:@"Helvetica" size:15.0];
    [address setTextColor:[UIColor darkTextColor]];
    [address setTextAlignment:NSTextAlignmentJustified];
    [info addSubview:address];
    
    UIView *lineView3 = [[UIView alloc] initWithFrame:CGRectMake(0, 229, info.bounds.size.width, 2)];
    lineView3.backgroundColor = [UIColor lightGrayColor];
    [info addSubview:lineView3];
    
    
    if ([infoParam phone]!=nil) {
        UIButton *calling = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [calling addTarget:self action:@selector(callToPOI:) forControlEvents:UIControlEventTouchUpInside];
        [calling setTitle:[NSString stringWithFormat:@"Phone: %@" , [infoParam phone]] forState:UIControlStateNormal];
        [calling setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [calling setContentEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 10)];
        calling.frame = CGRectMake(0, 231, info.bounds.size.width, 60);
        [info addSubview:calling];

    }
    else{
    UILabel *phone=[[UILabel alloc]initWithFrame:CGRectMake(10, 231, info.bounds.size.width-20, 60)];
    phone.text=@"Phone: Not Available";
    [phone setTextColor:[UIColor darkTextColor]];
  //  [phone setTextAlignment:NSTextAlignmentLeft];
    [info addSubview:phone];
    [phone setFont:[UIFont fontWithName:@"Helvetica" size:15.0]];
    }
 
    UIView *lineView4 = [[UIView alloc] initWithFrame:CGRectMake(0, 291, info.bounds.size.width, 2)];
    lineView4.backgroundColor = [UIColor lightGrayColor];
    [info addSubview:lineView4];
    
    if ([infoParam website]!=nil) {
        UIButton *visiting = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [visiting addTarget:self action:@selector(visitPOI:) forControlEvents:UIControlEventTouchUpInside];
        [visiting setTitle:[NSString stringWithFormat:@"Web: %@" , [infoParam website]] forState:UIControlStateNormal];
        [visiting setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [visiting setContentEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 10)];
        visiting.frame = CGRectMake(0, 293, info.bounds.size.width, 60);
        [info addSubview:visiting];
        
    }
    else{
        UILabel *visitWeb=[[UILabel alloc]initWithFrame:CGRectMake(10, 291, info.bounds.size.width-20, 60)];
        visitWeb.text=@"Web: Not Available";
        [visitWeb setTextColor:[UIColor darkTextColor]];
        [info addSubview:visitWeb];
        [visitWeb setFont:[UIFont fontWithName:@"Helvetica" size:15.0]];
    }
    
	[info setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    //[info setText:[infoParam infoText]];
    [info setTag:105];
    //[info setEditable:NO];
    [[self view]addSubview:info];
}
-(void)callToPOI:(UIButton *)Param{
    NSString *phone=[NSString stringWithFormat:@"tel://%@",[[Param currentTitle] substringFromIndex:7]];
    NSArray *words=[phone componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    phone=[words componentsJoinedByString:@""];
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:phone]];
}
-(void)visitPOI:(UIButton *)param{
    NSString *web=[[param currentTitle] substringFromIndex:5];
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:web]];
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    UIView *info=[[self view] viewWithTag:105];
    [info removeFromSuperview];
}
- (void)setDebugMode:(BOOL)debugMode{
    _debugMode = debugMode;
    [_agController setDebugMode:_debugMode];
}

- (void)setShowsRadar:(BOOL)showsRadar{
    _showsRadar = showsRadar;
    [_agController setShowsRadar:_showsRadar];
}

- (void)setScaleViewsBasedOnDistance:(BOOL)scaleViewsBasedOnDistance{
    _scaleViewsBasedOnDistance = scaleViewsBasedOnDistance;
    [_agController setScaleViewsBasedOnDistance:_scaleViewsBasedOnDistance];
}

- (void)setMinimumScaleFactor:(float)minimumScaleFactor{
    _minimumScaleFactor = minimumScaleFactor;
    [_agController setMinimumScaleFactor:_minimumScaleFactor];
}

- (void)setRotateViewsBasedOnPerspective:(BOOL)rotateViewsBasedOnPerspective{
    _rotateViewsBasedOnPerspective = rotateViewsBasedOnPerspective;
    [_agController setRotateViewsBasedOnPerspective:_rotateViewsBasedOnPerspective];
}

- (void)setRadarPointColour:(UIColor *)radarPointColour{
    _radarPointColour = radarPointColour;
    [_agController.radarView setPointColour:_radarPointColour];
}

- (void)setRadarBackgroundColour:(UIColor *)radarBackgroundColour{
    _radarBackgroundColour = radarBackgroundColour;
    [_agController.radarView setRadarBackgroundColour:_radarBackgroundColour];
}

- (void)setRadarViewportColour:(UIColor *)radarViewportColour{
    _radarViewportColour = radarViewportColour;
    [_agController.radarViewPort setViewportColour:_radarViewportColour];
}

- (void)setRadarRange:(float)radarRange{
    _radarRange = radarRange;
    [_agController setRadarRange:_radarRange];
}

- (void)setOnlyShowItemsWithinRadarRange:(BOOL)onlyShowItemsWithinRadarRange{
    _onlyShowItemsWithinRadarRange = onlyShowItemsWithinRadarRange;
    [_agController setOnlyShowItemsWithinRadarRange:_onlyShowItemsWithinRadarRange];
}
//***************************************
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    loadingViewForDismiss=[[UIView alloc]initWithFrame:[(AppDelegate *)[[UIApplication sharedApplication]delegate] window].bounds];
    [loadingViewForDismiss setBackgroundColor:[UIColor whiteColor]];
    //*************************************
    UIImageView* animatedImageView = [[UIImageView alloc] initWithFrame:CGRectMake(85, 100, 150, 150)];
    animatedImageView.animationImages = dismissGif;
    animatedImageView.animationDuration = 2.0f;
    animatedImageView.animationRepeatCount = 0;
    [animatedImageView startAnimating];
    [loadingViewForDismiss addSubview: animatedImageView];
    UIImageView* animatedImageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(60, 350, 200, 200)];
    [animatedImageView1 setAnimationImages:loadingGif];
    animatedImageView1.animationDuration = 1.5f;
    animatedImageView1.animationRepeatCount = 0;
    [animatedImageView1 startAnimating];
    [loadingViewForDismiss addSubview: animatedImageView1];
    //*************************************
    [[(AppDelegate *)[[UIApplication sharedApplication]delegate] window] addSubview:loadingViewForDismiss];
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [(AppDelegate *)[[UIApplication sharedApplication]delegate] refresh];
    [self performSelector:@selector(gohaway) withObject:Nil afterDelay:1.0f];
   // [loadingViewForDismiss removeFromSuperview];
}
//**************************************
-(void)gohaway{
    [loadingViewForDismiss removeFromSuperview];
}
@end
