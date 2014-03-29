//
//  UIView+DUI.m
//  DUIMKit
//
//  Created by Angel Garcia on 28/03/14.
//  Copyright (c) 2014 DUIMKit. All rights reserved.
//

#import "UIView+DUI.h"
#import "DUI.h"
#import <objc/runtime.h>

@implementation UIView (DUI)

+ (void)load {
    static dispatch_once_t onceToken;
    [DUI applicationDUI];
    dispatch_once(&onceToken, ^{
        Method willMoveToSuperview = class_getInstanceMethod(self, @selector(willMoveToSuperview:));
        Method DUI_willMoveToSuperview = class_getInstanceMethod(self, @selector(DUI_willMoveToSuperview:));
        
        //Swizzle methods
        method_exchangeImplementations(willMoveToSuperview, DUI_willMoveToSuperview);        
    });
}

- (void)DUI_willMoveToSuperview:(UIView *)newSuperview {
    [[DUI applicationDUI] moveViewElement:self toParent:newSuperview];
    [self DUI_willMoveToSuperview:newSuperview];
    
}

- (void)setStyleClass:(NSString *)styleClass {
    [[DUI applicationDUI] setStyleClass:styleClass forElement:self];
}

- (NSString *)styleClass {
    return [[DUI applicationDUI] styleClassForElement:self];
}

-(void)setStyleId:(NSString *)styleId {
    [[DUI applicationDUI] setStyleId:styleId forElement:self];
}

- (NSString *)styleId {
    return [[DUI applicationDUI] styleIdForElement:self];
}

- (void)setStyleCSS:(NSString *)styleCSS {
    [[DUI applicationDUI] setStyleCSS:styleCSS forElement:self];
}

- (NSString *)styleCSS {
    return [[DUI applicationDUI] styleCSSForElement:self];
}

- (NSString *)DUI_tag {
//    return @"div";
    return NSStringFromClass([self class]);
}

- (NSString *)DUI_id {
    return [NSString stringWithFormat:@"%p", self];
}

- (NSString *)DUI_description {
    return [NSString stringWithFormat:@"<%@ id=\"%@\" class=\"%@\" style=\"%@\">", self.DUI_tag, self.DUI_id, self.styleClass, self.styleCSS];
}

#pragma mark - Properties

static void *const kDUI_Node = (void *)&kDUI_Node;
- (JSValue *)DUI_Node {
    return objc_getAssociatedObject(self, kDUI_Node);
}

- (void)setDUI_Node:(JSValue *)DUI_Node {
    objc_setAssociatedObject(self, kDUI_Node, DUI_Node, OBJC_ASSOCIATION_RETAIN);
}

@end
