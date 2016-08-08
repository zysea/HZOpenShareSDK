//
//  HZShareObject.m
//  CommonUtil
//
//  Created by Hiram on 16/8/6.
//  Copyright © 2016年 Hiram. All rights reserved.
//

#import "HZShareObject.h"


@implementation HZShareObject
@synthesize description = _description;

+(instancetype)object
{
    HZShareObject *object = [[self alloc]init];
    return object;
}

-(id)init
{
    self = [super init];
    if (self) {
        _title = @"";
        _description = @"";
        _URLStr = @"";
        _musicDataUrl = @"";
    }
    return self;
}

-(void)setTitle:(NSString *)title
{
    NSString *n_title = [title stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([n_title length]==0) {
        _title = @"";
        return;
    }
    _title = title;
}

-(void)setDescription:(NSString *)description
{
    NSString *n_description = [description stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([n_description length]==0) {
        _description= @"";
        return;
    }
    _description = description;
}
@end

