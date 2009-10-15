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

#import "TruePreviewMessageViewer.h"

@implementation TruePreviewMessageViewer

#pragma mark Class methods

+ (NSMutableDictionary*)truePreviewTimers {
  static NSMutableDictionary* sTimers = nil;
  
  if (sTimers == nil) {
    sTimers = [[NSMutableDictionary alloc] initWithCapacity:1];
  }
  
  return sTimers;
}

#pragma mark Swizzled instance methods

- (void)truePreviewDealloc {
  [self truePreviewReset];
  [[[self class] truePreviewTimers]
    removeObjectForKey:[NSNumber numberWithUnsignedLong:(unsigned long)self]
  ];
  [self truePreviewDealloc];
}

- (void)truePreviewForwardAsAttachment:(id)inSender {
  id theMessage = [self currentDisplayedMessage];
  
  if ([theMessage isKindOfClass:NSClassFromString(@"LibraryMessage")]) {
    NSDictionary* theSettings = [theMessage truePreviewSettings];
    
    if ([[theSettings objectForKey:@"forward"] boolValue]) {
      [self truePreviewReset];
      [theMessage truePreviewMarkAsViewed];
    }
  }
  
  [self truePreviewForwardAsAttachment:inSender];
}

- (void)truePreviewForwardMessage:(id)inSender {
  id theMessage = [self currentDisplayedMessage];
  
  if ([theMessage isKindOfClass:NSClassFromString(@"LibraryMessage")]) {
    NSDictionary* theSettings = [theMessage truePreviewSettings];
    
    if ([[theSettings objectForKey:@"forward"] boolValue]) {
      [self truePreviewReset];
      [theMessage truePreviewMarkAsViewed];
    }
  }
  
  [self truePreviewForwardMessage:inSender];
}

- (void)truePreviewMarkAsRead:(id)inSender {
  [self truePreviewReset];
  [self truePreviewMarkAsRead:inSender];
}

- (void)truePreviewMarkAsUnread:(id)inSender {
  [self truePreviewReset];
  [self truePreviewMarkAsUnread:inSender];
}

- (void)truePreviewMessageNoLongerDisplayedInTextView:(NSNotification*)inNotification {
  [self truePreviewMessageNoLongerDisplayedInTextView:inNotification];

  // we receive notifications from all MessageContentControllers
  if ([inNotification object] != object_getIvar(self, class_getInstanceVariable([self class], "_contentController"))) {
    return;
  }
  
  [self truePreviewReset];
}

- (void)truePreviewMessageWasDisplayedInTextView:(NSNotification*)inNotification {
  [self truePreviewMessageWasDisplayedInTextView:inNotification];
  
  // we receive notifications from all MessageContentControllers
  if ([inNotification object] != object_getIvar(self, class_getInstanceVariable([self class], "_contentController"))) {
    return;
  }
  
  id theMessage = [[inNotification userInfo] objectForKey:@"MessageKey"];
  
  if ([theMessage isKindOfClass:NSClassFromString(@"LibraryMessage")]) {
    NSDictionary* theSettings = [theMessage truePreviewSettings];
    
    if (
      ([[theSettings objectForKey:@"delay"] floatValue] == TRUEPREVIEW_DELAY_IMMEDIATE)
      || (
        [[theSettings objectForKey:@"window"] boolValue]
        && [self isKindOfClass:NSClassFromString(@"SingleMessageViewer")]
      )        
    ) {
      [self truePreviewReset];
      [theMessage truePreviewMarkAsViewed];
      
      return;
    }

    float theDelay = [[theSettings objectForKey:@"delay"] floatValue];
    
    if (theDelay > TRUEPREVIEW_DELAY_IMMEDIATE) {
      [self truePreviewReset];
      [self
        truePreviewSetTimer:[NSTimer
          scheduledTimerWithTimeInterval:theDelay
          target:self
          selector:@selector(truePreviewTimerFired:)
          userInfo:nil
          repeats:NO
        ]
      ];
    }
    
    if (
      ![self isKindOfClass:NSClassFromString(@"SingleMessageViewer")]
      && [[theSettings objectForKey:@"scroll"] boolValue]
    ) {
      // listen for bounds change notification on the message's clip view
      [[NSNotificationCenter defaultCenter]
        addObserver:self
        selector:@selector(truePreviewBoundsDidChange:)
        name:NSViewBoundsDidChangeNotification
        object:[[[[object_getIvar(self, class_getInstanceVariable([self class], "_contentController")) currentDisplay] contentView] enclosingScrollView] contentView]
      ];
    }    
  }
}

- (void)truePreviewReplyAllMessage:(id)inSender {
  id theMessage = [self currentDisplayedMessage];
  
  if ([theMessage isKindOfClass:NSClassFromString(@"LibraryMessage")]) {
    NSDictionary* theSettings = [theMessage truePreviewSettings];
    
    if ([[theSettings objectForKey:@"reply"] boolValue]) {
      [self truePreviewReset];
      [theMessage truePreviewMarkAsViewed];
    }
  }
  
  [self truePreviewReplyAllMessage:inSender];
}

- (void)truePreviewReplyMessage:(id)inSender {
  id theMessage = [self currentDisplayedMessage];
  
  if ([theMessage isKindOfClass:NSClassFromString(@"LibraryMessage")]) {
    NSDictionary* theSettings = [theMessage truePreviewSettings];

    if ([[theSettings objectForKey:@"reply"] boolValue]) {
      [self truePreviewReset];
      [theMessage truePreviewMarkAsViewed];
    }
  }
  
  [self truePreviewReplyMessage:inSender];
}

#pragma mark Accessors

- (NSTimer*)truePreviewTimer {
  return [[[self class] truePreviewTimers]
    objectForKey:[NSNumber numberWithUnsignedLong:(unsigned long)self]
  ];
}

- (void)truePreviewSetTimer:(NSTimer*)inTimer {
  [[[self class] truePreviewTimers]
    setObject:inTimer
    forKey:[NSNumber numberWithUnsignedLong:(unsigned long)self]
  ];
}

#pragma mark Instance methods

- (void)truePreviewReset {
  NSTimer* theTimer = [self truePreviewTimer];

  if ((theTimer != nil) && [theTimer isValid]) {
    [theTimer invalidate];
  }
  
  // stop observing when changed
  [[NSNotificationCenter defaultCenter]
    removeObserver:self
    name:NSViewBoundsDidChangeNotification
    object:[[[[object_getIvar(self, class_getInstanceVariable([self class], "_contentController")) currentDisplay] contentView] enclosingScrollView] contentView]
  ];
}

- (void)truePreviewTimerFired:(NSTimer*)inTimer {
  [self truePreviewReset];
  
  if ([[self currentDisplayedMessage] isKindOfClass:NSClassFromString(@"LibraryMessage")]) {
    [[self currentDisplayedMessage] truePreviewMarkAsViewed];
  }
}

- (void)truePreviewBoundsDidChange:(NSNotification*)inNotification {
  // ignore the first time we get the notification; it may be an initial scroll
  // to the origin after changing messages
  static BOOL sIsFirstTime = YES;
  
  if (sIsFirstTime) {
    sIsFirstTime = NO;
    
    return;
  }
  
  sIsFirstTime = YES;
  
  [self truePreviewReset];
  
  if ([[self currentDisplayedMessage] isKindOfClass:NSClassFromString(@"LibraryMessage")]) {
    [[self currentDisplayedMessage] truePreviewMarkAsViewed];
  }
}

@end
