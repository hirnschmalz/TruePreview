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

/*!
 * @header
 * Defines the <code>TruePreviewMessageViewer</code> category for
 * <code>MessageViewer</code>.
 * @copyright Copyright (c) 2009-2011 Jim Riggs, Christian Serving, L.L.C. All rights reserved.
 * @version \@(#) $Id: TruePreviewLibraryMessage.h 2 2009-06-27 07:02:45Z jhriggs $
 * @updated $Date: 2009-06-27 02:02:45 -0500 (Sat, 27 Jun 2009) $
 */

#import "TruePreviewLibraryMessage.h"

/*!
 * @class
 * Adds a method for overriding the "mark as viewed" behavior of
 * <code>MessageViewer</code>.
 * @version \@(#) $Id: TruePreviewLibraryMessage.h 2 2009-06-27 07:02:45Z jhriggs $
 * @updated $Date: 2009-06-27 02:02:45 -0500 (Sat, 27 Jun 2009) $
 */
@interface TruePreviewMessageViewer : NSObject {
}

#pragma mark Class methods
/*! @group Class methods */

/*!
 * Returns the timers for instances of this class.
 * @result
 *   The <code>NSMutableDictionary</code> containing the <code>NSTimer</code>
 *   for each instance of this class.  The key is an <code>NSNumber</code>
 *   (unsigned long) of the address of each instance.
 */
+ (NSMutableDictionary*)truePreviewTimers;

#pragma mark Swizzled instance methods
/*! @group Swizzled instance methods */

/*!
 * Invalidates this instance's timer and stops observing scroll changes before
 * deallocating.
 */
- (void)truePreviewDealloc;

/*!
 * Marks the currently-displayed message as read if configured to do so when
 * forwarding.
 * @param inSender
 *   Unused.
 */
- (void)truePreviewForwardAsAttachment:(id)inSender;

/*!
 * Marks the currently-displayed message as read if configured to do so when
 * forwarding.
 * @param inSender
 *   Unused.
 */
- (void)truePreviewForwardMessage:(id)inSender;

/*!
 * Invalidates this instance's timer and stops observing scroll changes when a
 * message is explicitly marked as read.
 * @param inSender
 *   Unused.
 */
- (void)truePreviewMarkAsRead:(id)inSender;

/*!
 * Invalidates this instance's timer and stops observing scroll changes when a
 * message is explicitly marked as unread.
 * @param inSender
 *   Unused.
 */
- (void)truePreviewMarkAsUnread:(id)inSender;

/*!
 * Invalidates this instance's timer and stops observing scroll changes.
 * @param inNotification
 *   The <code>NSNotification</code> describing the event.
 */
- (void)truePreviewMessageNoLongerDisplayedInTextView:(NSNotification*)inNotification;

/*!
 * Marks the displayed message as viewed, sets a timer to mark the displayed
 * message as viewed, and/or adds a notification observer to mark the message as
 * viewed when it is scrolled as appropriate.
 * @param inNotification
 *   The <code>NSNotification</code> describing the event.
 */
- (void)truePreviewMessageWasDisplayedInTextView:(id)inNotification;

/*!
 * Marks the currently-displayed message as read if configured to do so when
 * replying.
 * @param inSender
 *   Unused.
 */
- (void)truePreviewReplyAllMessage:(id)inSender;

/*!
 * Marks the currently-displayed message as read if configured to do so when
 * replying.
 * @param inSender
 *   Unused.
 */
- (void)truePreviewReplyMessage:(id)inSender;

#pragma mark Accessors
/*! @group Accessors */

/*!
 * Returns the timer for this instance.
 * @result
 *   The <code>NSTimer</code> for this instance.
 */
- (NSTimer*)truePreviewTimer;

/*!
 * Sets the timer for this instance.
 * @param inTimer
 *   The <code>NSTimer</code> for this instance.
 */
- (void)truePreviewSetTimer:(NSTimer*)inTimer;

#pragma mark Instance methods
/*! @group Instance methods */

/*!
 * Invalidates this instance's timer and stops observing scroll changes.
 */
- (void)truePreviewReset;

/*!
 * Marks the currently-displayed message as read.
 * @param inTimer
 *   Unused.
 */
- (void)truePreviewTimerFired:(NSTimer*)inTimer;

/*!
 * Marks the currently-displayed message as read.
 * @param inNotification
 *   Unused.
 */
- (void)truePreviewMessageClickedOrScrolled:(NSNotification*)inNotification;

@end
