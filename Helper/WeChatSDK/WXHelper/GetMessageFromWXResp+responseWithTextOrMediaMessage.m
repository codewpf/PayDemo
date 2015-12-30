//
//  GetMessageFromWXResp+responseWithTextOrMediaMessage.m
//  SDKSample
//
//  Created by Jeason on 15/7/14.
//
//

#import "GetMessageFromWXResp+responseWithTextOrMediaMessage.h"

@implementation GetMessageFromWXResp (responseWithTextOrMediaMessage)

+ (GetMessageFromWXResp *)responseWithText:(NSString *)text
                         OrMediaMessage:(WXMediaMessage *)message
                                  bText:(BOOL)bText {
    GetMessageFromWXResp *resp = [[[GetMessageFromWXResp alloc] init] autorelease];
    resp.bText = bText;
    if (bText)
        resp.text = text;
    else
        resp.message = message;
    return resp;
}

@end
