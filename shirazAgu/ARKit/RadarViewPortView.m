//
//  RadarViewPortView.m
//  ARKitDemo
//
//  Created by Ed Rackham (a1phanumeric) 2013
//  Based on mixare's implementation.
//

#import "RadarViewPortView.h"
#define radians(x) (M_PI * (x) / 180.0)

@implementation RadarViewPortView{
    float _newAngle;
}

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        _newAngle               = 45.0;
        _referenceAngle         = 247.5;
        self.backgroundColor    = [UIColor clearColor];
        _viewportColour         = [UIColor colorWithRed:14.0/255.0 green:140.0/255.0 blue:14.0/255.0 alpha:0.5];
    }
    
    return self;
}
-(void)scaleItUp{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:1];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    CGAffineTransform scaleTrans  = CGAffineTransformMakeScale(3.1f, 3.1f);
    CGAffineTransform lefttorightTrans  = CGAffineTransformMakeTranslation(-108.0f,-200.0f);
    self.transform = CGAffineTransformConcat(scaleTrans, lefttorightTrans);
    [UIView commitAnimations];
}
-(void)scaleItDown{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:1];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    self.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
    [UIView commitAnimations];
}
- (void)drawRect:(CGRect)rect{
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(contextRef, _viewportColour.CGColor);
    CGContextMoveToPoint(contextRef, RADIUS, RADIUS);

    CGContextAddArc(contextRef, RADIUS+1, RADIUS, RADIUS,  radians(_referenceAngle), radians(_referenceAngle+_newAngle),0);
    CGContextClosePath(contextRef);
    CGContextFillPath(contextRef);
}


@end
