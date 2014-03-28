//
//  DUI.m
//  DUIMKit
//
//  Created by Angel Garcia on 28/03/14.
//  Copyright (c) 2014 DUIMKit. All rights reserved.
//

#import "DUI.h"
#import "UIView+DUI.h"

@interface DUI ()

@property (nonatomic, strong) UIWebView *virtualWebView;

@end

@implementation DUI

- (id)init {
    self = [super init];
    if (self) {
        _virtualWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
    }
    return self;
}

static DUI *_applicationDUI = nil;
+ (DUI *)applicationDUI {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _applicationDUI = [[self alloc] init];
    });
    return _applicationDUI;
}


#pragma mark - Styles

- (void)styleSheetFromPath:(NSString *)path {
    NSString *javascript = [NSString stringWithFormat:@"var fileref = document.createElement('link'); fileref.setAttribute('rel', 'stylesheet'); fileref.setAttribute('type', 'text/css'); fileref.setAttribute('href', 'file://%@'); document.body.appendChild(fileref); ", path];
    [_virtualWebView stringByEvaluatingJavaScriptFromString:javascript];
}

- (NSString *)styleClassForElement:(UIView *)element {
    NSString *javascript = [NSString stringWithFormat:@"document.getElementById('%@').className;", element.DUI_id];
    return [_virtualWebView stringByEvaluatingJavaScriptFromString:javascript];
}

- (void)setStyleClass:(NSString *)cls forElement:(UIView *)element {
    [self insertElement:element];
    NSString *javascript = [NSString stringWithFormat:@"document.getElementById('%@').className = '%@';", element.DUI_id, cls];
    [_virtualWebView stringByEvaluatingJavaScriptFromString:javascript];
}

- (NSString *)styleIdForElement:(UIView *)element {
    return nil;
}

- (void)setStyleId:(NSString *)styleId forElement:(UIView *)element {
}

- (NSString *)styleCSSForElement:(UIView *)element {
    NSString *javascript = [NSString stringWithFormat:@"document.getElementById('%@').cssText;", element.DUI_id];
    return [_virtualWebView stringByEvaluatingJavaScriptFromString:javascript];
}

- (void)setStyleCSS:(NSString *)css forElement:(UIView *)element {
    [self insertElement:element];
    NSString *javascript = [NSString stringWithFormat:@"document.getElementById('%@').style.cssText = '%@';", element.DUI_id, css];
    [_virtualWebView stringByEvaluatingJavaScriptFromString:javascript];
}

- (NSString *)computedStylesForElement:(UIView *)element {
    NSString *javascript = [NSString stringWithFormat:@"JSON.stringify(window.getComputedStyle(document.getElementById('%@')))", element.DUI_id];
    return [_virtualWebView stringByEvaluatingJavaScriptFromString:javascript];
}

#pragma mark - DOM manipulaiton

- (void)moveViewElement:(UIView *)element toParent:(UIView *)parent {
    
    // If no parent, then remove the view from hierarchy
    if (!parent) {
        [self removeElement:element];
        return;
    }
    
    [self insertElement:parent];
    [self insertElement:element];
    
    NSString *javascript = [NSString stringWithFormat:@"var id = '%@'; var parentId = '%@'; document.getElementById(parentId).appendChild(document.getElementById(id));", element.DUI_id, parent.DUI_id];
    [_virtualWebView stringByEvaluatingJavaScriptFromString:javascript];    
}


#pragma mark - Helpers

- (void)insertElement:(UIView *)element {
    if (!element.DUI_insertedInDOM) {
        NSString *javascript = [NSString stringWithFormat:@"var id = '%@'; var e = document.getElementById(id); if (!e) { e = document.createElement('%@'); e.setAttribute('id', id); document.body.appendChild(e); }", element.DUI_id, element.DUI_tag];
        [_virtualWebView stringByEvaluatingJavaScriptFromString:javascript];
        element.DUI_insertedInDOM = YES;
    }
}

- (void)removeElement:(UIView *)element {
    if (element.DUI_insertedInDOM) {
        NSString *javascript = [NSString stringWithFormat:@"var id = '%@'; var e = document.getElementById(id); if (e) { e.parentNode.removeChild(e); document.body.appendChild(e); }", element.DUI_id];
        [_virtualWebView stringByEvaluatingJavaScriptFromString:javascript];
        element.DUI_insertedInDOM = NO;
    }
}


- (NSString *)description {
    return [_virtualWebView stringByEvaluatingJavaScriptFromString:@"document.body.outerHTML"];
}

@end
