//
//  JPCard.m
//  JudoKitObjC
//
//  Copyright (c) 2016 Alternative Payments Ltd
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

#import "JPCard.h"
#import "CardNetwork.h"
#import "NSString+Helper.h"

@interface JPCard ()

@end

@implementation JPCard

- (instancetype)initWithCardNumber:(NSString *)cardNumber expiryDate:(NSString *)expiryDate secureCode:(NSString *)secureCode {
	self = [super init];
	if (self) {
        self.cardNumber = cardNumber;
        self.expiryDate = expiryDate;
        self.secureCode = secureCode;
	}
	return self;
}

+ (NSString *)cardPresentationStringFromString:(NSString *)fromString withAcceptedNetworks:(NSArray *)networks {
    
    // strip whitespaces
    NSString *strippedString = [fromString stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    // check if count is between 0 and 16
    if (strippedString.length == 0) {
        return @"";
    } else if (strippedString.length > 16 || ![strippedString isNumeric]) {
        return nil;
    }
    
    // make sure to only check for the allowed networks
    CardNetwork network = [self networkForString:strippedString];
    
    // Only try to format if a specific card number has been recognized
    if (network == CardNetworkUnknown) {
        return strippedString;
    }
    
    return @"";
}

+ (CardNetwork)networkForString:(NSString *)networkString {
    return CardNetworkUnknown;
}


@end
