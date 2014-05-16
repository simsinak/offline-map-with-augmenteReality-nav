#ifndef _TRAMPOLINE_UI_KEYBOARD_H_
#define _TRAMPOLINE_UI_KEYBOARD_H_

#import <UIKit/UIKit.h>

typedef struct
{
	const char* text;
	const char* placeholder;

	UIKeyboardType				keyboardType;
	UITextAutocorrectionType	autocorrectionType;
	UIKeyboardAppearance		appearance;

	bool multiline;
	bool secure;
}
KeyboardShowParam;


@interface KeyboardDelegate : NSObject <UITextFieldDelegate, UITextViewDelegate>
{
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField;
- (void)textInputDone:(id)sender;
- (void)textInputCancel:(id)sender;
- (void)keyboardDidShow:(NSNotification*)notification;
- (void)keyboardWillHide:(NSNotification*)notification;

// on older devices initial keyboard creation might be slow, so it is good to init in on initial loading.
// on the ther hand, if you dont use keyboard (or use it rarely), you can avoid having all related stuff in memory:
//     keyboard will be created on demand anyway (in Instance method)
+ (void)Initialize;
+ (KeyboardDelegate*)Instance;

- (id)init;
- (void)show:(KeyboardShowParam)param;
- (void)hide;
- (void)positionInput:(CGRect*)keyboardRect x:(float)x y:(float)y;

+ (void)StartReorientation;
+ (void)FinishReorientation;

- (NSString*)getText;
- (void)setText:(NSString*)newText;

- (bool)isActive;
- (bool)isDone;
- (bool)wasCanceled;

- (void)setInputHidden:(BOOL)hidden;
@end


#endif // _TRAMPOLINE_UI_KEYBOARD_H_
