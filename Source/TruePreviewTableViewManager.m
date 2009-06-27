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

#import "TruePreviewTableViewManager.h"

@implementation TableViewManager (TruePreviewTableViewManager)

#pragma mark Instance methods

- (void)truePreviewSetCurrentDisplayedMessage:(id)inMessage {
  // keep a timer for each instance to handle multiple message viewer windows
  static NSMutableDictionary* sTimers = nil;

  if (sTimers == nil) {
    sTimers = [[NSMutableDictionary alloc] initWithCapacity:1];
  }
  
  NSTimer* theTimer = [sTimers objectForKey:[NSNumber numberWithLong:(long)self]];
  double theDelay = [[NSUserDefaults standardUserDefaults] floatForKey:@"TruePreviewDelay"];

  if (theTimer != nil) {
    [theTimer invalidate];
  }
  
  [self truePreviewSetCurrentDisplayedMessage:inMessage];
  
  // we only want to do something for LibraryMessage objects (e.g. not threads)
  if ([inMessage isKindOfClass:[LibraryMessage class]]) {
    NSDictionary* theAccountDict = [[NSUserDefaults standardUserDefaults] objectForKey:@"TruePreviewAccountSettings"];
    
    // get any custom delay
    if ([[[theAccountDict objectForKey:[[inMessage account] displayName]] objectForKey:@"custom"] boolValue]) {
      theDelay = [[[theAccountDict objectForKey:[[inMessage account] displayName]] objectForKey:@"delay"] floatValue];
    }
    
    if (theDelay == 0) {
      [(LibraryMessage*)inMessage truePreviewMarkAsViewed];
    }
    else {
      theTimer = [((theTimer == nil) ? [NSTimer alloc] : theTimer)
        initWithFireDate:[NSDate dateWithTimeIntervalSinceNow:theDelay]
        interval:0
        target:inMessage
        selector:@selector(truePreviewMarkAsViewed)
        userInfo:nil
        repeats:NO
      ];
      
      [sTimers setObject:theTimer forKey:[NSNumber numberWithLong:(long)self]];
      [[NSRunLoop currentRunLoop] addTimer:theTimer forMode:NSDefaultRunLoopMode];
    }
  }
}

@end
