//
//  info.h
//  Shiraz Augmented
//
//  Created by sina askarnejad on 3/16/14.
//  Copyright (c) 2014 sina askarnejad. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CLLocation;
@interface informations : NSObject
@property(nonatomic , strong) CLLocation *location;
//
@property(nonatomic , strong) NSString *icon;
@property(nonatomic , strong)NSString *name;
@property(nonatomic , strong)NSString *reference;
@property(nonatomic) NSUInteger rating;
@property(nonatomic , strong)NSString *type;
@property(nonatomic , strong)NSString *vicinity;
@property(nonatomic ,strong)NSString *address;
@property(nonatomic ,strong)NSString *phone;
@property(nonatomic ,strong)NSString *photoRefrence;
@property(nonatomic ,strong)NSString *website;
-(NSString *)infoText;
@end
