#include "QCARUnityPlayer.h"

#include "iPhone_View.h"
#include "UnityAppController.h"
#include "UI/ActivityIndicator.h"
#include "UI/Keyboard.h"
#include "UI/SplashScreen.h"
#include "UI/UnityViewControllerBase.h"
#include "UI/UnityView.h"
#include "iPhone_OrientationSupport.h"
#include "Unity/DisplayManager.h"

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIApplication.h>

#include "objc/runtime.h"

ScreenOrientation _curOrientation = orientationUnknown;
static ScreenOrientation	_nativeRequestedOrientation	= orientationUnknown;
static DisplayConnection*	_mainDisplay				= nil;


bool _shouldAttemptReorientation = false;


UIWindow*			UnityGetMainWindow()		{ return _mainDisplay->window; }
UIViewController*	UnityGetGLViewController()	{ return GetAppController().rootViewController; }
UIView*				UnityGetGLView()			{ return GetAppController().unityView; }
ScreenOrientation	UnityCurrentOrientation()	{ return _curOrientation; }

// TODO: this will be removed in upcoming versions of unity
// we started tearing apart view handling code and at some point we started to have cur orient in 2 places
// here and in UnityView
// in here, whenever we change _curOrientation we call OrientTo
// which in turn calls [UnityAppController onForcedOrientation], which will update unity view orientation
// Again, this will be fixed in future version, but we need to live with that for now
void UnityUpdateCurrentOrientationValue(ScreenOrientation orient)	{ _curOrientation = orient; }



extern "C" void UnityStartActivityIndicator()
{
	ShowActivityIndicator(_mainDisplay->view);
}

extern "C" void UnityStopActivityIndicator()
{
	HideActivityIndicator();
}

void CreateViewHierarchy()
{
	static bool _DefaultControllerClassInited = false;
	if(!_DefaultControllerClassInited)
	{
		AddViewControllerAllDefaultImpl([UnityDefaultViewController class]);
		_DefaultControllerClassInited = true;
	}

	[GetAppController() createViewHierarchy];

	_mainDisplay = [[DisplayManager Instance] mainDisplay];
	[_mainDisplay->window makeKeyAndVisible];

	[UIView setAnimationsEnabled:NO];
	ShowSplashScreen(_mainDisplay->window);

	NSNumber* style = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"Unity_LoadingActivityIndicatorStyle"];
	ShowActivityIndicator([SplashScreen Instance], style ? [style intValue] : -1 );
}

void ReleaseViewHierarchy()
{
	HideActivityIndicator();
	HideSplashScreen();
}

static void UpdateOrientationFromController(UIViewController* controller)
{
	_curOrientation = ConvertToUnityScreenOrientation(controller.interfaceOrientation,0);
	QCARUnityPlayer::getInstance().QCARSetOrientation(_curOrientation);

	UnitySetScreenOrientation(_curOrientation);
	AppController_RenderPluginMethodWithArg(@selector(onOrientationChange:), (id)_curOrientation);
	OrientTo(_curOrientation);
}

void OnUnityInited()
{
	// set unity screen orientation, so first level awake get correct values
	UpdateOrientationFromController([SplashScreenController Instance]);
}

void OnUnityReady()
{
	UnityStopActivityIndicator();
	HideSplashScreen();

	// this is called after level was loaded, so orientation constraints or resolution might have changed
	UpdateOrientationFromController(GetAppController().rootViewController);
	[GetAppController().unityView recreateGLESSurface];

	[GetAppController() showGameUI:_mainDisplay->window];

	// here goes the magic:
	// we run unity loop once (Start will be called on scripts)
	// but we do not present, and then do normal repaint (with present)
	// it is done to properly hande resolution request in Start
	// and we want to draw right after showing window, to avoid black frame creeping in
	extern bool _skipPresent;

	_skipPresent = true;
	UnityPlayerLoop();
	_skipPresent = false;
	[GetAppController() repaint];


	[UIView setAnimationsEnabled:YES];
}

extern "C" void NotifyAutoOrientationChange()
{
	_shouldAttemptReorientation = true;
}

static bool OrientationWillChangeSurfaceExtents( ScreenOrientation prevOrient, ScreenOrientation targetOrient )
{
	bool prevLandscape   = ( prevOrient == landscapeLeft || prevOrient == landscapeRight );
	bool targetLandscape = ( targetOrient == landscapeLeft || targetOrient == landscapeRight );

	return( prevLandscape != targetLandscape );
}

void OrientTo(int requestedOrient_)
{
	ScreenOrientation requestedOrient = (ScreenOrientation)requestedOrient_;

	extern bool _unityLevelReady;
	if(_unityLevelReady)
		UnityFinishRendering();

	[CATransaction begin];
	{
		[KeyboardDelegate StartReorientation];
		QCARUnityPlayer::getInstance().QCARSetOrientation(requestedOrient);

		[GetAppController() onForcedOrientation:requestedOrient];
		[UIApplication sharedApplication].statusBarOrientation = ConvertToIosScreenOrientation(requestedOrient);
	}
	[CATransaction commit];

	[CATransaction begin];
	[KeyboardDelegate FinishReorientation];
	[CATransaction commit];

	_curOrientation = requestedOrient;
}

// use it if you need to request native orientation change
// it is expected to be used with autorotation
// useful when you want to change unity orientation from overlaid view controller
void RequestNativeOrientation(ScreenOrientation targetOrient)
{
	_nativeRequestedOrientation = targetOrient;
}

void CheckOrientationRequest()
{
	ScreenOrientation requestedOrient = (ScreenOrientation)UnityRequestedScreenOrientation();
	if(requestedOrient == autorotation)
	{
		if(_ios50orNewer && _shouldAttemptReorientation)
			[UIViewController attemptRotationToDeviceOrientation];
		_shouldAttemptReorientation = false;
	}

	if(_nativeRequestedOrientation != orientationUnknown)
	{
		if(_nativeRequestedOrientation != _curOrientation)
			OrientTo(_nativeRequestedOrientation);
		_nativeRequestedOrientation = orientationUnknown;
	}
	else if(requestedOrient != autorotation)
	{
		if(requestedOrient != _curOrientation)
			OrientTo(requestedOrient);
	}
}

float ScreenScaleFactor()
{
	return [UIScreen mainScreen].scale;
}

void SetScaleFactorFromScreen(UIView* view)
{
	if( [view respondsToSelector:@selector(setContentScaleFactor:)] )
		[view setContentScaleFactor: ScreenScaleFactor()];
}

@implementation UnityDefaultViewController
@end
