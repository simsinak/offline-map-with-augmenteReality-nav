#ifndef _TRAMPOLINE_UNITYAPPCONTROLLER_H_
#define _TRAMPOLINE_UNITYAPPCONTROLLER_H_


#import <UIKit/UIKit.h>
#include "iPhone_Common.h"
#include "PluginBase/RenderPluginDelegate.h"

// it is the unity rendering view class
// if you want custom view logic, you should subclass UnityView
@class UnityView;

@interface UnityAppController : NSObject<UIApplicationDelegate>
{
	UnityView*			_unityView;

	UIView*				_rootView;
	UIViewController*	_rootController;


	id<RenderPluginDelegate>	_renderDelegate;
}

// override it to add your render plugin delegate
- (void)shouldAttachRenderDelegate;
- (UIViewController *)unityVC;
// this one is called at the very end of didFinishLaunchingWithOptions:, just before firing off startUnity
- (void)preStartUnity;
// this one is called at the very end of didFinishLaunchingWithOptions:, after view hierarchy been created
// NB: it will be started with delay 0: next run loop itration
- (void)startUnity:(UIApplication*)application;
// this is one is passed to CADisplayLink
- (void)repaintDisplayLink;
// this is unity frame processing (called from repaintDisplayLink)
- (void)repaint;

// override this only if you need customized unityview
- (UnityView*)initUnityViewImpl;

// override this to tweak unity view hierarchy
// _unityView will be inited
// you need to init _rootView and _rootController
- (void)createViewHierarchyImpl;

// you should not override these methods in usual case
- (UnityView*)initUnityView;
- (void)createViewHierarchy;
- (void)showGameUI:(UIWindow*)window;

// in general this method just works, so override it only if you have very special reorientation logic
- (void)onForcedOrientation:(ScreenOrientation)orient;

@property (readonly, copy, nonatomic) UnityView*		unityView;
@property (readonly, copy, nonatomic) UIView*			rootView;
@property (readonly, copy, nonatomic) UIViewController*	rootViewController;

@property(nonatomic, retain) id renderDelegate;

@end

// Put this into mm file with your subclass implementation
// pass subclass name to define

#define IMPL_APP_CONTROLLER_SUBCLASS(ClassName)	\
@interface ClassName(OverrideAppDelegate)		\
{												\
}												\
+(void)load;									\
@end											\
@implementation ClassName(OverrideAppDelegate)	\
+(void)load										\
{												\
	extern const char* AppControllerClassName;	\
	AppControllerClassName = #ClassName;		\
}												\
@end											\

inline UnityAppController*	GetAppController()
{
	return (UnityAppController*)[UIApplication sharedApplication].delegate;
}

void AppController_RenderPluginMethod(SEL method);
void AppController_RenderPluginMethodWithArg(SEL method, id arg);

// these are simple wrappers about ios api, added for convenience
void AppController_SendNotification(NSString* name);
void AppController_SendNotificationWithArg(NSString* name, id arg);



#endif // _TRAMPOLINE_UNITYAPPCONTROLLER_H_
