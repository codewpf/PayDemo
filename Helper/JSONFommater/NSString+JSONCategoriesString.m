//
//  NSString+JSONCategoriesString.m
//  tcpoctest
//
//  Created by WangQing on 13-12-31.
//  Copyright (c) 2013年 gump. All rights reserved.
//

#import "NSString+JSONCategoriesString.h"

@implementation NSString (JSONCategoriesString)

-(id)JSONValue;
{
    NSData* data = [self dataUsingEncoding:NSUTF8StringEncoding];
    __autoreleasing NSError* error = nil;
    id result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (error != nil) return nil;
    return result;
}




@end
