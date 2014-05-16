//
//  Radar.m
//  ARKitDemo
//
//  Created by Ed Rackham (a1phanumeric) 2013
//  Based on mixare's implementation.
//

#import "Radar.h"

@implementation Radar{
    float _range;
}

@synthesize pois    = _pois;
@synthesize radius  = _radius;

- (id)initWithFrame:(CGRect)frame{
    if ((self = [super initWithFrame:frame])) {
       
        self.backgroundColor    = [UIColor clearColor];
        _radarBackgroundColour  = [UIColor colorWithRed:14.0/255.0 green:140.0/255.0 blue:14.0/255.0 alpha:0.2];
        _pointColour            = [UIColor blackColor];
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
    CGContextSetFillColorWithColor(contextRef, [UIColor clearColor].CGColor);
    CGContextDrawImage(contextRef, CGRectMake(0.5, 0.5, RADIUS*2, RADIUS*2), [UIImage imageNamed:@"Radar.png"].CGImage);
    // Draw a radar and the view port 
    CGContextFillEllipseInRect(contextRef, CGRectMake(0.5, 0.5, RADIUS*2, RADIUS*2));
   // CGContextSetRGBStrokeColor(contextRef,120, 120, 0, 0.5);
    //****************************ino havaset bashe taghir bedi
  //  _range = _radius *1000;
    _range = 3000;
    //*******************************
    float scale = _range / RADIUS ;
    NSLog(@"scale:%f",scale);
    
    if (_pois != nil) {
        for (ARGeoCoordinate *poi in _pois) {
            float x, y;
            NSLog(@"azimuth:%f",poi.azimuth);
            NSLog(@"radialDistance:%f",poi.radialDistance);
            //case1: azimiut is in the 1 quadrant of the radar
            if (poi.azimuth >= 0 && poi.azimuth < M_PI / 2) {
                x = RADIUS + cosf((M_PI / 2) - poi.azimuth) * (poi.radialDistance / scale);
                y = RADIUS - sinf((M_PI / 2) - poi.azimuth) * (poi.radialDistance / scale);
                 NSLog(@"1");
            } else if (poi.azimuth > M_PI / 2 && poi.azimuth < M_PI) {
                //case2: azimiut is in the 2 quadrant of the radar
                x = RADIUS + cosf(poi.azimuth - (M_PI / 2)) * (poi.radialDistance / scale);
                y = RADIUS + sinf(poi.azimuth - (M_PI / 2)) * (poi.radialDistance / scale);
                NSLog(@"2");

            } else if (poi.azimuth > M_PI && poi.azimuth < (3 * M_PI / 2)) {
                //case3: azimiut is in the 3 quadrant of the radar
                x = RADIUS - cosf((3 * M_PI / 2) - poi.azimuth) * (poi.radialDistance / scale);
                y = RADIUS + sinf((3 * M_PI / 2) - poi.azimuth) * (poi.radialDistance / scale);
                NSLog(@"3");

            } else if(poi.azimuth > (3 * M_PI / 2) && poi.azimuth < (2 * M_PI)) {
                //case4: azimiut is in the 4 quadrant of the radar
                x = RADIUS - cosf(poi.azimuth - (3 * M_PI / 2)) * (poi.radialDistance / scale);
                y = RADIUS - sinf(poi.azimuth - (3 * M_PI / 2)) * (poi.radialDistance / scale);
                NSLog(@"4");

            } else if (poi.azimuth == 0) {
                x = RADIUS;
                y = RADIUS - poi.radialDistance / scale;
                NSLog(@"5");

            } else if(poi.azimuth == M_PI/2) {
                x = RADIUS + poi.radialDistance / scale;
                y = RADIUS;
                NSLog(@"6");

            } else if(poi.azimuth == (3 * M_PI / 2)) {
                x = RADIUS;
                y = RADIUS + poi.radialDistance / scale;
                NSLog(@"7");

            } else if (poi.azimuth == (3 * M_PI / 2)) {
                x = RADIUS - poi.radialDistance / scale;
                y = RADIUS;
                NSLog(@"8");

            } else {
                //If none of the above match we use the scenario where azimuth is 0
                x = RADIUS;
                y = RADIUS - poi.radialDistance / scale;
                NSLog(@"9");

            }
            NSLog(@"x:%f",x);
             NSLog(@"y:%f",y);
            //drawing the radar point
            CGContextSetFillColorWithColor(contextRef, [UIColor yellowColor].CGColor);
            if (x <= RADIUS * 2 && x >= 0 && y >= 0 && y <= RADIUS * 2) {
                CGContextFillEllipseInRect(contextRef, CGRectMake(x, y, 4, 4));
            }
        }
    }
}
@end
