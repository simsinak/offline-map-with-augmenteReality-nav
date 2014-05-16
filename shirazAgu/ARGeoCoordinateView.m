//
//  ARGeoCoordinateView.m
//  Shiraz Augmented
//
//  Created by sina askarnejad on 3/26/14.
//  Copyright (c) 2014 sina askarnejad. All rights reserved.
//

#import "ARGeoCoordinateView.h"

@implementation ARGeoCoordinateView
@synthesize geoCoordinate,myDistance,myName;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
-(id)initWithCoordinate:(ARGeoCoordinate *)coordinate type:(NSString *)type delegate:(id<ARGeoCoordinateViewDelegate>)delegate{
    self=[super initWithFrame:CGRectMake(0, 0, 255, 103)];
    UIImageView *callout=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"PoiLabel.png"] ];
    //[new sizeToFit];
    [self addSubview:callout];
    [self sendSubviewToBack:callout];
    //[callout setAlpha:0.5f];
    [self setBackgroundColor:[UIColor clearColor]];
    geoCoordinate=coordinate;
    _delegate=delegate;
    UIImageView *tag;
    ///
    if ([type isEqualToString:@"amusement_park"]) {
        tag=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"playgrounf-24x.png"] ];
    } else if([type isEqualToString:@"art_gallery"]){
        tag=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"art-gallery-24x.png"] ];
    }else if([type isEqualToString:@"atm"]||[type isEqualToString:@"finance"]){
        tag=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bank-24x.png"] ];
    }else if([type isEqualToString:@"beauty_salon"]){
        tag=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"hairdresser-24x.png"] ];
    }else if([type isEqualToString:@"bicycle_store"]){
        tag=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bicycle-24x.png"] ];

    }else if([type isEqualToString:@"bus_station"]){
        tag=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bus-24x.png"] ];
    }else if([type isEqualToString:@"campground"]){
        tag=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"campsite-24x.png"] ];
    }else if([type isEqualToString:@"car_dealer"]||[type isEqualToString:@"car_rental"]||[type isEqualToString:@"car_repair"]||[type isEqualToString:@"car_wash"]){
        tag=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"car-24x.png"] ];
    }else if([type isEqualToString:@"church"]){
        tag=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"religious-christian-24x.png"] ];

    }else if([type isEqualToString:@"city_hall"]){
       tag=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"town-hall-24x.png"] ];
    }else if([type isEqualToString:@"clothing_store"]){
         tag=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"clothing-store-24x.png"] ];
    }else if([type isEqualToString:@"fire_station"]){
        tag=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"fire-station-24x.png"] ];
    }else if([type isEqualToString:@"florist"]){
        tag=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"garden-24x.png"] ];
    }else if([type isEqualToString:@"food"]){
       tag=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"fast-food-24x.png"] ];
    }else if([type isEqualToString:@"funeral_home"]){
        tag=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cemetery-24x.png"] ];
    }else if([type isEqualToString:@"gas_station"]){
         tag=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"fuel-24x.png"] ];
    }else if([type isEqualToString:@"grocery_or_supermarket"]){
        tag=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"grocery-24x.png"] ];
    }else if([type isEqualToString:@"health"]){
        tag=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"hospital-24x.png"] ];
    }else if([type isEqualToString:@"liquor_store"]){
        tag=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"alcohol-shop-24x.png"] ];
    }else if([type isEqualToString:@"mosque"]||[type isEqualToString:@"place_of_worship"]){
         tag=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"place-of-worship-24x.png"] ];
    }else if([type isEqualToString:@"movie_rental"]||[type isEqualToString:@"movie_theater"]||[type isEqualToString:@"moving_company"]){
        tag=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cinema-24x.png"] ];
    }else if([type isEqualToString:@"pet_store"]){
        tag=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"dog-park-24x.png"] ];
    }else if([type isEqualToString:@"post_office"]){
        tag=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"post-24x.png"] ];
    }else if([type isEqualToString:@"spa"]){
       tag=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"water-24x.png"] ];
    }else if([type isEqualToString:@"storage"]){
        tag=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"warehouse-24x.png"] ];
    }else if([type isEqualToString:@"subway_station"]){
        tag=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"rail-metro-24x.png"] ];
    }else if([type isEqualToString:@"synagogue"]){
        tag=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"religious-jewish-24x.png"] ];

    }else if([type isEqualToString:@"train_station"]){
        tag=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"rail-24x.png"] ];
    }else if([type isEqualToString:@"travel_agency"]){
       tag=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"suitcase-24x.png"] ];
    }else if([type isEqualToString:@"university"]){
        tag=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"college-24x.png"] ];
    }else if([type isEqualToString:@"airport"]||[type isEqualToString:@"bank"]||[type isEqualToString:@"embassy"]||[type isEqualToString:@"hospital"]||[type isEqualToString:@"parking"]||[type isEqualToString:@"pharmacy"]||[type isEqualToString:@"police"]){
        tag=[[UIImageView alloc]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@-24@2x.png",type]] ];
    }else if([type isEqualToString:@"bar"]||[type isEqualToString:@"cafe"]||[type isEqualToString:@"laundry"]||[type isEqualToString:@"lodging"]||[type isEqualToString:@"restaurant"]){
        tag=[[UIImageView alloc]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@-24@2x.png",type]] ];
    }else if([type isEqualToString:@"cemetery"]){
       tag=[[UIImageView alloc]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@-24@2x.png",type]] ];
    }else if([type isEqualToString:@"library"]||[type isEqualToString:@"museum"]||[type isEqualToString:@"school"]){
       tag=[[UIImageView alloc]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@-24@2x.png",type]] ];    }else if ([type isEqualToString:@"park"]){
        tag=[[UIImageView alloc]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@-24@2x.png",type]] ];    }
    else { tag=[[UIImageView alloc]initWithImage:[UIImage imageNamed:
                                                  @"circle-24x.png"] ];}

    /////******************************************
    tag.frame=CGRectMake(10, 20, 50, 50);
    [self addSubview:tag];
    //myName=[[UILabel alloc]initWithFrame:CGRectMake(60, 20, 250, 20)];
    //****
    myName=[[UILabel alloc]initWithFrame:CGRectMake(60, 20, self.bounds.size.width-60, 40)];
    //****
    
    [myName setTextAlignment:NSTextAlignmentJustified];
    [myName setTextColor:[UIColor blackColor]];
    [myName setText:[coordinate title]];
    [myName setAdjustsFontSizeToFitWidth:YES];
    myName.lineBreakMode=NSLineBreakByWordWrapping;
    myName.numberOfLines=0;
   // myDistance=[[UILabel alloc]initWithFrame:CGRectMake(60, 40, 100, 40)];
    //***
    myDistance=[[UILabel alloc]initWithFrame:CGRectMake(60, 50, 100, 40)];
    //***
    [myDistance setTextAlignment:NSTextAlignmentCenter];
    [myDistance setTextColor:[UIColor blackColor]];
    [myDistance setText:[NSString stringWithFormat:@"%.2f km",[coordinate distanceFromOrigin]/1000.0f]];
    [myName sizeToFit];
    [self setUserInteractionEnabled:YES];
    [callout addSubview:myName];
    [callout addSubview:myDistance];
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    [super drawRect:rect];
    [myDistance setText:[NSString stringWithFormat:@"%.2f km",[geoCoordinate distanceFromOrigin]/1000.0f]];
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    //
    [_delegate GeoCoordinateViewTouched:self];
}
-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    CGRect checkInThisFrame=CGRectMake(0, 0, 255, 103);
    return CGRectContainsPoint(checkInThisFrame, point);
}

@end
