//
//  ViewController.m
//  Shiraz Augmented
//
//  Created by sina askarnejad on 3/11/14.
//  Copyright (c) 2014 sina askarnejad. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
NSString * const kLatitudeKeypath = @"geometry.location.lat";
@interface ViewController ()
//@property BOOL firstzoom;
@end

@implementation ViewController
@synthesize shirazMap,locationManager,currentLocation,around,info,myanimator,mycol,mysnap,mysnap2,updateCurrentLocation,POIPINS , annotationsArray,showmaps,ItsNotFirstTimeTrigerRound;
- (void)viewDidLoad
{
    [super viewDidLoad];
    RMMBTilesSource *content=[[RMMBTilesSource alloc]initWithTileSetResource:@"iran-shiraz-1"];
    shirazMap =[[RMMapView alloc]initWithFrame:self.view.bounds andTilesource:content];
    shirazMap.zoom=2;
    shirazMap.delegate=self;
    self.delegate=[self.tabBarController.viewControllers objectAtIndex:1];
    shirazMap.autoresizingMask=UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:shirazMap];
    shirazMap.showsUserLocation=YES;
    showmaps=YES;
    //ItsNotFirstTimeTrigerRound=NO;
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    
    if ([defaults boolForKey:@"show_intro_pref"]) {
        showmaps=NO;
    }
    annotationsArray=[NSMutableArray array];
  //  _firstzoom=NO;
    [self CreateSateliteButton];
    [self configLocationManager];
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)configLocationManager{
    if (!locationManager) {
        locationManager=[[CLLocationManager alloc]init];
        locationManager.delegate=self;
        [locationManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
    }
   // locationManager=[[CLLocationManager alloc]init];
  //  locationManager.delegate=self;
    updateCurrentLocation.enabled=NO;
    [locationManager startUpdatingLocation];
}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
   // CLLocation *currentLocation=[locations lastObject];
    currentLocation=[locations lastObject];
    CLLocationAccuracy accuracy=[currentLocation horizontalAccuracy];
       if (accuracy<500 && showmaps) {
       // static dispatch_once_t onceToken;
      //  dispatch_once(&onceToken, ^{
            [shirazMap setZoom:17];
            shirazMap.userTrackingMode=RMUserTrackingModeFollow;
            //show a button for user location on map...:)
       // });
           if (showmaps) {
               [self CreateInfoButton];
               [manager stopUpdatingLocation];
               updateCurrentLocation.enabled=YES;
           }
       // [self infoButtonPressed];
    }
   
}

-(void)infoButtonPressed:(int)param{

    [[POI getPOI]loadPOIInLocation:currentLocation ForRadius:param haveAnswer:^(NSDictionary *param) {
        NSLog(@"respose=%@",param);

        if ([[param objectForKey:@"status"] isEqualToString:@"OK"]) {
            if (annotationsArray.count) {
                [shirazMap removeAnnotations:annotationsArray];
                [annotationsArray removeAllObjects];
                NSLog(@"annotation %lu",(unsigned long)[annotationsArray count]);
               // annotationsArray=nil;
                //NSLog(@"annotation %lu",(unsigned long)[annotationsArray count]);
            }
            if (!annotationsArray.count){
                id results=[param objectForKey:@"results"];
                NSMutableArray *T_copy=[NSMutableArray array];
                if ([results isKindOfClass:[NSArray class]]) {
                    for (NSDictionary *placeInformations in results) {
                        // NSLog(@"chi mige:%@",[placeInformations valueForKeyPath:kLatitudeKeypath]);
                        informations *new=[[informations alloc]init];
                        new.location=[[CLLocation alloc]initWithLatitude:[[placeInformations valueForKeyPath:@"geometry.location.lat"]floatValue] longitude:[[placeInformations valueForKeyPath:@"geometry.location.lng"]floatValue]];

                        new.name=[placeInformations valueForKey:@"name"];
                        new.type=[[NSArray arrayWithArray:[placeInformations valueForKey:@"types"]]objectAtIndex:0];
                        new.vicinity=[placeInformations valueForKey:@"vicinity"];
                        new.reference=[placeInformations valueForKey:@"reference"];
                       // new.photoRefrence=[(NSDictionary *)[(NSArray *)[placeInformations valueForKey:@"photos"]objectAtIndex:0]valueForKey:@"photo_reference"];
                        [T_copy addObject:new];
                        annotations *pin=[[annotations alloc]initWithMapView:shirazMap information:new];
                        [annotationsArray addObject:pin];
                        [shirazMap addAnnotation:pin];
                    
                        //   NSLog(@"shit");
                    }
                
                }
                POIPINS=[T_copy copy];
                 NSLog(@"annotationzzz %lu",(unsigned long)[annotationsArray count]);
                [self.delegate requestDatafromController:self informations:POIPINS fromOrigin:[shirazMap userLocation]];
            }
            
        }//ok
        
    } haveError:^(NSError *param) {
        //code
    }];
    }
-(void)CreateInfoButton{
    if(mysnap2 !=nil){
        [myanimator removeBehavior:mysnap2];
        
    }
    mysnap2=[[UISnapBehavior alloc]initWithItem:info snapToPoint:CGPointMake(159.0, 488.0)];
    mysnap2.damping=0.5f;
    [myanimator addBehavior:mysnap2];
    if(mysnap !=nil){
        [myanimator removeBehavior:mysnap];
        
    }
    mysnap=[[UISnapBehavior alloc]initWithItem:around snapToPoint:CGPointMake(159.0, 488.0)];
    mysnap.damping=0.5f;
    [myanimator addBehavior:mysnap];
   //**
    CABasicAnimation *halfTurn;
    halfTurn = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    halfTurn.fromValue = [NSNumber numberWithFloat:0];
    halfTurn.toValue = [NSNumber numberWithFloat:((360*M_PI)/180)];
    halfTurn.duration = 0.5;
    halfTurn.repeatCount = HUGE_VALF;
    [[around layer] addAnimation:halfTurn forKey:@"circle"];
   //**
}
-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:YES];
    //**********************
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    if ([defaults boolForKey:@"show_intro_pref"]) {
        
    _images = @[@"page1",@"page2",@"page3",@"page4",@"page5"];
    _texts=@[@"Offline Shiraz Map",@"Using Augmented reality for POI",@"Having radar!...",@"playing video in famous Places"];
    _TutorialPage=[[UIPageViewController alloc]initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:Nil];
    PageContentViewController *defaultContent=[self contentPageAtIndex:0];
    _TutorialPage.dataSource=self;
    NSArray *views=@[defaultContent];
    [_TutorialPage setViewControllers:views direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    
    _TutorialPage.view.frame=[(AppDelegate *)[[UIApplication sharedApplication]delegate] window].frame;
    [_TutorialPage.view setBackgroundColor:[UIColor blackColor]];
    [[(AppDelegate *)[[UIApplication sharedApplication]delegate] window] addSubview:_TutorialPage.view];
    }
    //***********************
    info = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //[info addTarget:self action:@selector(InfoButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [info setBackgroundImage:[UIImage imageNamed:@"info-green"] forState:UIControlStateNormal];
    info.frame = CGRectMake(-60, 460.0, 55.0, 55.0);
    [self.view addSubview:info];
    
    around = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [around addTarget:self action:@selector(PopUpView) forControlEvents:UIControlEventTouchUpInside];
    [around addTarget:self action:@selector(changeColorToRed) forControlEvents:UIControlEventTouchDown];
    [around addTarget:self action:@selector(changeColorToGreen) forControlEvents:UIControlEventTouchUpOutside];
    [around setBackgroundImage:[UIImage imageNamed:@"around-green"] forState:UIControlStateNormal];
   // [around setBackgroundImage:[UIImage imageNamed:@"around-red"] forState:UIControlStateHighlighted];

    around.frame = CGRectMake(400, 460.0, 55.0, 55.0);
    //around.center=info.center;
    [self.view addSubview:around];
    
    myanimator=[[UIDynamicAnimator alloc]initWithReferenceView:self.view];
    mysnap=[[UISnapBehavior alloc]initWithItem:around snapToPoint:around.center];
    [myanimator addBehavior:mysnap];
    mysnap2=[[UISnapBehavior alloc]initWithItem:info snapToPoint:info.center];
    [myanimator addBehavior:mysnap2];
 //   mycol=[[UICollisionBehavior alloc]initWithItems:@[around]];
 //   [myanimator addBehavior:mycol];
   
    if (ItsNotFirstTimeTrigerRound) {
        [self CreateInfoButton];
    }
    ItsNotFirstTimeTrigerRound=YES;
}
-(void)changeColorToRed{
    [info setBackgroundImage:[UIImage imageNamed:@"info-red"] forState:UIControlStateNormal];
    [around setBackgroundImage:[UIImage imageNamed:@"around-red"] forState:UIControlStateNormal];

}
-(void)changeColorToGreen{
    [info setBackgroundImage:[UIImage imageNamed:@"info-green"] forState:UIControlStateNormal];
    [around setBackgroundImage:[UIImage imageNamed:@"around-green"] forState:UIControlStateNormal];
}

-(void)PopUpView{
    [info setBackgroundImage:[UIImage imageNamed:@"info-red"] forState:UIControlStateNormal];
    [around setBackgroundImage:[UIImage imageNamed:@"around-red"] forState:UIControlStateNormal];
    UIAlertView *popup=[[UIAlertView alloc]initWithTitle:nil message:@"please enter a radius for search" delegate:self cancelButtonTitle:@"dissmiss" otherButtonTitles:@"ok", nil];
    UIImageView *tester=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"radius"]];
    [popup setValue:tester forKey:@"accessoryView"];
    popup.alertViewStyle=UIAlertViewStylePlainTextInput;
    UITextField *text=[popup textFieldAtIndex:0];
    text.keyboardType=UIKeyboardTypeNumberPad;
    [popup show];
        
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1 && [alertView textFieldAtIndex:0].text!=nil) {
        [self infoButtonPressed:[[alertView textFieldAtIndex:0].text intValue]];
        [info setBackgroundImage:[UIImage imageNamed:@"info-green"] forState:UIControlStateNormal];
        [around setBackgroundImage:[UIImage imageNamed:@"around-green"] forState:UIControlStateNormal];
    }
    else{
        [info setBackgroundImage:[UIImage imageNamed:@"info-green"] forState:UIControlStateNormal];
        [around setBackgroundImage:[UIImage imageNamed:@"around-green"] forState:UIControlStateNormal];
    }
}
-(void)CreateSateliteButton{
    updateCurrentLocation = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [updateCurrentLocation addTarget:self action:@selector(configLocationManager) forControlEvents:UIControlEventTouchUpInside];
    [updateCurrentLocation setBackgroundImage:[UIImage imageNamed:@"Satelite"] forState:UIControlStateNormal];
    updateCurrentLocation.frame=CGRectMake(270, 30, 30, 30);
    [self.view addSubview:updateCurrentLocation];
    updateCurrentLocation.enabled=NO;
}
- (RMMapLayer *)mapView:(RMMapView *)mapView layerForAnnotation:(RMAnnotation *)annotation{
    if (annotation.isUserLocationAnnotation) {
        return nil;
   }
    annotations *test=(annotations *)annotation;
    NSString *type=test.myInfo.type;
    RMMarker *marker;
    if ([type isEqualToString:@"amusement_park"]) {
        marker=[[RMMarker alloc]initWithMapboxMarkerImage:@"playground" tintColor:[UIColor greenColor]];
    } else if([type isEqualToString:@"art_gallery"]){
         marker=[[RMMarker alloc]initWithMapboxMarkerImage:@"art-gallery" tintColor:[UIColor yellowColor]];
    }else if([type isEqualToString:@"atm"]||[type isEqualToString:@"finance"]){
        marker=[[RMMarker alloc]initWithMapboxMarkerImage:@"bank" tintColor:[UIColor redColor]];
    }else if([type isEqualToString:@"beauty_salon"]){
        marker=[[RMMarker alloc]initWithMapboxMarkerImage:@"hairdresser" tintColor:[UIColor brownColor]];
    }else if([type isEqualToString:@"bicycle_store"]){
        marker=[[RMMarker alloc]initWithMapboxMarkerImage:@"bicycle" tintColor:[UIColor brownColor]];
    }else if([type isEqualToString:@"bus_station"]){
        marker=[[RMMarker alloc]initWithMapboxMarkerImage:@"bus" tintColor:[UIColor redColor]];
    }else if([type isEqualToString:@"campground"]){
        marker=[[RMMarker alloc]initWithMapboxMarkerImage:@"campsite" tintColor:[UIColor greenColor]];
    }else if([type isEqualToString:@"car_dealer"]||[type isEqualToString:@"car_rental"]||[type isEqualToString:@"car_repair"]||[type isEqualToString:@"car_wash"]){
        marker=[[RMMarker alloc]initWithMapboxMarkerImage:@"car" tintColor:[UIColor brownColor]];
    }else if([type isEqualToString:@"church"]){
        marker=[[RMMarker alloc]initWithMapboxMarkerImage:@"religious-christian" tintColor:[UIColor magentaColor]];
    }else if([type isEqualToString:@"city_hall"]){
        marker=[[RMMarker alloc]initWithMapboxMarkerImage:@"town-hall" tintColor:[UIColor redColor]];
    }else if([type isEqualToString:@"clothing_store"]){
        marker=[[RMMarker alloc]initWithMapboxMarkerImage:@"clothing-store" tintColor:[UIColor brownColor]];
    }else if([type isEqualToString:@"fire_station"]){
        marker=[[RMMarker alloc]initWithMapboxMarkerImage:@"fire-station" tintColor:[UIColor redColor]];
    }else if([type isEqualToString:@"florist"]){
        marker=[[RMMarker alloc]initWithMapboxMarkerImage:@"garden" tintColor:[UIColor greenColor]];
    }else if([type isEqualToString:@"food"]){
        marker=[[RMMarker alloc]initWithMapboxMarkerImage:@"fast-food" tintColor:[UIColor brownColor]];
    }else if([type isEqualToString:@"funeral_home"]){
       marker=[[RMMarker alloc]initWithMapboxMarkerImage:@"cemetery" tintColor:[UIColor blackColor]];
    }else if([type isEqualToString:@"gas_station"]){
        marker=[[RMMarker alloc]initWithMapboxMarkerImage:@"fuel" tintColor:[UIColor redColor]];
    }else if([type isEqualToString:@"grocery_or_supermarket"]){
        marker=[[RMMarker alloc]initWithMapboxMarkerImage:@"grocery" tintColor:[UIColor brownColor]];
    }else if([type isEqualToString:@"health"]){
        marker=[[RMMarker alloc]initWithMapboxMarkerImage:@"hospital" tintColor:[UIColor redColor]];
    }else if([type isEqualToString:@"liquor_store"]){
        marker=[[RMMarker alloc]initWithMapboxMarkerImage:@"alcohol-shop" tintColor:[UIColor brownColor]];
    }else if([type isEqualToString:@"mosque"]||[type isEqualToString:@"place_of_worship"]){
        marker=[[RMMarker alloc]initWithMapboxMarkerImage:@"place-of-worship" tintColor:[UIColor magentaColor]];
    }else if([type isEqualToString:@"movie_rental"]||[type isEqualToString:@"movie_theater"]||[type isEqualToString:@"moving_company"]){
        marker=[[RMMarker alloc]initWithMapboxMarkerImage:@"cinema" tintColor:[UIColor yellowColor]];
    }else if([type isEqualToString:@"pet_store"]){
        marker=[[RMMarker alloc]initWithMapboxMarkerImage:@"dog-park" tintColor:[UIColor greenColor]];
    }else if([type isEqualToString:@"post_office"]){
        marker=[[RMMarker alloc]initWithMapboxMarkerImage:@"post" tintColor:[UIColor redColor]];
    }else if([type isEqualToString:@"spa"]){
        marker=[[RMMarker alloc]initWithMapboxMarkerImage:@"water" tintColor:[UIColor blueColor]];
    }else if([type isEqualToString:@"storage"]){
        marker=[[RMMarker alloc]initWithMapboxMarkerImage:@"warehouse" tintColor:[UIColor magentaColor]];
    }else if([type isEqualToString:@"subway_station"]){
        marker=[[RMMarker alloc]initWithMapboxMarkerImage:@"rail-metro" tintColor:[UIColor redColor]];
    }else if([type isEqualToString:@"synagogue"]){
        marker=[[RMMarker alloc]initWithMapboxMarkerImage:@"religious-jewish" tintColor:[UIColor magentaColor]];
    }else if([type isEqualToString:@"train_station"]){
        marker=[[RMMarker alloc]initWithMapboxMarkerImage:@"rail" tintColor:[UIColor redColor]];
    }else if([type isEqualToString:@"travel_agency"]){
        marker=[[RMMarker alloc]initWithMapboxMarkerImage:@"suitcase" tintColor:[UIColor brownColor]];
    }else if([type isEqualToString:@"university"]){
        marker=[[RMMarker alloc]initWithMapboxMarkerImage:@"college" tintColor:[UIColor yellowColor]];
    }else if([type isEqualToString:@"airport"]||[type isEqualToString:@"bank"]||[type isEqualToString:@"embassy"]||[type isEqualToString:@"hospital"]||[type isEqualToString:@"parking"]||[type isEqualToString:@"pharmacy"]||[type isEqualToString:@"police"]){
        marker=[[RMMarker alloc]initWithMapboxMarkerImage:type tintColor:[UIColor redColor]];
    }else if([type isEqualToString:@"bar"]||[type isEqualToString:@"cafe"]||[type isEqualToString:@"laundry"]||[type isEqualToString:@"lodging"]||[type isEqualToString:@"restaurant"]){
       marker=[[RMMarker alloc]initWithMapboxMarkerImage:type tintColor:[UIColor brownColor]];
    }else if([type isEqualToString:@"cemetery"]){
        marker=[[RMMarker alloc]initWithMapboxMarkerImage:type tintColor:[UIColor blackColor]];

    }else if([type isEqualToString:@"library"]||[type isEqualToString:@"museum"]||[type isEqualToString:@"school"]){
        marker=[[RMMarker alloc]initWithMapboxMarkerImage:type tintColor:[UIColor yellowColor]];
    }else if ([type isEqualToString:@"park"]){
        marker=[[RMMarker alloc]initWithMapboxMarkerImage:type tintColor:[UIColor greenColor]];
    }
    else { marker=[[RMMarker alloc]initWithMapboxMarkerImage:@"circle" tintColor:[UIColor redColor]];}

    marker.canShowCallout=YES;
    return marker;
    
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   // AppDelegate *temp=[[AppDelegate alloc]init];
   // UIViewController *unityVC=[temp unityVC];
    //[temp repaintDisplayLink];
}

-(PageContentViewController *)contentPageAtIndex:(NSUInteger)index{
    PageContentViewController *mine=[[PageContentViewController alloc]init];
    mine.contentIndex=index;
    mine.text=_texts[index];
    mine.fileName=_images[index];
    return mine;
}
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    NSUInteger myindex=((PageContentViewController *)viewController).contentIndex;
    if (myindex==0 || myindex==NSNotFound) {
        return nil;
    }
    myindex--;
    return [self contentPageAtIndex:myindex];
}
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    NSUInteger myindex=((PageContentViewController *)viewController).contentIndex;
    if (myindex==NSNotFound) {
        return nil;
    }
    myindex++;
    if (myindex==[_texts count]) {
        return nil;
    }
    return [self contentPageAtIndex:myindex];
}
- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController{
    return [_texts count];
}
- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController{
    return 0;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [info removeFromSuperview];
    [around removeFromSuperview];
}

@end
