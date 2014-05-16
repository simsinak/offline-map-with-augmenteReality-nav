//
//  AppDelegate.h
//  Unity-iPhone
//
//  Created by sina askarnejad on 4/9/14.
//
//

#import "UnityAppController.h"
#import <CoreMotion/CoreMotion.h>
#import "ViewController.h"
#import "ARViewController1.h"

@interface AppDelegate : UnityAppController 
@property (nonatomic, strong) UIViewController *unityVC;
@property (nonatomic , strong) UIWindow *window;
@property (nonatomic , strong) UITabBarController *tabVC;
@property (strong, nonatomic, readonly) CMMotionManager *sharedManager;
@property (nonatomic , strong) ViewController *mapVCGodHelp;
@property (nonatomic , strong) ARViewController1 *arVCGodHelp;
@property (nonatomic , strong)NSDictionary *dic;
@property (nonatomic , strong)UIApplication *app;
@property (nonatomic , strong)UIView *test;
@property BOOL showTutor;

-(void)refresh;
@end
