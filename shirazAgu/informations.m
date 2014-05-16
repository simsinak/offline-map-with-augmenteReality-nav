//
//  info.m
//  Shiraz Augmented
//
//  Created by sina askarnejad on 3/16/14.
//  Copyright (c) 2014 sina askarnejad. All rights reserved.
//

#import "informations.h"

@implementation informations
-(NSString *)infoText{
    return [NSString stringWithFormat:@"Name:%@\nAddress:%@\nPhone:%@\nWeb:%@",_name,_address,_phone,_website];
}
@end
