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
 * Defines the <code>TruePreviewPreferencesModule</code>
 * <code>NSPreferencesModule</code> subclass.
 * @copyright Copyright (c) 2009-2011 Jim Riggs, Christian Serving, L.L.C. All rights reserved.
 * @version \@(#) $Id$
 * @updated $Date$
 */

#import <AppKit/NSPreferencesModule.h>

/*!
 * @class
 * The <code>TruePreviewPreferencesModule</code> class is the subclass of
 * <code>NSPreferencesModule</code> that displays and manages preferences
 * specific to the TruePreview plugin.
 * @version \@(#) $Id$
 * @updated $Date$
 */
@interface TruePreviewPreferencesModule : NSPreferencesModule {
#pragma mark IBOutlets
  /*! @group IBOutlets */
  
  /*!
   * The <code>NSArrayController</code> containing the account information
   * displayed in the TruePreview preferences panel.
   */
  IBOutlet NSArrayController* fldAccountArrayController;
}

#pragma mark NSPreferencesModule instance methods
/*! @group NSPreferencesModule instance methods */

/*!
 * Returns the name of the nib file containing the TruePreview preferences
 * panel.
 * @result
 *   <code>TruePreviewPreferencesPanel</code>.
 */
- (NSString*)preferencesNibName;

/*!
 * Loads the account information for the TruePreview preferences panel.
 */
- (void)willBeDisplayed;

#pragma mark NSKeyValueObserving instance methods
/*! @group NSKeyValueObserving instance methods */

/*!
 * Converts the account settings from the TruePreview preferences panel to a
 * dictionary and saves the dictionary into the user defaults.
 * @param inPath
 *   Unused.
 * @param inObject
 *   Unused.
 * @param inChange
 *   Unused.
 * @param inContext
 *   The <code>NSArray</code> containing the account settings from the
 *   TruePreview preferences panel.
 */
- (void)observeValueForKeyPath:(NSString*)inPath
    ofObject:(id)inObject
    change:(NSDictionary*)inChange
    context:(void*)inContext;

@end
