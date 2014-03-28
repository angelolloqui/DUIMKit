//
//  DUI.h
//  DUIMKit
//
//  Created by Angel Garcia on 28/03/14.
//  Copyright (c) 2014 DUIMKit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIView+DUI.h"
@interface DUI : NSObject

+ (DUI *)applicationDUI;


- (void)styleSheetFromPath:(NSString *)url;


// Computing styles
- (NSString *)styleClassForElement:(UIView *)element;
- (void)setStyleClass:(NSString *)cls forElement:(UIView *)element;

- (NSString *)styleIdForElement:(UIView *)element;
- (void)setStyleId:(NSString *)styleId forElement:(UIView *)element;

- (NSString *)styleCSSForElement:(UIView *)element;
- (void)setStyleCSS:(NSString *)css forElement:(UIView *)element;

- (NSString *)computedStylesForElement:(UIView *)element;

// Manipulating DOM
- (void)moveViewElement:(UIView *)element toParent:(UIView *)parent;


@end
