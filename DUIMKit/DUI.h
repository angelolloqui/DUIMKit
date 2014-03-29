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

@property (nonatomic, strong) NSArray *stylers;

- (void)styleSheetFromPath:(NSString *)url;
- (NSString *)styleSheetCSS;


@end
