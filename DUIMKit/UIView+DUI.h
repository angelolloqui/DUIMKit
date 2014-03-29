//
//  UIView+DUI.h
//  DUIMKit
//
//  Created by Angel Garcia on 28/03/14.
//  Copyright (c) 2014 DUIMKit. All rights reserved.
//

#import <UIKit/UIKit.h>
@import JavaScriptCore;

@interface UIView (DUI)

@property (nonatomic, copy) NSString *styleId;
@property (nonatomic, copy) NSString *styleClass;
@property (nonatomic, copy) NSString *styleCSS;

@property (nonatomic, readonly) NSString *DUI_tag;
@property (nonatomic, readonly) NSString *DUI_id;
@property (nonatomic, strong) JSValue *DUI_Node;

+ (void)DUI_swizzle;
- (NSString *)DUI_description;

@end
