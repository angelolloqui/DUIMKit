//
//  DUIBackgroundStyler.m
//  DUIMKit
//
//  Created by Angel Garcia on 29/03/14.
//  Copyright (c) 2014 DUIMKit. All rights reserved.
//

#import "DUIBackgroundStyler.h"
#import "DUI+Private.h"
#import "JSValue+DUI.h"

@implementation DUIBackgroundStyler


- (void)styleElement:(UIView *)element {
    JSValue *bgColor = [[DUI applicationDUI] computedStyleForElement:element property:@"background-color"];
    element.backgroundColor = bgColor.toColor;
}

@end
