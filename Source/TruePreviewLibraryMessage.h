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
 * Defines the <code>TruePreviewLibraryMessage</code> category for
 * <code>LibraryMessage</code>.
 * @copyright Copyright (c) 2009-2011 Jim Riggs, Christian Serving, L.L.C. All rights reserved.
 * @version \@(#) $Id$
 * @updated $Date$
 */

#import "TruePreview.h"

/*!
 * @class
 * Adds a method for overriding the "mark as viewed" behavior of
 * <code>LibraryMessage</code>.
 * @version \@(#) $Id$
 * @updated $Date$
 */
@interface TruePreviewLibraryMessage : NSObject {
}

#pragma mark Swizzled instance methods
/*! @group Swizzled instance methods */

/*!
 * Does nothing.  The replacement behavior is handled in
 * <code>TruePreviewMessageViewer</code>.
 */
- (void)truePreviewMarkAsViewed;

#pragma mark Instance methods
/*! @group Instance methods */

/*!
 * Returns the TruePreview settings appropriate for this message.
 * @result
 *   An <code>NSMutableDictionary</code> containing the keys <code>delay</code>,
 *   <code>window</code>, and <code>scroll</code> and their respective values
 *   based on the default settings and/or the settings for this message's
 *   account.
 */
- (NSMutableDictionary*)truePreviewSettings;

@end
