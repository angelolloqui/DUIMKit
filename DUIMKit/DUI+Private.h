//
//  DUI+Private.h
//  DUIMKit
//
//  Created by Angel Garcia on 29/03/14.
//  Copyright (c) 2014 DUIMKit. All rights reserved.
//

#import "DUI.h"
@import JavaScriptCore;

@interface DUI ()

// Computing styles
- (NSString *)styleClassForElement:(UIView *)element;
- (void)setStyleClass:(NSString *)cls forElement:(UIView *)element;

- (NSString *)styleIdForElement:(UIView *)element;
- (void)setStyleId:(NSString *)styleId forElement:(UIView *)element;

- (NSString *)styleCSSForElement:(UIView *)element;
- (void)setStyleCSS:(NSString *)css forElement:(UIView *)element;

- (JSValue *)computedStyleForElement:(UIView *)element property:(NSString *)property;

// Manipulating DOM
- (void)moveViewElement:(UIView *)element toParent:(UIView *)parent;
- (void)removeElement:(UIView *)element;

@end
