/*
 * Copyright (c) 2009-2011, Jim Riggs, Christian Serving, L.L.C.
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

#import "TruePreviewPreferencesModule.h"

@implementation TruePreviewPreferencesModule

#pragma mark NSPreferencesModule instance methods

- (NSString*)preferencesNibName {
  TRUEPREVIEW_LOG();
  
  return @"TruePreviewPreferencesPanel";
}

- (void)willBeDisplayed {
  TRUEPREVIEW_LOG();
  
  [super willBeDisplayed];

  // build the list of accounts
  NSDictionary* theAccountDict = [[NSUserDefaults standardUserDefaults] objectForKey:@"TruePreviewAccountSettings"];
  NSMutableArray* theAccounts = [NSMutableArray array];
  NSEnumerator* theEnum = [[[NSClassFromString(@"MailAccount") remoteAccounts] valueForKey:@"displayName"] objectEnumerator];
  NSString* theDisplayName = nil;

  while (theDisplayName = [theEnum nextObject]) {
    NSMutableDictionary* theAccount = [NSMutableDictionary dictionaryWithObjectsAndKeys:
      theDisplayName, @"displayName",
      [NSNumber numberWithInt:TRUEPREVIEW_DELAY_DEFAULT], @"delay",
      [NSNumber numberWithInt:TRUEPREVIEW_DELAY_DEFAULT], @"reply",
      [NSNumber numberWithInt:TRUEPREVIEW_DELAY_DEFAULT], @"forward",
      [NSNumber numberWithInt:TRUEPREVIEW_DELAY_DEFAULT], @"window",
      [NSNumber numberWithInt:TRUEPREVIEW_DELAY_DEFAULT], @"scroll",
      nil
    ];
    
    [theAccount addEntriesFromDictionary:[theAccountDict objectForKey:theDisplayName]];
    [theAccounts addObject:theAccount];
  }

  // watch the array for changes to save the user defaults
  [theAccounts
    addObserver:self
    toObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [theAccounts count])]
    forKeyPath:@"delay"
    options:0
    context:theAccounts
  ];
  [theAccounts
    addObserver:self
    toObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [theAccounts count])]
    forKeyPath:@"reply"
    options:0
    context:theAccounts
  ];
  [theAccounts
    addObserver:self
    toObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [theAccounts count])]
    forKeyPath:@"forward"
    options:0
    context:theAccounts
  ];
  [theAccounts
    addObserver:self
    toObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [theAccounts count])]
    forKeyPath:@"window"
    options:0
    context:theAccounts
  ];
  [theAccounts
    addObserver:self
    toObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [theAccounts count])]
    forKeyPath:@"scroll"
    options:0
    context:theAccounts
  ];

  [fldAccountArrayController setContent:theAccounts];
}

#pragma mark NSKeyValueObserving instance methods

- (void)observeValueForKeyPath:(NSString*)inPath
    ofObject:(id)inObject
    change:(NSDictionary*)inChange
    context:(void*)inContext {
  TRUEPREVIEW_LOG(@"%@, %@, %@, %p", inPath, inObject, inChange, inContext);
  
  NSMutableDictionary* theAccountDict = [NSMutableDictionary dictionary];
  
  // build the account settings dictionary to save in the user defaults
  for (NSDictionary* theAccount in (NSArray*)inContext) {
    [theAccountDict setObject:theAccount forKey:[theAccount objectForKey:@"displayName"]];
  }
  
  [[NSUserDefaults standardUserDefaults] setObject:theAccountDict forKey:@"TruePreviewAccountSettings"];
  [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark Instance methods

- (NSString*)truePreviewVersion {
  return [[[NSBundle bundleForClass:[TruePreview class]] infoDictionary] objectForKey:@"CFBundleVersion"];
}

@end
