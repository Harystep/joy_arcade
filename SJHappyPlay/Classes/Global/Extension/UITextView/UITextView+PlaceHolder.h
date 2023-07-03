//
//  UITextView+PlaceHolder.h
//  Psychosis
//
//  Created by lang on 2019/2/20.
//  Copyright © 2019 cnovit. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextView (PlaceHolder)

- (void)setTextViewPlaceHolder:(NSString *)placeHolder;
- (void)setTextViewPlaceHolder:(NSString *)placeHolder font:(NSInteger)fontsize;

@end

NS_ASSUME_NONNULL_END
