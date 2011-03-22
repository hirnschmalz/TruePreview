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
 * Defines the <code>TruePreview</code> Mail bundler (the entrypoint for the
 * plugin) and the <code>TruePreviewObject</code> category for
 * <code>NSObject</code>.
 * @copyright Copyright (c) 2009-2011 Jim Riggs, Christian Serving, L.L.C. All rights reserved.
 * @version \@(#) $Id$
 * @updated $Date$
 */

#import <objc/objc-class.h>

#import "TruePreviewLibraryMessage.h"
#import "TruePreviewMessageViewer.h"
#import "TruePreviewPreferences.h"
#import "TruePreviewPreferencesModule.h"
#import "TruePreviewPreferenceValueTransformer.h"

/*!
 * @class
 * The <code>TruePreview</code> class is the subclass of
 * <code>MVMailBundle</code> that provides the plugin entrypoint for the
 * TruePreview plugin.
 * @version \@(#) $Id$
 * @updated $Date$
 */
@interface TruePreview : NSObject {
}

#pragma mark Class initialization
/*! @group Class initialization */

/*!
 * Registers this plugin and swizzles the methods necessary for TruePreview's
 * functionality.
 */
+ (void)initialize;

#pragma mark MVMailBundle class methods
/*! @group MVMailBundle class methods */

/*!
 * Indicates that this plugin has a preference panel.
 * @result
 *   <code>YES</code>.
 */
+ (BOOL)hasPreferencesPanel;

/*!
 * Returns the class name for this plugin's preference panel owner.
 * @result
 *   <code>TruePreviewPreferencesModule</code>.
 */
+ (NSString*)preferencesOwnerClassName;

/*!
 * Returns the name for this plugin's preferences panel.
 * @result
 *   <code>TruePreview</code>.
 */
+ (NSString*)preferencesPanelName;

@end

/*!
 * @category
 * Adds a method for method swizzling to <code>NSObject</code> instances.
 * @version \@(#) $Id$
 * @updated $Date$
 */
@interface NSObject (TruePreviewObject)

#pragma mark Class methods
/*! @group Class methods */

/*!
 * Adds the methods from this class to the specified class.  This is in essence
 * adding a category, but we do it through the objective-c runtime, because of
 * the "hiding" of classes in >= 10.6.
 * @param inClass
 *   The <code>Class</code> to which this class's methods should be added.
 */
+ (void)truePreviewAddAsCategoryToClass:(Class)inClass;

/*!
 * Swaps ("swizzles") two methods.  Based on
 * <a href="http://www.cocoadev.com/index.pl?MethodSwizzling">http://www.cocoadev.com/index.pl?MethodSwizzling</a>.
 * @param inOriginalSelector
 *   The selector specifying the method being replaced.
 * @param inReplacementSelector
 *   The selector specifying the replacement method.
 * @param inIsClassMethod
 *   The <code>BOOL</code> indicating whether or not the methods being swizzled
 *   are class methods.
 */
+ (void)truePreviewSwizzleMethod:(SEL)inOriginalSelector withMethod:(SEL)inReplacementSelector isClassMethod:(BOOL)inIsClassMethod;

@end