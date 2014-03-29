//
//  DUI.m
//  DUIMKit
//
//  Created by Angel Garcia on 28/03/14.
//  Copyright (c) 2014 DUIMKit. All rights reserved.
//

#import "DUI+Private.h"
#import "DUIStylerProtocol.h"
#import <objc/runtime.h>

@interface DUI ()

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
        _viewsToUpdate = [NSMutableSet set];
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
        
        //Load all stylers
        NSMutableArray *stylers = [NSMutableArray array];
        NSArray *classes = [self classesImplementingProtocol:@protocol(DUIStylerProtocol)];
        for (Class cls in classes) {
            [stylers addObject:[[cls alloc] init]];
        }
        _stylers = stylers;
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
    return [_jsContext[@"stylesheet"][@"innerHTML"] toString];
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


- (JSValue *)computedStyleForElement:(UIView *)element property:(NSString *)property {
    return [_computedStyleForPropertyFunction callWithArguments:@[element.DUI_id, property]];
}

#pragma mark - DOM manipulaiton

- (void)moveViewElement:(UIView *)element toParent:(UIView *)parent {
    
    //Create both in DOM if they do not exist
    [self insertElement:parent];
    [self insertElement:element];
    
    [_moveElementToParentFunction callWithArguments:@[element.DUI_id, parent.DUI_id ?: [NSNull null]]];
    
    [self viewNeedsStyle:element];
}


#pragma mark - Helpers


- (void)insertElement:(UIView *)element {
    if (element && !element.DUI_Node) {
        element.DUI_Node = [_insertElementFunction callWithArguments:@[element.DUI_id, element.DUI_tag]];
    }
}


- (void)viewNeedsStyle:(UIView *)element {
    if (!element) return;
    if (![_viewsToUpdate containsObject:element]) {
        [_viewsToUpdate addObject:element];
        for (UIView *v in element.subviews) {
            [self viewNeedsStyle:v];
        }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self styleViews];
    });
}


- (void)styleViews {
    NSSet *views = [_viewsToUpdate copy];
    [_viewsToUpdate removeAllObjects];
    
    for (UIView *v in views) {
        for (id<DUIStylerProtocol> styler in _stylers) {
            [styler styleElement:v];
        }
    }
}

- (NSString *)description {
    return [_virtualWebView stringByEvaluatingJavaScriptFromString:@"document.body.outerHTML"];
}


- (NSArray *)classesImplementingProtocol:(Protocol *)protocol{
	//Count the total number of classes implementing the protocol
    NSMutableArray *classesArray = [[NSMutableArray alloc] init];
	int numClasses = objc_getClassList(NULL, 0);
	if (numClasses > 0 ){
        
		//Get the classes
		__unsafe_unretained Class *classes = (Class *)malloc(sizeof(Class) * numClasses);
		numClasses = objc_getClassList(classes, numClasses);
        
		//For each class
		for (int i=0; i<numClasses; i++){
            
            //Check if the class conforms to protocol
			__unsafe_unretained Class cls = (Class)classes[i];
            // class_conformsToProtocol(cls, protocol)
			if (class_conformsToProtocol(cls, protocol)){
				[classesArray addObject:cls];
			}
		}
		free(classes);
	}
	return classesArray;
}


@end
