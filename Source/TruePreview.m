/*
 * Copyright (c) 2009, Jim Riggs, Christian Serving, L.L.C.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are
 * met:
 *     * Redistributions of source code must retain the above copyright
 *       notice, this list of conditions and the following disclaimer.
 *     * Redistributions in binary form must reproduce the above
 *       copyright notice, this list of conditions and the following
 *       disclaimer in the documentation and/or other materials provided
 *       with the distribution.
 *     * Neither the name of Christian Serving, L.L.C. nor the names of
 *       its contributors may be used to endorse or promote products
 *       derived from this software without specific prior written
 *       permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 * HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "TruePreview.h"

@implementation TruePreview

#pragma mark Class initialization

+ (void)initialize {
  [TruePreview registerBundle];
  
  // do our swizzles
  [NSPreferences
    truePreviewSwizzleMethod:@selector(sharedPreferences)
    withMethod:@selector(truePreviewSharedPreferences)
    isClassMethod:YES
  ];
  [LibraryMessage
    truePreviewSwizzleMethod:@selector(markAsViewed)
    withMethod:@selector(truePreviewMarkAsViewed)
    isClassMethod:NO
  ];
  [TableViewManager
    truePreviewSwizzleMethod:@selector(setCurrentDisplayedMessage:)
    withMethod:@selector(truePreviewSetCurrentDisplayedMessage:)
    isClassMethod:NO
  ];
  
  [[NSUserDefaults standardUserDefaults]
    registerDefaults:[NSDictionary
      dictionaryWithObject:[NSNumber numberWithInt:0] forKey:@"TruePreviewDelay"
    ]
  ];
  
	NSLog(
    @"Loaded TruePreview plugin %@",
    [[NSBundle bundleForClass:[TruePreview class]] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey]
  );
}

#pragma mark MVMailBundle class methods

+ (BOOL)hasPreferencesPanel {
  return YES;
}

+ (NSString*)preferencesOwnerClassName {
  return NSStringFromClass([TruePreviewPreferencesModule class]);
}

+ (NSString*)preferencesPanelName {
  return @"TruePreview";
}

@end

@implementation NSObject (TruePreviewObject)

#pragma mark Class methods

+ (void)truePreviewSwizzleMethod:(SEL)inOriginalSelector withMethod:(SEL)inReplacementSelector isClassMethod:(BOOL)inIsClassMethod {
  Method theOriginalMethod = (!inIsClassMethod
    ? class_getInstanceMethod([self class], inOriginalSelector)
    : class_getClassMethod([self class], inOriginalSelector)
  );
  Method theReplacementMethod = (!inIsClassMethod
    ? class_getInstanceMethod([self class], inReplacementSelector)
    : class_getClassMethod([self class], inReplacementSelector)
  );

#if __OBJC2__
  method_exchangeImplementations(theOriginalMethod, theReplacementMethod);
#else
  char* theOriginalTypes = theOriginalMethod->method_types;

  theOriginalMethod->method_types = theReplacementMethod->method_types;
  theReplacementMethod->method_types = theOriginalTypes;

  IMP theOriginalImp = theOriginalMethod->method_imp;
  
  theOriginalMethod->method_imp = theReplacementMethod->method_imp;
  theReplacementMethod->method_imp = theOriginalImp;
#endif
}

@end
