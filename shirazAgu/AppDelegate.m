//
//  AppDelegate.m
//  Unity-iPhone
//
//  Created by sina askarnejad on 4/9/14.
//
//

#import "AppDelegate.h"

@interface AppDelegate ()
{
    CMMotionManager *motionmanager;
}
@end
@implementation AppDelegate
@synthesize window,tabVC,mapVCGodHelp,arVCGodHelp,showTutor;
- (BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions{
    showTutor=YES;
    _app=application;
    _dic=launchOptions;
    BOOL x=[super application:application didFinishLaunchingWithOptions:launchOptions];
    self.unityVC = [super unityVC];
    CGRect rect = [[UIScreen mainScreen] bounds];
    self.window = [[UIWindow alloc] initWithFrame:rect];
    tabVC=[[UITabBarController alloc]init];
    mapVCGodHelp=[[ViewController alloc]init];
    arVCGodHelp=[[ARViewController1 alloc]init];
    [self.unityVC.tabBarItem setImage:[UIImage imageNamed:@"lens-icon.png"]];
    [self.unityVC.tabBarItem setTitle:@"infoView"];
    [mapVCGodHelp.tabBarItem setImage:[UIImage imageNamed:@"map-icon.png"]];
    [mapVCGodHelp.tabBarItem setTitle:@"map"];
    [arVCGodHelp.tabBarItem setImage:[UIImage imageNamed:@"glasses-icon.png"]];
    [arVCGodHelp.tabBarItem setTitle:@"AR radar"];
   /* UIViewController *viewController1 = [[UIViewController alloc] init];
    viewController1.view = [[UIView alloc] initWithFrame:self.window.frame];
    viewController1.view.backgroundColor = [UIColor whiteColor];
    UIViewController *viewController2 = [[UIViewController alloc] init];
    viewController2.view = [[UIView alloc] initWithFrame:self.window.frame];
    viewController2.view.backgroundColor = [UIColor grayColor];*/
  
    self.tabVC.viewControllers = @[mapVCGodHelp, arVCGodHelp, self.unityVC];
    self.window.rootViewController = self.tabVC;
    [self.window makeKeyAndVisible];
    
    //****
    UIButton *dontshowAgain = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [dontshowAgain addTarget:self action:@selector(dontshowAgainButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [dontshowAgain setBackgroundImage:[UIImage imageNamed:@"checkbox1"] forState:UIControlStateNormal];
    dontshowAgain.frame = CGRectMake(0, 1, 35, 35);

    UIButton *skip = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [skip addTarget:self action:@selector(skipPressed) forControlEvents:UIControlEventTouchUpInside];
    //[info setBackgroundImage:[UIImage imageNamed:@"info-green"] forState:UIControlStateNormal];
    [skip setTitle:@"Skip" forState:UIControlStateNormal];
    
    skip.frame = CGRectMake(280, 0, 40, 35);
    [dontshowAgain setSelected:YES];
    
    UILabel *message=[[UILabel alloc]initWithFrame:CGRectMake(37, 0, 100, 35)];
    [message setText:@"Dont Show"];
    [message setTextColor:[UIColor colorWithRed:0 green:0.478431 blue:1.0 alpha:1.0]];
    [message setFont:[UIFont fontWithName:@"Helvetica" size:15.0]];
    UIPageControl *mycontrol=[UIPageControl appearance];
    
    mycontrol.pageIndicatorTintColor=[UIColor lightGrayColor];
    mycontrol.currentPageIndicatorTintColor=[UIColor blackColor];
    mycontrol.backgroundColor=[UIColor whiteColor];
    [mycontrol addSubview:dontshowAgain];
    [mycontrol addSubview:skip];
    [mycontrol addSubview:message];
    //****
    return x;
}

-(CMMotionManager *)sharedManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        motionmanager=[[CMMotionManager alloc] init];
    });
    return motionmanager;
}
-(void)refresh{
    [super applicationWillResignActive:self.app];
    [super applicationDidEnterBackground:self.app];
    [super applicationWillEnterForeground:self.app];
    [super applicationDidBecomeActive:self.app];
 //   [super startUnity:self.app];
}
-(void)dontshowAgainButtonPressed:(UIButton *)sender{
  /*  if ([[sender currentBackgroundImage] isEqual:[UIImage imageNamed:@"checkbox1"]]) {
        [sender setBackgroundImage:[UIImage imageNamed:@"checkbox2"] forState:UIControlStateNormal];
        //  _showAgain.hidden=NO;
    }
    else  {
        [sender setBackgroundImage:[UIImage imageNamed:@"checkbox1"] forState:UIControlStateNormal];
        
        // _dontshowAgain.hidden=NO;
        // _showAgain.hidden=YES;
    }*/
    if ([sender isSelected]) {
         [sender setBackgroundImage:[UIImage imageNamed:@"checkbox2"] forState:UIControlStateNormal];
        [sender setSelected:NO];
         showTutor=NO;
    } else {
        [sender setBackgroundImage:[UIImage imageNamed:@"checkbox1"] forState:UIControlStateNormal];
        [sender setSelected:YES];
        showTutor=YES;
    }
}
-(void)skipPressed{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setBool:showTutor forKey:@"show_intro_pref"];
    [mapVCGodHelp setShowmaps:YES];
    [mapVCGodHelp.TutorialPage.view removeFromSuperview ];
}
@end
