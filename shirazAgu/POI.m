//
//  POI.m
//  Shiraz Augmented
//
//  Created by sina askarnejad on 3/12/14.
//  Copyright (c) 2014 sina askarnejad. All rights reserved.
//

#import "POI.h"

NSString * const Key=@"AIzaSyClOFpStfFZnW90H5duxtUyOPQmLGcS5J0";
@implementation POI
@synthesize answer;
-(void) loadPOIInLocation:(CLLocation *)locationParam ForRadius:(int)radiusParam haveAnswer:(okBlock)okBloackParam haveError:(ErrorBlock)ErrorParam{
    answer=nil;
    self.myOkBlock=okBloackParam;
    self.myErrorBlock=ErrorParam;
    NSString *Url=@"https://maps.googleapis.com/maps/api/place/" ;
    NSMutableString *myUrl=[NSMutableString stringWithString:Url];
    NSUserDefaults *settings=[NSUserDefaults standardUserDefaults];
    NSString *language=[settings stringForKey:@"poi_language_pref"];
    if ([[settings stringForKey:@"distance_metric_pref"]isEqualToString:@"yard"]) {
        radiusParam=(int)radiusParam*0.9144;
    }
    NSString *sensor;
    if ([settings boolForKey:@"sensor_pref"]==YES) {
        sensor=@"true";
    }
    else{
        sensor=@"false";
    }
    [myUrl appendFormat:@"nearbysearch/json?location=%f,%f&radius=%d&sensor=%@&types=establishment&key=%@&language=%@",locationParam.coordinate.latitude,locationParam.coordinate.longitude ,radiusParam,sensor,Key,language];

    [myUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *myAddress=[NSURL URLWithString:myUrl];
    NSMutableURLRequest *myRequest=[NSMutableURLRequest requestWithURL:myAddress cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60];
    [myRequest setHTTPMethod:@"GET"];
 //   [myRequest setHTTPShouldHandleCookies:YES];
    //
    
    //NSURLConnection *myConnection=[[NSURLConnection alloc]initWithRequest:myRequest delegate:self];
    [NSURLConnection connectionWithRequest:myRequest delegate:self];
    [self networkActivator];
    
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    //
    if (answer==nil) {
        answer=[[NSMutableData alloc]init];
        [answer appendData:data];
       // answer=[NSMutableData dataWithData:data];
    } else {
        [answer appendData:data];
    }
    
    
    
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    [self networkActivatorOff];
    NSError *errorTemp;
    id object=[NSJSONSerialization JSONObjectWithData:answer options:NSJSONReadingAllowFragments error:&errorTemp];
    if (object!=nil) {
        _myOkBlock(object);
    }
    else{
        UIImage *imageinfo=[UIImage imageWithData:answer];
        _myImageBlock(imageinfo);
    }
    
}
+(POI *)getPOI{
    static POI *myPOI=nil;
    //dispatch_once ya ba static ya ba global miad
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        myPOI = [[POI alloc]init];
    });
    return myPOI;
}
-(void)networkActivator{
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
}
-(void)networkActivatorOff{
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
   [self networkActivatorOff];
    //
    _myErrorBlock(error);
}
-(void) loadAdditionsalInfoForLocation:(informations *)locationParam haveanswer:(okBlock)okBlockParam haveError:(ErrorBlock)ErrorParam{
    answer=nil;
    self.myOkBlock=okBlockParam;
    self.myErrorBlock=ErrorParam;
    NSString *Url=@"https://maps.googleapis.com/maps/api/place/" ;
    NSMutableString *myUrl=[NSMutableString stringWithString:Url];
    [myUrl appendFormat:@"details/json?reference=%@&sensor=true&key=%@",[locationParam reference], Key];
    [myUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *myAddress=[NSURL URLWithString:myUrl];
    NSMutableURLRequest *myRequest=[NSMutableURLRequest requestWithURL:myAddress cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60];
    [myRequest setHTTPMethod:@"GET"];
    [NSURLConnection connectionWithRequest:myRequest delegate:self];
     [self networkActivator];
}
-(void)loadImageForLocation:(informations *)locationParam haveanswer:(imageBlock)imageBlockParam haveError:(ErrorBlock)ErrorParam{
    answer=nil;
    self.myImageBlock=imageBlockParam;
    self.myErrorBlock=ErrorParam;
    NSString *Url=@"https://maps.googleapis.com/maps/api/place/";
    NSMutableString *myUrl=[NSMutableString stringWithString:Url];
    [myUrl appendFormat:@"photo?maxwidth=300&photoreference=%@&sensor=true&key=%@",[locationParam photoRefrence],Key];
    [myUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *myAddress=[NSURL URLWithString:myUrl];
    NSMutableURLRequest *myRequest=[NSMutableURLRequest requestWithURL:myAddress cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60];
    [myRequest setHTTPMethod:@"GET"];
    [NSURLConnection connectionWithRequest:myRequest delegate:self];
    [self networkActivator];

}
@end
