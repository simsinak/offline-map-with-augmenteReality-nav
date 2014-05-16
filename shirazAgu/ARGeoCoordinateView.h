//
//  ARGeoCoordinateView.h
//  Shiraz Augmented
//
//  Created by sina askarnejad on 3/26/14.
//  Copyright (c) 2014 sina askarnejad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ARGeoCoordinate.h"
@class ARGeoCoordinate;
@protocol ARGeoCoordinateViewDelegate;
@interface ARGeoCoordinateView : UIView
@property (nonatomic , strong)ARGeoCoordinate *geoCoordinate;
@property (nonatomic ,strong) id<ARGeoCoordinateViewDelegate> delegate;
@property (nonatomic , strong) UILabel *myName;
@property (nonatomic , strong) UILabel *myDistance;
-(id)initWithCoordinate:(ARGeoCoordinate *)coordinate type:(NSString *)type delegate:(id<ARGeoCoordinateViewDelegate>)delegate;
@end
@protocol ARGeoCoordinateViewDelegate <NSObject>

-(void)GeoCoordinateViewTouched:(ARGeoCoordinateView *)geoView;


@end