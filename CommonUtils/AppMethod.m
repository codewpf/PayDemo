//
//  AppMethod.m
//  PNeayBy
//
//  Created by wpf on 15/11/15.
//  Copyright © 2015年 wpf. All rights reserved.
//

#import "AppMethod.h"
#include <ifaddrs.h>
#include <arpa/inet.h>
#import <CommonCrypto/CommonDigest.h>

@implementation AppMethod

+ (AppMethod *)shared
{
    static AppMethod *_share;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _share = [[AppMethod alloc]init];
    });
    return _share;
}

+ (NSString *)getRandomString
{
    NSString *str = [NSString stringWithFormat:@"%s",genRandomString(32)];
    return str;
}

char* genRandomString(int length)
{
    int flag, i;
    char* string;
    srand((unsigned) time(NULL ));
    if ((string = (char*) malloc(length)) == NULL )
    {
        //NSLog(@"Malloc failed!flag:14\n");
        return NULL ;
    }
    
    for (i = 0; i < length - 1; i++)
    {
        flag = rand() % 3;
        switch (flag)
        {
            case 0:
                string[i] = 'A' + rand() % 26;
                break;
            case 1:
                string[i] = 'a' + rand() % 26;
                break;
            case 2:
                string[i] = '0' + rand() % 10;
                break;
            default:
                string[i] = 'x';
                break;
        }
    }
    string[length - 1] = '\0';
    return string;
}

+ (NSString *)deviceIPAdress
{
    NSString *address = @"an error occurred when obtaining ip address";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    success = getifaddrs(&interfaces);
    
    if (success == 0) { // 0 表示获取成功
        
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            if( temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    freeifaddrs(interfaces);
    return address;
}

+ (NSMutableDictionary *)partnerSignOrder:(NSDictionary*)paramDic
{
    NSArray *keyArray = [paramDic allKeys];
    // 对字段进行字母序排序
    NSMutableArray *sortedKeyArray = [NSMutableArray arrayWithArray:keyArray];
    [sortedKeyArray sortUsingComparator:^NSComparisonResult(NSString* key1, NSString* key2) {
        return [key1 compare:key2];
    }];
    
    NSMutableString *paramString = [NSMutableString stringWithString:@""];
    // 拼接成 A=B&X=Y
    for (NSString *key in sortedKeyArray)
    {
        if ([paramDic[key] length] != 0)
        {
            [paramString appendFormat:@"&%@=%@", key, paramDic[key]];
        }
    }
    
    if ([paramString length] > 1)
    {
        [paramString deleteCharactersInRange:NSMakeRange(0, 1)];    // remove first '&'
    }
    
    [paramString appendFormat:@"&key=%@", WeChatPARTNER_ID];
    NSString *signString = [[AppMethod signString:paramString] uppercaseString];
    
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:paramDic];
    [dict setObject:signString forKey:@"sign"];
    return dict;
}


+ (NSString *)signString:(NSString*)origString
{
    const char *original_str = [origString UTF8String];
    unsigned char result[32];
    CC_MD5(original_str, (CC_LONG)strlen(original_str), result);//调用md5
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++){
        [hash appendFormat:@"%02x", result[i]];
    }
    return hash;
}



@end
