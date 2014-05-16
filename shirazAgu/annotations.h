//
//  annotation.h
//  Shiraz Augmented
//
//  Created by sina askarnejad on 3/19/14.
//  Copyright (c) 2014 sina askarnejad. All rights reserved.
//

#import <Mapbox/Mapbox.h>
@class informations;
@interface annotations : RMAnnotation
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) NSString *subtitle;

@property (nonatomic, strong) id userInfo;

@property (nonatomic, strong) NSString *annotationType;

@property (nonatomic , strong) informations *myInfo;
- (id)initWithMapView:(RMMapView *)aMapView information:(informations*)info;

@end
