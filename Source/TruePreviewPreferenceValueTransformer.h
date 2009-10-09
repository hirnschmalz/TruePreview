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

/*!
 * @header
 * Defines the <code>TruePreviewPreferenceValueTransformer</code>
 * <code>NSValueTransformer</code> subclasses.
 * @copyright Copyright (c) 2009 Jim Riggs, Christian Serving, L.L.C. All rights reserved.
 * @version \@(#) $Id: TruePreviewPreferencesModule.h 2 2009-06-27 07:02:45Z jhriggs $
 * @updated $Date: 2009-06-27 02:02:45 -0500 (Sat, 27 Jun 2009) $
 */

/*!
 * @class
 * The <code>TruePreviewPreferenceValueTransformer</code> class is the subclass
 * of <code>NSValueTransformer</code> that selects the correct radio button in
 * the TruePreview preferences panel.
 * @version \@(#) $Id: TruePreviewPreferencesModule.h 2 2009-06-27 07:02:45Z jhriggs $
 * @updated $Date: 2009-06-27 02:02:45 -0500 (Sat, 27 Jun 2009) $
 */
@interface TruePreviewPreferenceValueTransformer : NSValueTransformer {
}

#pragma mark NSValueTransformer class methods
/*! @group NSValueTransformer class methods */

/*!
 * Returns the class of transformed values for this value transformer
 * (NSNumber).
 * @result
 *   <code>[NSNumber class]</code>.
 */
+ (Class)transformedValueClass;

#pragma mark NSValueTransformer instance methods
/*! @group NSValueTransformer instance methods */

/*!
 * Returns an <code>NSNumber</code> equivalent to the provided value if the
 * value is <code>TRUEPREVIEW_DELAY_IMMEDIATE</code>,
 * <code>TRUEPREVIEW_DELAY_DEFAULT</code>,
 * <code>TRUEPREVIEW_DELAY_NEVER</code>, or &gt; 0 to
 * <code>TRUEPREVIEW_DELAY_MAX</code>; otherwise,
 * <code>TRUEPREVIEW_DELAY_DEFAULT</code> is returned.
 * @param inValue
 *   The value being transformed.
 * @result
 *   An <code>NSNumber</code> containing the transformed value.
 */
- (id)transformedValue:(id)inValue;

@end

/*!
 * @class
 * The <code>TruePreviewPreferenceValueTransformerDelay</code> class is the
 * subclass of <code>NSValueTransformer</code> that provides a value appropriate
 * to display in controls in the TruePreview preferences panel.
 * @version \@(#) $Id: TruePreviewPreferencesModule.h 2 2009-06-27 07:02:45Z jhriggs $
 * @updated $Date: 2009-06-27 02:02:45 -0500 (Sat, 27 Jun 2009) $
 */
@interface TruePreviewPreferenceValueTransformerDelay : NSValueTransformer {
}

#pragma mark NSValueTransformer class methods
/*! @group NSValueTransformer class methods */

/*!
 * Returns the class of transformed values for this value transformer
 * (NSNumber).
 * @result
 *   <code>[NSNumber class]</code>.
 */
+ (Class)transformedValueClass;

#pragma mark NSValueTransformer instance methods
/*! @group NSValueTransformer instance methods */

/*!
 * Returns an <code>NSNumber</code> for displaying the delay in controls (i.e.
 * &gt; 0 to <code>TRUEPREVIEW_DELAY_MAX</code> or <code>nil</code>).
 * @param inValue
 *   The value being transformed.
 * @result
 *   An <code>NSNumber</code> containing the transformed value.
 */
- (id)transformedValue:(id)inValue;

@end

/*!
 * @class
 * The <code>TruePreviewPreferenceValueTransformerDelayEditIndicator</code>
 * class is the subclass of <code>NSValueTransformer</code> that indicates
 * whether or not delay controls should be enabled in the TruePreview
 * preferences panel.
 * @version \@(#) $Id: TruePreviewPreferencesModule.h 2 2009-06-27 07:02:45Z jhriggs $
 * @updated $Date: 2009-06-27 02:02:45 -0500 (Sat, 27 Jun 2009) $
 */
@interface TruePreviewPreferenceValueTransformerDelayEditIndicator : NSValueTransformer {
}

#pragma mark NSValueTransformer class methods
/*! @group NSValueTransformer class methods */

/*!
 * Returns the class of transformed values for this value transformer
 * (NSNumber).
 * @result
 *   <code>[NSNumber class]</code>.
 */
+ (Class)transformedValueClass;

#pragma mark NSValueTransformer instance methods
/*! @group NSValueTransformer instance methods */

/*!
 * Returns an <code>NSNumber</code> indicating whether or not delay controls
 * should be enabled (i.e. delay is &gt; 0 to
 * <code>TRUEPREVIEW_DELAY_MAX</code>).
 * @param inValue
 *   The value being transformed.
 * @result
 *   An <code>NSNumber</code> containing the transformed value.
 */
- (id)transformedValue:(id)inValue;

@end
