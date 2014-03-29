//
//  DUI.m
//  DUIMKit
//
//  Created by Angel Garcia on 28/03/14.
//  Copyright (c) 2014 DUIMKit. All rights reserved.
//

#import "DUI.h"
#import "UIView+DUI.h"
@import JavaScriptCore;

@interface DUI () <UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *virtualWebView;
@property (nonatomic, strong) JSContext *jsContext;
@property (nonatomic, strong) NSMutableSet *viewsToUpdate;

//Javascript utilities
@property (nonatomic, strong) JSValue *computedStyleForPropertyFunction;
@property (nonatomic, strong) JSValue *elementByIdFunction;
@property (nonatomic, strong) JSValue *insertElementFunction;
@property (nonatomic, strong) JSValue *moveElementToParentFunction;

@end

@implementation DUI

- (id)init {
    self = [super init];
    if (self) {
        
        //Configure Webview and JS context
        _virtualWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
        _jsContext = [_virtualWebView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
        NSAssert([_jsContext isKindOfClass:[JSContext class]], @"Can not get a proper JSContext from webview");
        
        //Configure JS functions
        NSString *path = [[NSBundle mainBundle] pathForResource:@"DUI" ofType:@"js"];
        NSString *js = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        NSAssert([js length] > 0, @"Can not find the DUI.js document in the bundle");
        [_jsContext evaluateScript:js];
        _jsContext[@"console"][@"log"] = ^(JSValue *msg) {
            NSLog(@"JavaScript log: %@", msg);
        };

        //Quick accessores
        _elementByIdFunction = _jsContext[@"document"][@"getElementById"];
        _computedStyleForPropertyFunction = _jsContext[@"computedStyleForProperty"];
        _insertElementFunction = _jsContext[@"insertElement"];
        _moveElementToParentFunction = _jsContext[@"moveElementToParent"];
        
//        _viewsToUpdate = [NSMutableSet set];

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
    NSString *css = [[NSString alloc] initWithData:[[NSFileManager defaultManager] contentsAtPath:path] encoding:NSUTF8StringEncoding];
    JSValue *style = [_insertElementFunction callWithArguments:@[@"stylesheet", @"style"]];
    style[@"innerHTML"] = css;
    
    //Add all views to views to update
    [self viewNeedsStyle:[UIApplication sharedApplication].keyWindow];
}

- (NSString *)styleSheetCSS {
    return [_jsContext[@"document"][@"head"][@"style"][@"innerHTML"] toString];
}

- (NSString *)styleClassForElement:(UIView *)element {
    return [element.DUI_Node[@"className"] toString];
}

- (void)setStyleClass:(NSString *)cls forElement:(UIView *)element {
    [self insertElement:element];
    element.DUI_Node[@"className"] = cls;
    [self viewNeedsStyle:element];
}

- (NSString *)styleIdForElement:(UIView *)element {
    return nil;
}

- (void)setStyleId:(NSString *)styleId forElement:(UIView *)element {
}

- (NSString *)styleCSSForElement:(UIView *)element {
    return [element.DUI_Node[@"style"][@"cssText"] toString];
}

- (void)setStyleCSS:(NSString *)css forElement:(UIView *)element {
    [self insertElement:element];
    element.DUI_Node[@"style"][@"cssText"] = css;
    [self viewNeedsStyle:element];
}


- (NSString *)computedStyleForElement:(UIView *)element property:(NSString *)property {
    JSValue *style = [_computedStyleForPropertyFunction callWithArguments:@[element.DUI_id, property]];
    
    return [style[@"cssText"] toString];    
}

#pragma mark - DOM manipulaiton

- (void)moveViewElement:(UIView *)element toParent:(UIView *)parent {
    
    //Create both in DOM if they do not exist
    [self insertElement:parent];
    [self insertElement:element];
    
    [_moveElementToParentFunction callWithArguments:@[element.DUI_id, parent.DUI_id ?: [NSNull null]]];
    
    [self viewNeedsStyle:element];
}

- (void)buildDOMFromElement:(UIView *)element {
    [self insertElement:element];
    [_moveElementToParentFunction callWithArguments:@[element.DUI_id, element.superview.DUI_id ?: [NSNull null]]];
    for (UIView *subview in [element subviews]) {
        [self buildDOMFromElement:subview];
    }
}

#pragma mark - Helpers


- (void)insertElement:(UIView *)element {
    if (element && !element.DUI_Node) {
        element.DUI_Node = [_insertElementFunction callWithArguments:@[element.DUI_id, element.DUI_tag]];
    }
}


- (void)removeElement:(UIView *)element {
//    if (element.DUI_insertedInDOM) {
//        NSString *javascript = [NSString stringWithFormat:@"var id = '%@'; var e = document.getElementById(id); if (e) { e.parentNode.removeChild(e); document.body.appendChild(e); }", element.DUI_id];
//        [_virtualWebView stringByEvaluatingJavaScriptFromString:javascript];
//        element.DUI_insertedInDOM = NO;
//    }
}


- (void)viewNeedsStyle:(UIView *)element {
    if (![_viewsToUpdate containsObject:element]) {
        [_viewsToUpdate addObject:element];
        for (UIView *v in element.subviews) {
            [self viewNeedsStyle:v];
        }
    }
}

- (NSString *)description {
    return [_virtualWebView stringByEvaluatingJavaScriptFromString:@"document.body.outerHTML"];
}

@end
