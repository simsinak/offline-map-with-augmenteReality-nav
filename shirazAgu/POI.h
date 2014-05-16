//
//  POI.h
//  Shiraz Augmented
//
//  Created by sina askarnejad on 3/12/14.
//  Copyright (c) 2014 sina askarnejad. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Foundation/NSJSONSerialization.h>
#import <CoreLocation/CoreLocation.h>
#import "informations.h"
@class CLLocation;
@class informations;
typedef void(^okBlock)(NSDictionary *param);
typedef void(^ErrorBlock)(NSError *param);
typedef void(^imageBlock)(UIImage *param);
@interface POI : NSObject 
//<NSURLConnectionDataDelegate,NSURLConnectionDelegate>
@property(nonatomic , strong) NSMutableData *answer;
@property(nonatomic , strong)okBlock myOkBlock;
@property(nonatomic , strong)ErrorBlock myErrorBlock;
@property (nonatomic , strong)imageBlock myImageBlock;

+(POI *)getPOI;
-(void) loadPOIInLocation:(CLLocation *)locationParam ForRadius:(int)radiusParam haveAnswer:(okBlock)okBloackParam haveError:(ErrorBlock)ErrorParam;
-(void) loadAdditionsalInfoForLocation:(informations *)locationParam haveanswer:(okBlock)okBlockParam haveError:(ErrorBlock)ErrorParam;
-(void)loadImageForLocation:(informations *)locationParam haveanswer:(imageBlock)imageBlockParam haveError:(ErrorBlock)ErrorParam;
@end
