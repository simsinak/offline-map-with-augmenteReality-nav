//
//  annotation.m
//  Shiraz Augmented
//
//  Created by sina askarnejad on 3/19/14.
//  Copyright (c) 2014 sina askarnejad. All rights reserved.
//

#import "annotations.h"
#import "informations.h"
@implementation annotations
- (id)initWithMapView:(RMMapView *)aMapView information:(informations*)info{
    self=[super initWithMapView:aMapView coordinate:info.location.coordinate andTitle:info.name];
    _myInfo=info;
    return self;
}
@end
