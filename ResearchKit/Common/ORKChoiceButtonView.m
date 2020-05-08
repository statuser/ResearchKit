//
/*
 Copyright (c) 2020, Apple Inc. All rights reserved.
 
 Redistribution and use in source and binary forms, with or without modification,
 are permitted provided that the following conditions are met:
 
 1.  Redistributions of source code must retain the above copyright notice, this
 list of conditions and the following disclaimer.
 
 2.  Redistributions in binary form must reproduce the above copyright notice,
 this list of conditions and the following disclaimer in the documentation and/or
 other materials provided with the distribution.
 
 3.  Neither the name of the copyright holder(s) nor the names of any contributors
 may be used to endorse or promote products derived from this software without
 specific prior written permission. No license is granted to the trademarks of
 the copyright holders even if such marks are included in this software.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE
 FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "ORKButtonChoiceView.h"


@implementation ORKChoiceButtonView

- (instancetype)initWithImageChoice:(ORKImageChoice *)choice {
    self = [super init];
    if (self) {
        _labelText = choice.text.length > 0 ? choice.text: @" ";
        
        self.button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.exclusiveTouch = YES;
       
        if (choice.selectedStateImage) {
            [_button setImage:choice.selectedStateImage forState:UIControlStateSelected];
        }
        
        [_button setImage:choice.normalStateImage forState:UIControlStateNormal];
        
        _button.imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        [self addSubview:_button];
        ORKEnableAutoLayoutForViews(@[_button, _button.imageView]);
        [self setUpConstraints];
        
        // Accessibility
        NSString *trimmedText = [self.labelText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if ( trimmedText.length == 0 ) {
            self.button.accessibilityLabel = ORKLocalizedString(@"AX_UNLABELED_IMAGE", nil);
        } else {
            self.button.accessibilityLabel = self.labelText;
        }
    }
    return self;
}

- (instancetype)initWithButtonChoice:(ORKButtonChoice *)choice {
    self = [super init];
    if (self) {
        _labelText = choice.text.length > 0 ? choice.text: @" ";
        
        self.button = choice.button;
        _button.exclusiveTouch = YES;
        
        [self addSubview:_button];
        ORKEnableAutoLayoutForViews(@[_button, _button.imageView]);
        [self setUpConstraints];
        
        // Accessibility
        NSString *trimmedText = [self.labelText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if ( trimmedText.length == 0 ) {
            self.button.accessibilityLabel = ORKLocalizedString(@"AX_UNLABELED_IMAGE", nil);
        } else {
            self.button.accessibilityLabel = self.labelText;
        }
    }
    return self;
}


- (void)setUpConstraints {
    NSMutableArray *constraints = [NSMutableArray new];
    
    NSDictionary *views = @{ @"button": _button };
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[button]|"
                                                                             options:NSLayoutFormatDirectionLeadingToTrailing
                                                                             metrics:nil
                                                                               views:views]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[button]|"
                                                                             options:NSLayoutFormatDirectionLeadingToTrailing
                                                                             metrics:nil
                                                                               views:views]];
    
    UIImage *image = [_button imageForState:UIControlStateNormal];
    if (image.size.height > 0 && image.size.width > 0) {
        // Keep Aspect ratio
        [constraints addObject:[NSLayoutConstraint constraintWithItem:_button
                                                            attribute:NSLayoutAttributeHeight
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:_button.imageView
                                                            attribute:NSLayoutAttributeWidth
                                                           multiplier:image.size.height / image.size.width
                                                             constant:0.0]];
        // button's height <= image
        [constraints addObject:[NSLayoutConstraint constraintWithItem:_button
                                                            attribute:NSLayoutAttributeHeight
                                                            relatedBy:NSLayoutRelationLessThanOrEqual
                                                               toItem:nil attribute:NSLayoutAttributeHeight
                                                           multiplier:1.0
                                                             constant:image.size.height]];
    } else {
        // Keep Aspect ratio
        [constraints addObject:[NSLayoutConstraint constraintWithItem:_button
                                                            attribute:NSLayoutAttributeHeight
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:_button.imageView
                                                            attribute:NSLayoutAttributeWidth
                                                           multiplier:1.0
                                                             constant:0.0]];
        ORK_Log_Info("The size of imageChoice's normal image should not be zero. %@", image);
    }
    
    [NSLayoutConstraint activateConstraints:constraints];
}

@end

