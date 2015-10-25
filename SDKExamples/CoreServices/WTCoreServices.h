//
//  WTCoreServcies.h
//  SDKExamples
//
//  Created by Andreas Schacherbauer on 4/20/13.
//  Copyright (c) 2014 Wikitude. All rights reserved.
//

#include "UIColor+WikitudeColors.h"

#define _WTLog(args,...) do { [(NSFileHandle*)[NSFileHandle fileHandleWithStandardOutput] writeData:[[NSString stringWithFormat:args, ##__VA_ARGS__] dataUsingEncoding: NSUTF8StringEncoding]]; } while(0); newLine
#define WTLog(args,...) NSLog(@"[%@ %@] (line %d) | %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), __LINE__, [NSString stringWithFormat:(args), ##__VA_ARGS__]);
