//
//  JSValue+DUI.m
//  DUIMKit
//
//  Created by Angel Garcia on 29/03/14.
//  Copyright (c) 2014 DUIMKit. All rights reserved.
//

#import "JSValue+DUI.h"

@implementation JSValue (DUI)

- (UIColor *)toColor {
    NSString *colorStr = [[[[self[@"cssText"] toString] stringByReplacingOccurrencesOfString:@")" withString:@""] componentsSeparatedByString:@"("] lastObject];
    NSArray *components = [colorStr componentsSeparatedByString:@","];

    if ([components count] == 3) {
        return [UIColor colorWithRed:[components[0] floatValue]/255.0
                               green:[components[1] floatValue]/255.0
                                blue:[components[2] floatValue]/255.0
                               alpha:1];
    }
    if ([components count] == 4) {
        return [UIColor colorWithRed:[components[0] floatValue]/255.0
                               green:[components[1] floatValue]/255.0
                                blue:[components[2] floatValue]/255.0
                               alpha:[components[3] floatValue]/255.0];
    }
    return nil;
}

@end
