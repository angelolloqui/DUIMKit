//
//  DUIColorStyler.m
//  DUIMKit
//
//  Created by Angel Garcia on 29/03/14.
//  Copyright (c) 2014 DUIMKit. All rights reserved.
//

#import "DUIColorStyler.h"
#import "DUI+Private.h"
#import "JSValue+DUI.h"

@implementation DUIColorStyler

- (void)styleElement:(id)element {
    JSValue *textColor = [[DUI applicationDUI] computedStyleForElement:element property:@"color"];

    if ([element respondsToSelector:@selector(setTextColor:)]) {
        [element setTextColor:textColor.toColor];
    }
}

@end
