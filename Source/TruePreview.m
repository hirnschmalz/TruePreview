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
  if (self == [TruePreview class]) {
    class_setSuperclass(self, NSClassFromString(@"MVMailBundle"));
  }

  [super registerBundle];
  
  // register the preferences value transformers
  [NSValueTransformer
    setValueTransformer:[[TruePreviewPreferenceValueTransformer alloc] init]
    forName:@"TruePreviewPreferenceValueTransformer"
  ];
  [NSValueTransformer
    setValueTransformer:[[TruePreviewPreferenceValueTransformerDelay alloc] init]
    forName:@"TruePreviewPreferenceValueTransformerDelay"
  ];
  [NSValueTransformer
    setValueTransformer:[[TruePreviewPreferenceValueTransformerDelayEditIndicator alloc] init]
    forName:@"TruePreviewPreferenceValueTransformerDelayEditIndicator"
  ];
  
  // add our "categories"
  [TruePreviewLibraryMessage truePreviewAddAsCategoryToClass:NSClassFromString(@"LibraryMessage")];
  [TruePreviewMessageViewer truePreviewAddAsCategoryToClass:NSClassFromString(@"MessageViewer")];
  [TruePreviewPreferences truePreviewAddAsCategoryToClass:NSClassFromString(@"NSPreferences")];
  
  // do our swizzles
  [NSClassFromString(@"LibraryMessage")
    truePreviewSwizzleMethod:@selector(markAsViewed)
    withMethod:@selector(truePreviewMarkAsViewed)
    isClassMethod:NO
  ];
  [NSClassFromString(@"MessageViewer")
    truePreviewSwizzleMethod:@selector(dealloc)
    withMethod:@selector(truePreviewDealloc)
    isClassMethod:NO
  ];
  [NSClassFromString(@"MessageViewer")
    truePreviewSwizzleMethod:@selector(forwardAsAttachment:)
    withMethod:@selector(truePreviewForwardAsAttachment:)
    isClassMethod:NO
  ];
  [NSClassFromString(@"MessageViewer")
    truePreviewSwizzleMethod:@selector(forwardMessage:)
    withMethod:@selector(truePreviewForwardMessage:)
    isClassMethod:NO
  ];
  [NSClassFromString(@"MessageViewer")
    truePreviewSwizzleMethod:@selector(markAsRead:)
    withMethod:@selector(truePreviewMarkAsRead:)
    isClassMethod:NO
  ];
  [NSClassFromString(@"MessageViewer")
    truePreviewSwizzleMethod:@selector(markAsUnread:)
    withMethod:@selector(truePreviewMarkAsUnread:)
    isClassMethod:NO
  ];
  [NSClassFromString(@"MessageViewer")
    truePreviewSwizzleMethod:@selector(messageNoLongerDisplayedInTextView:)
    withMethod:@selector(truePreviewMessageNoLongerDisplayedInTextView:)
    isClassMethod:NO
  ];
  [NSClassFromString(@"MessageViewer")
    truePreviewSwizzleMethod:@selector(messageWasDisplayedInTextView:)
    withMethod:@selector(truePreviewMessageWasDisplayedInTextView:)
    isClassMethod:NO
  ];
  [NSClassFromString(@"MessageViewer")
    truePreviewSwizzleMethod:@selector(replyAllMessage:)
    withMethod:@selector(truePreviewReplyAllMessage:)
    isClassMethod:NO
  ];
  [NSClassFromString(@"MessageViewer")
    truePreviewSwizzleMethod:@selector(replyMessage:)
    withMethod:@selector(truePreviewReplyMessage:)
    isClassMethod:NO
  ];
  [NSClassFromString(@"NSPreferences")
   truePreviewSwizzleMethod:@selector(sharedPreferences)
   withMethod:@selector(truePreviewSharedPreferences)
   isClassMethod:YES
   ];
  
  // set defaults
  [[NSUserDefaults standardUserDefaults]
    registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:
      [NSNumber numberWithInt:TRUEPREVIEW_DELAY_IMMEDIATE], @"TruePreviewDelay",
      [NSNumber numberWithInt:NSOnState], @"TruePreviewReply",
      [NSNumber numberWithInt:NSOnState], @"TruePreviewForward",
      [NSNumber numberWithInt:NSOnState], @"TruePreviewWindow",
      [NSNumber numberWithInt:NSOffState], @"TruePreviewScroll",
      nil
    ]
  ];
  
  // we're all set
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
  return @"TruePreviewPreferencesModule";
}

+ (NSString*)preferencesPanelName {
  return @"TruePreview";
}

@end

@implementation NSObject (TruePreviewObject)

#pragma mark Class methods

+ (void)truePreviewAddAsCategoryToClass:(Class)inClass {
  unsigned int theCount = 0;
  Method* theMethods = class_copyMethodList(object_getClass([self class]), &theCount);
  Class theClass = object_getClass(inClass);
  unsigned int i = 0;
  
  while (YES) {
    for (i = 0; i < theCount; i++) {
      if (
        !class_addMethod(
          theClass,
          method_getName(theMethods[i]),
          method_getImplementation(theMethods[i]),
          method_getTypeEncoding(theMethods[i])
        )
      ) {
        NSLog(
          @"truePreviewAddAsCategoryToClass: could not add %@ to %@",
          NSStringFromSelector(method_getName(theMethods[i])),
          inClass
        );
      }
    }
    
    if (theMethods != nil) {
      free(theMethods);
    }
    
    if (theClass != inClass) {
      theClass = inClass;
      theMethods = class_copyMethodList([self class], &theCount);
    }
    else {
      break;
    }
  }
}

+ (void)truePreviewSwizzleMethod:(SEL)inOriginalSelector withMethod:(SEL)inReplacementSelector isClassMethod:(BOOL)inIsClassMethod {
  Method theOriginalMethod = (!inIsClassMethod
    ? class_getInstanceMethod([self class], inOriginalSelector)
    : class_getClassMethod([self class], inOriginalSelector)
  );
  Method theReplacementMethod = (!inIsClassMethod
    ? class_getInstanceMethod([self class], inReplacementSelector)
    : class_getClassMethod([self class], inReplacementSelector)
  );

  method_exchangeImplementations(theOriginalMethod, theReplacementMethod);
}

@end
